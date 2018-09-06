//
//  VideoDownloadingController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "VideoDownloadingController.h"
#import "TCBlobDownload.h"
#import "NSString+Util.h"
#import "VideoCacheDownloadManager.h"
#import "ChapterModel.h"
#import "UIImageView+WebCache.h"

static NSString *reuseID = @"VideoDownLoadCell";

@interface VideoDownloadingController ()<UITableViewDelegate,UITableViewDataSource,TCBlobDownloaderDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) TCBlobDownloadManager *sharedManager;

//下载列表数据
@property (nonatomic,strong) NSArray *dataSource;

//是否进入编辑状态
@property (nonatomic,assign) BOOL expand;
//是否全选
@property (nonatomic,assign) BOOL cellChoose;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

//要删除的模型数组
@property (nonatomic,strong) NSMutableArray *deleteArr;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@property (weak, nonatomic) IBOutlet UIButton *allPauseOrStartBtn;

@end

@implementation VideoDownloadingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.deleteArr = [NSMutableArray array];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.bottomConst.constant = -50;
    
    [self reloadTableView];
}

- (void)reloadTableView {
    
    self.dataSource = [VideoCacheDownloadManager downloadChapterListExceptComplete];
    
    [self.tableView reloadData];
    
    TCBlobDownloadManager *manage = [TCBlobDownloadManager sharedInstance];
    TCBlobDownloader *downloader = [manage.operationQueue.operations firstObject];
    
    downloader.delegate = self;
    
    self.allPauseOrStartBtn.selected = manage.currentDownloadsCount>0?NO:YES;
}

#pragma mark - Action
- (IBAction)editAction:(UIBarButtonItem *)button {
    
    self.expand = !self.expand;
    
    NSString *title = self.expand?@"取消":@"编辑";
    [button setTitle:title];
    
    [self.tableView reloadData];
    
    self.bottomConst.constant = self.expand?0:-50;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark -- 暂停按钮
- (IBAction)pauseAllAction:(UIButton *)button {
    
    button.selected = !button.selected;
    
    if (button.selected)
    {
        [self allPause];
    }
    else
    {
        [self allStart];
    }
    
    [self reloadTableView];
}

//全部暂停
- (void)allPause {
    
    [VideoCacheDownloadManager cancelCurrentDownload];
    
    for (DownloadChapterObject *chapterObj in self.dataSource)
    {
        [VideoCacheDownloadManager setDownloadChapterWith:-1 downloadStatus:DownloadStatusPause accountChapterId:chapterObj.chapterId];
    }
    
}

//全部开始
- (void)allStart {
    
    for (DownloadChapterObject *chapterObj in self.dataSource)
    {
        [VideoCacheDownloadManager setDownloadChapterWith:-1 downloadStatus:DownloadStatusWaiting accountChapterId:chapterObj.chapterId];
    }
    
    DownloadChapterObject *chapterObj = [self.dataSource firstObject];
    [VideoCacheDownloadManager downloadChapterWith:chapterObj];
    
}
#pragma mark -- 选择按钮
- (IBAction)selectAction:(UIButton *)button {
    
    button.selected = !button.selected;
    self.cellChoose = !self.cellChoose;
    [self.tableView reloadData];
    
    if (button.selected)
    {
        self.deleteArr = [NSMutableArray arrayWithArray:self.dataSource];
        NSString *title = [NSString stringWithFormat:@"删除(%ld)",(unsigned long)self.deleteArr.count];
        [self.deleteBtn setTitle:title forState:UIControlStateNormal];
    }
    else
    {
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
}
#pragma mark -- 删除按钮
- (IBAction)deleteAction:(id)sender {
    
    if (self.deleteArr.count==0) return;
    
    for (DownloadChapterObject *chapterObj in self.deleteArr)
    {
        
        [VideoCacheDownloadManager deleteDownloadChapterByChapterId:chapterObj.chapterId];
    }
    
    [self resetUI];
}

- (void)resetUI {
    
    self.expand = NO;
    
    [self reloadTableView];
    self.deleteArr = [NSMutableArray array];
    
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.rightItem setTitle:@"编辑"];
    self.bottomConst.constant = -50;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark - CustomDelegate
- (void)download:(TCBlobDownloader *)blobDownload didFinishWithSuccess:(BOOL)downloadFinished atPath:(NSString *)pathToFile {
    
    [self reloadTableView];
}

- (void)download:(TCBlobDownloader *)blobDownload didStopWithError:(NSError *)error {
    [self reloadTableView];
}

- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response {
    
    self.allPauseOrStartBtn.selected = NO;
    [self updateCellWith:blobDownload];

}

- (void)download:(TCBlobDownloader *)blobDownload didReceiveData:(uint64_t)receivedLength onTotal:(uint64_t)totalLength progress:(float)progress {
    
    [self updateCellWith:blobDownload];
    
}

- (void)updateCellWith:(TCBlobDownloader *)blobDownload {
    
    NSInteger idx = 0;
    for (int i = 0; i<self.dataSource.count; i++)
    {
        DownloadChapterObject *chapterObj = self.dataSource[i];
        if ([blobDownload.chapterId isEqualToString:chapterObj.chapterId])
        {
            idx = i;
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    
    VideoDownLoadCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.downloader = blobDownload;
    
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoDownLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    cell.chapterObj = self.dataSource[indexPath.row];
    
    cell.expand = self.expand;
    cell.choose = self.cellChoose;
    
    [self setCellChooseAction:cell];
    
    return cell;
}

- (void)setCellChooseAction:(VideoDownLoadCell *)cell {
    
    cell.chooseBtnAction = ^(DownloadChapterObject *object,BOOL choose) {
        
        if (choose)
        {
            [self.deleteArr addObject:object];
        }
        else
        {
            [self.deleteArr removeObject:object];
        }
        
        NSString *title = [NSString stringWithFormat:@"删除(%ld)",(unsigned long)self.deleteArr.count];
        [self.deleteBtn setTitle:title forState:UIControlStateNormal];
        
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DownloadChapterObject *chapterObj = self.dataSource[indexPath.row];
    
    if (chapterObj.status==DownloadStatusWaiting)
    {
        [VideoCacheDownloadManager cancelCurrentDownload];
        [VideoCacheDownloadManager downloadChapterWith:chapterObj];
        [VideoCacheDownloadManager setDownloadChapterWith:-1 downloadStatus:DownloadStatusDowning accountChapterId:chapterObj.chapterId];
    }
    else if (chapterObj.status==DownloadStatusPause)
    {
        [VideoCacheDownloadManager cancelCurrentDownload];
        [VideoCacheDownloadManager downloadChapterWith:chapterObj];
        [VideoCacheDownloadManager setDownloadChapterWith:-1 downloadStatus:DownloadStatusDowning accountChapterId:chapterObj.chapterId];
    }
    else if (chapterObj.status==DownloadStatusDowning)
    {
        
        [VideoCacheDownloadManager pauseCurrentDownload];
        
        [VideoCacheDownloadManager setDownloadChapterWith:-1 downloadStatus:DownloadStatusPause accountChapterId:chapterObj.chapterId];
    }else if(chapterObj.status == DownloadStatusError)
    {
        [VideoCacheDownloadManager cancelCurrentDownload];
        [VideoCacheDownloadManager downloadChapterWith:chapterObj];
        [VideoCacheDownloadManager setDownloadChapterWith:-1 downloadStatus:DownloadStatusDowning accountChapterId:chapterObj.chapterId];
    }
    
    [self reloadTableView];
    
}

- (void)dealloc {
    
    for (TCBlobDownloader *downloader in self.sharedManager.operationQueue.operations)
    {
        downloader.delegate = nil;
    }
    
}

#pragma mark - Getter&Setter
- (TCBlobDownloadManager *)sharedManager {
    
    if (!_sharedManager)
    {
        TCBlobDownloadManager *sharedManager = [TCBlobDownloadManager sharedInstance];
        _sharedManager = sharedManager;
    }
    
    return _sharedManager;
}

@end

@interface VideoDownLoadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConst;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@end

@implementation VideoDownLoadCell

- (void)setExpand:(BOOL)expand {
    _expand = expand;
    
    self.leftConst.constant = expand?0:-40;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
    
}

- (IBAction)chooseBtnAction:(UIButton *)button {
    
    button.selected = !button.selected;
    
    if (self.chooseBtnAction)
    {
        self.chooseBtnAction(self.chapterObj,button.selected);
    }
    
}

- (void)setChoose:(BOOL)choose {
    _choose = choose;
    
    self.chooseBtn.selected = choose;
}

- (void)setChapterObj:(DownloadChapterObject *)chapterObj {
    _chapterObj = chapterObj;
    
    ChapterModel *chapter = chapterObj.chapter;
    self.titlelabel.text = chapter.name;
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:chapter.picUrl] placeholderImage:PlaceHolderImage];
    self.downloadProgress.progress = chapterObj.progress;
    
    if (chapterObj.status == DownloadStatusWaiting)
    {
        self.sizeLabel.text = @"等待下载";
        self.sizeLabel.textColor = [UIColor orangeColor];
        self.rateLabel.hidden = YES;
        [self.statusBtn setImage:[UIImage imageNamed:@"waitting-0"] forState:UIControlStateNormal];
    }
    else if (chapterObj.status == DownloadStatusPause)
    {
        self.sizeLabel.text = @"暂停下载";
        self.sizeLabel.textColor = [UIColor orangeColor];
        self.rateLabel.hidden = YES;
        [self.statusBtn setImage:[UIImage imageNamed:@"stop-0"] forState:UIControlStateNormal];
    }
    else if (chapterObj.status == DownloadStatusError)
    {
        self.sizeLabel.text = @"下载出错";
        self.sizeLabel.textColor = [UIColor redColor];
        self.rateLabel.hidden = YES;
        [self.statusBtn setImage:[UIImage imageNamed:@"waitting-0"] forState:UIControlStateNormal];
    }
    
    
}

- (void)setDownloader:(TCBlobDownloader *)downloader {
    
    _downloader = downloader;
    
    DownloadChapterObject *chapterObj = [VideoCacheDownloadManager downloadObjectWithChpaterId:downloader.chapterId];
    
    if (chapterObj.status != DownloadStatusDowning) return;
    
    self.titlelabel.text = downloader.chapterName;
    
    self.downloadProgress.progress = downloader.progress;
    
    NSString *rate = [NSString stringWithFormat:@"%@/s",[self formatByteCount:downloader.speedRate]];
    
    if ([rate contains:@"Zero"])
    {
        rate = [rate stringByReplacingOccurrencesOfString:@"Zero" withString:@"0"];
    }
    
    self.rateLabel.hidden = NO;
    self.rateLabel.text = rate;
    
    self.sizeLabel.text = [NSString stringWithFormat:@"%@/%@",[self formatByteCount:downloader.totalByteWriten],[self formatByteCount:self.downloader.totalLength]];
    self.sizeLabel.textColor = HEXRGB(0x999999);
    
    [self.statusBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
}

//容量格式化输出
- (NSString *)formatByteCount:(long long)size
{
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}


@end
