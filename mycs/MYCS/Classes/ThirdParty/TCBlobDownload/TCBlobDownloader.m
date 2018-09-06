//
//  TCBlobDownload.m
//
//  Created by Thibault Charbonnier on 15/04/13.
//  Copyright (c) 2013 Thibault Charbonnier. All rights reserved.
//

static const double kBufferSize                    = 1000 * 1000; // 1 MB
static const NSTimeInterval kDefaultRequestTimeout = 30;
static const NSInteger kNumberOfSamples            = 5;

NSString *const TCBlobDownloadErrorDomain        = @"com.thibaultcha.tcblobdownload";
NSString *const TCBlobDownloadErrorHTTPStatusKey = @"TCBlobDownloadErrorHTTPStatusKey";

#import "TCBlobDownloader.h"
#import "TCBlobDownloadManager.h"
#import "VideoCacheDownloadManager.h"

@interface TCBlobDownloader ()

// Public
@property (nonatomic, strong, readwrite) NSMutableURLRequest *fileRequest;
@property (nonatomic, copy, readwrite) NSURL *downloadURL;
@property (nonatomic, copy, readwrite) NSString *pathToFile;
@property (nonatomic, copy, readwrite) NSString *pathToDownloadDirectory;
@property (nonatomic, assign, readwrite) TCBlobDownloadState state;
// Download
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receivedDataBuffer;
@property (nonatomic, strong) NSFileHandle *file;
// Speed rate and remaining time
@property (nonatomic, strong) NSTimer *speedTimer;
@property (nonatomic, strong) NSMutableArray *samplesOfDownloadedBytes;
@property (nonatomic, assign) uint64_t expectedDataLength;
@property (nonatomic, assign) uint64_t receivedDataLength;
@property (nonatomic, assign) uint64_t previousTotal;
@property (nonatomic, assign, readwrite) NSInteger speedRate;
@property (nonatomic, assign, readwrite) NSInteger remainingTime;
// Blocks
@property (nonatomic, copy) void (^firstResponseBlock)(NSURLResponse *response);
@property (nonatomic, copy) void (^progressBlock)(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress);
@property (nonatomic, copy) void (^errorBlock)(NSError *error);
@property (nonatomic, copy) void (^completeBlock)(BOOL downloadFinished, NSString *pathToFile);

+ (NSNumber *)freeDiskSpace;

- (void)finishOperationWithState:(TCBlobDownloadState)state;
- (void)notifyFromCompletionWithError:(NSError *)error pathToFile:(NSString *)pathToFile;
- (void)updateTransferRate;
- (BOOL)removeFileWithError:(NSError *__autoreleasing *)error;
@end

@implementation TCBlobDownloader

@dynamic pathToFile;
@dynamic remainingTime;

#pragma mark - Dealloc

- (void)dealloc {
    [self.speedTimer invalidate];
}


#pragma mark - Init


- (instancetype)initWithURL:(NSURL *)url
               downloadPath:(NSString *)pathToDL
                   delegate:(id<TCBlobDownloaderDelegate>)delegateOrNil {
    self = [super init];
    if (self)
    {
        self.downloadURL             = url;
        self.delegate                = delegateOrNil;
        self.pathToDownloadDirectory = pathToDL;
        self.state                   = TCBlobDownloadStateReady;
        self.fileRequest             = [NSMutableURLRequest requestWithURL:self.downloadURL
                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                               timeoutInterval:kDefaultRequestTimeout];
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url
               downloadPath:(NSString *)pathToDL
              firstResponse:(void (^)(NSURLResponse *response))firstResponseBlock
                   progress:(void (^)(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress))progressBlock
                      error:(void (^)(NSError *error))errorBlock
                   complete:(void (^)(BOOL downloadFinished, NSString *pathToFile))completeBlock {
    self = [self initWithURL:url downloadPath:pathToDL delegate:nil];
    if (self)
    {
        self.firstResponseBlock = firstResponseBlock;
        self.progressBlock      = progressBlock;
        self.errorBlock         = errorBlock;
        self.completeBlock      = completeBlock;
    }
    return self;
}


#pragma mark - NSOperation Override


- (void)start {
    if ([self isCancelled])
    {
        return;
    }

    // If we can't handle the request, better cancelling the operation right now
    if (![NSURLConnection canHandleRequest:self.fileRequest])
    {
        NSError *error = [NSError errorWithDomain:TCBlobDownloadErrorDomain
                                             code:TCBlobDownloadErrorInvalidURL
                                         userInfo:@{ NSLocalizedDescriptionKey :
                                                         [NSString stringWithFormat:@"Invalid URL provided: %@", self.fileRequest.URL] }];

        [self notifyFromCompletionWithError:error pathToFile:nil];
        return;
    }

    NSFileManager *fm = [NSFileManager defaultManager];

    // Create download directory
    NSError *createDirError = nil;
    if (![fm createDirectoryAtPath:self.pathToDownloadDirectory
            withIntermediateDirectories:YES
                             attributes:nil
                                  error:&createDirError])
    {
        [self notifyFromCompletionWithError:createDirError pathToFile:nil];
        return;
    }

    // Test if file already exists (partly downloaded) to set HTTP `bytes` header or not
    if (![fm fileExistsAtPath:self.pathToFile])
    {
        [fm createFileAtPath:self.pathToFile
                    contents:nil
                  attributes:nil];
    }
    else
    {
        uint64_t fileSize = [[fm attributesOfItemAtPath:self.pathToFile error:nil] fileSize];
        NSString *range   = [NSString stringWithFormat:@"bytes=%lld-", fileSize];
        [self.fileRequest setValue:range forHTTPHeaderField:@"Range"];
        // Allow progress to reflect what's already downloaded
        self.receivedDataLength += fileSize;
    }

    // Initialization of everything we'll need to download the file
    self.file                     = [NSFileHandle fileHandleForWritingAtPath:self.pathToFile];
    self.receivedDataBuffer       = [[NSMutableData alloc] init];
    self.samplesOfDownloadedBytes = [[NSMutableArray alloc] init];
    self.connection               = [[NSURLConnection alloc] initWithRequest:self.fileRequest
                                                      delegate:self
                                              startImmediately:NO];

    if (self.connection && ![self isCancelled])
    {
        [self willChangeValueForKey:@"isExecuting"];
        self.state = TCBlobDownloadStateDownloading;
        [self didChangeValueForKey:@"isExecuting"];

        [self.file seekToEndOfFile];

        // Start the download
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [self.connection scheduleInRunLoop:runLoop
                                   forMode:NSDefaultRunLoopMode];
        [self.connection start];

        // Start the speed timer to schedule speed download on a periodic basis
        self.speedTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(updateTransferRate)
                                                         userInfo:nil
                                                          repeats:YES];
        [runLoop addTimer:self.speedTimer forMode:NSRunLoopCommonModes];
        [runLoop run];
    }
}

- (BOOL)isExecuting {
    return self.state == TCBlobDownloadStateDownloading;
}

- (BOOL)isCancelled {
    return self.state == TCBlobDownloadStateCancelled;
}

- (BOOL)isFinished {
    return self.state == TCBlobDownloadStateCancelled || self.state == TCBlobDownloadStateDone || self.state == TCBlobDownloadStateFailed;
}


#pragma mark - NSURLConnection Delegate


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self notifyFromCompletionWithError:error pathToFile:self.pathToFile];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // If anything was previousy downloaded, add it to the total expected length for the progress property
    self.expectedDataLength = self.receivedDataLength + [response expectedContentLength];

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSError *error;
    if (httpResponse.statusCode >= 400)
    {
        error = [NSError errorWithDomain:TCBlobDownloadErrorDomain
                                    code:TCBlobDownloadErrorHTTPError
                                userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Erroneous HTTP status code %ld (%@)",
                                                                                                   (long)httpResponse.statusCode,
                                                                                                   [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]],
                                            TCBlobDownloadErrorHTTPStatusKey : @(httpResponse.statusCode) }];
    }

    long long expected = @(self.expectedDataLength).longLongValue;
    if ([TCBlobDownloader freeDiskSpace].longLongValue < expected && expected != -1)
    {
        error = [NSError errorWithDomain:TCBlobDownloadErrorDomain
                                    code:TCBlobDownloadErrorNotEnoughFreeDiskSpace
                                userInfo:@{ NSLocalizedDescriptionKey : @"Not enough free disk space" }];
    }

    if (!error)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
        //
        [self.receivedDataBuffer setData:nil];
#pragma clang diagnostic pop

        dispatch_async(dispatch_get_main_queue(), ^{

            [self startDownload];

            if (self.firstResponseBlock)
            {
                self.firstResponseBlock(response);
            }
            if ([self.delegate respondsToSelector:@selector(download:didReceiveFirstResponse:)])
            {
                [self.delegate download:self didReceiveFirstResponse:response];
            }
        });
    }
    else
    {
        [self notifyFromCompletionWithError:error pathToFile:self.pathToFile];
    }
}

//下载出错
- (void)downloadError:(NSError *)error {
    NSNumber *code = error.userInfo[@"TCBlobDownloadErrorHTTPStatusKey"];
    //下载出错
    if (code.intValue != 416)
    {
        [VideoCacheDownloadManager setDownloadChapterWith:self.progress downloadStatus:DownloadStatusError accountChapterId:self.chapterId];
    }
    else
    {
        if (self.progress > 0.99)
        {
            [self downloadComplete];
        }
    }
}

//开始下载
- (void)startDownload {
    //将当前的下载状态改为正在下载
    [VideoCacheDownloadManager setDownloadChapterWith:0.0 downloadStatus:DownloadStatusDowning accountChapterId:self.chapterId];
}

//下载完成
- (void)downloadComplete {
    //设置当前下载的状态
    [VideoCacheDownloadManager setDownloadChapterWith:1.0 downloadStatus:DownloadStatusComplete accountChapterId:self.chapterId];

    //设置有一个章节下载完成
    [VideoCacheDownloadManager setObjectFirstCompleteWithId:self.objId];

    //设置具体哪个章节下载完成
    VideoCacheDownloadObject *cacheObj = [VideoCacheDownloadManager objectWithId:self.objId];

    //视频
    if ([cacheObj.objType isEqualToString:CacheObjectTypeVideo])
    {
        VideoDetail *detail = cacheObj.obj;
        //总视频大小
        detail.fileSize         = [self formatByteCount:self.totalLength];
        detail.downloadComplete = YES;
        [VideoCacheDownloadManager updateCacheObjectWith:detail account:self.objId];

    } //教程
    else if ([cacheObj.objType isEqualToString:CacheObjectTypeCourse])
    {
        CourseDetail *course = cacheObj.obj;

        for (ChapterModel *model in course.chapters)
        {
            if ([model.chapterId isEqualToString:self.chapterId])
            {
                model.fileSize         = [self formatByteCount:self.totalLength];
                model.downloadComplete = YES;
            }
        }

        [VideoCacheDownloadManager updateCacheObjectWith:course account:self.objId];

    } //SOP
    else if ([cacheObj.objType isEqualToString:CacheObjectTypeSOP])
    {
        SopDetail *sop = cacheObj.obj;
        for (SopCourseModel *course in sop.sopCourse)
        {
            for (ChapterModel *model in course.chapters)
            {
                if ([model.chapterId isEqualToString:self.chapterId])
                {
                    model.fileSize         = [self formatByteCount:self.totalLength];
                    model.downloadComplete = YES;
                }
            }
        }

        [VideoCacheDownloadManager updateCacheObjectWith:sop account:self.objId];
    }

    //获取下一个要下载的对象
    DownloadChapterObject *nextChapterObj = [VideoCacheDownloadManager nextWaitingChapterObjectByChapterId:self.chapterId];

    //下载下一个视频
    [VideoCacheDownloadManager downloadChapterWith:nextChapterObj];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedDataBuffer appendData:data];
    self.receivedDataLength += [data length];

    TCLog(@"%@ | %.2f%% - Received: %ld - Total: %ld",
          self.pathToFile,
          (float)self.receivedDataLength / self.expectedDataLength * 100,
          (long)self.receivedDataLength, (long)self.expectedDataLength);

    if (self.receivedDataBuffer.length > kBufferSize && [self isExecuting])
    {
        [self.file writeData:self.receivedDataBuffer];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
        //
        [self.receivedDataBuffer setData:nil];
#pragma clang diagnostic pop
    }

    self.totalLength     = self.expectedDataLength;
    self.totalByteWriten = self.receivedDataLength;

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.progressBlock)
        {
            self.progressBlock(self.receivedDataLength, self.expectedDataLength, self.remainingTime, self.progress);
        }

        if ([self.delegate respondsToSelector:@selector(download:didReceiveData:onTotal:progress:)])
        {
            [self.delegate download:self
                     didReceiveData:self.receivedDataLength
                            onTotal:self.expectedDataLength
                           progress:self.progress];
        }
    });
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self isExecuting])
    {
        [self.file writeData:self.receivedDataBuffer];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
        //
        [self.receivedDataBuffer setData:nil];
#pragma clang diagnostic pop

        [self notifyFromCompletionWithError:nil pathToFile:self.pathToFile];
    }
}


#pragma mark - Public Methods


- (void)cancelDownloadAndRemoveFile:(BOOL)remove {
    // Cancel the connection before deleting the file
    [self.connection cancel];

    if (remove)
    {
        NSError *error;
        if (![self removeFileWithError:&error])
        {
            [self notifyFromCompletionWithError:error pathToFile:nil];
            return;
        }
    }

    [self cancel];
}

- (void)addDependentDownload:(TCBlobDownloader *)download {
    [self addDependency:download];
}


#pragma mark - Internal Methods


- (void)finishOperationWithState:(TCBlobDownloadState)state {
    // Cancel the connection in case cancel was called directly
    [self.connection cancel];
    [self.speedTimer invalidate];
    [self.file closeFile];

    // Let's finish the operation once and for all
    if ([self isExecuting])
    {
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        self.state = state;
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
    }
    else
    {
        [self willChangeValueForKey:@"isExecuting"];
        self.state = state;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (void)cancel {
    [self willChangeValueForKey:@"isCancelled"];
    [self finishOperationWithState:TCBlobDownloadStateCancelled];
    [self didChangeValueForKey:@"isCancelled"];
}

- (void)notifyFromCompletionWithError:(NSError *)error pathToFile:(NSString *)pathToFile {
    BOOL success = error == nil;

    // Notify from error if any
    if (error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

            [self downloadError:error];

            if (self.errorBlock)
            {
                self.errorBlock(error);
            }
            if ([self.delegate respondsToSelector:@selector(download:didStopWithError:)])
            {
                [self.delegate download:self didStopWithError:error];
            }
        });
    }

    // Notify from completion if the operation
    dispatch_async(dispatch_get_main_queue(), ^{

        if (success)
        {
            [self downloadComplete];
        }

        if (self.completeBlock)
        {
            self.completeBlock(success, pathToFile);
        }

        if ([self.delegate respondsToSelector:@selector(download:didFinishWithSuccess:atPath:)])
        {
            [self.delegate download:self didFinishWithSuccess:success atPath:pathToFile];
        }

    });

    // Finish the operation
    TCBlobDownloadState finalState = success ? TCBlobDownloadStateDone : TCBlobDownloadStateFailed;
    [self finishOperationWithState:finalState];
}

//获取文件的大小
- (long long)fileSize:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }

    return 0;
}

//容量格式化输出
- (NSString *)formatByteCount:(long long)size {
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}

- (void)updateTransferRate {
    if (self.samplesOfDownloadedBytes.count > kNumberOfSamples)
    {
        [self.samplesOfDownloadedBytes removeObjectAtIndex:0];
    }

    // Add the sample
    [self.samplesOfDownloadedBytes addObject:[NSNumber numberWithUnsignedLongLong:self.receivedDataLength - self.previousTotal]];
    self.previousTotal = self.receivedDataLength;
    // Compute the speed rate on the average of the last seconds samples
    self.speedRate = [[self.samplesOfDownloadedBytes valueForKeyPath:@"@avg.longValue"] longValue];
}

- (BOOL)removeFileWithError:(NSError *__autoreleasing *)error {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:self.pathToFile])
    {
        return [fm removeItemAtPath:self.pathToFile error:error];
    }

    return YES;
}

+ (NSNumber *)freeDiskSpace {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}


#pragma mark - Custom Getters


- (NSString *)fileName {
    return _fileName ? _fileName : [[NSURL URLWithString:[self.downloadURL absoluteString]] lastPathComponent];
}

- (NSString *)pathToFile {
    return [self.pathToDownloadDirectory stringByAppendingPathComponent:self.fileName];
}

- (NSInteger)remainingTime {
    return self.speedRate > 0 ? ((NSInteger)(self.expectedDataLength - self.receivedDataLength) / self.speedRate) : -1;
}

- (float)progress {
    return (_expectedDataLength == 0) ? 0 : (float)self.receivedDataLength / (float)self.expectedDataLength;
}

@end
