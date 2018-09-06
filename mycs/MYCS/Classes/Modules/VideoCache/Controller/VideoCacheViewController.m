//
//  VideoCacheViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "VideoCacheViewController.h"
#import "TCBlobDownload.h"
#import "TCBlobDownloadManager.h"
#import "VideoCacheDetailController.h"
#import "MediaPlayerViewController.h"
#import "VideoCacheDownloadManager.h"
#import "ChapterModel.h"
#import "VideoDetail.h"
#import "CourseDetail.h"
#import "SopDetail.h"
#import "UIImageView+WebCache.h"


static NSString *reuseCachingId = @"VideoCachingCell";
static NSString *reuseCachedId  = @"VideoCachedCell";

@interface VideoCacheViewController () <UITableViewDelegate, UITableViewDataSource, TCBlobDownloaderDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//已经缓存的数组
@property (nonatomic, strong) NSArray *cachelist;

//正在下载的数组列表
@property (nonatomic, strong) NSArray *downloadlist;

//作为变量记录点击教程或者SOP缓存详情的变量
@property (nonatomic, copy) NSString *objectId;

//是否进入编辑状态
@property (nonatomic, assign) BOOL cellExpand;
//是否全选
@property (nonatomic, assign) BOOL cellChoose;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

//需要删除的模型数组
@property (nonatomic, strong) NSMutableArray *deleteArr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;

//编辑按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@end

@implementation VideoCacheViewController

- (void)loadView {
    self.cachelist    = [VideoCacheDownloadManager firstCompleteObjectLists];
    self.downloadlist = [VideoCacheDownloadManager downloadChapterListExceptComplete];
    
    if (self.cachelist.count == 0 && self.downloadlist.count == 0)
    {
        self.view                 = [UIView new];
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.frame           = [UIScreen mainScreen].bounds;
        UILabel *label            = [UILabel new];
        [self.view addSubview:label];
        label.text = @"暂无缓存";
        label.font = [UIFont systemFontOfSize:22];
        [label sizeToFit];
        label.center    = self.view.center;
        label.textColor = HEXRGB(0xd1d1d1);
        
        [self addConstsToTipsLabel:label];
    }
    else
    {
        [super loadView];
    }
}

//给label添加约束
- (void)addConstsToTipsLabel:(UILabel *)label {
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:label.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    [label.superview addConstraints:@[ centerX, centerY ]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view layoutIfNeeded];
    
    [self buildUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reloadTableView];
}

- (void)buildUI {
    self.deleteArr = [NSMutableArray array];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView            = [UIView new];
    
    self.bottomConst.constant = -50;
    [self.view layoutIfNeeded];
}

#pragma mark - 编辑Action
- (IBAction)editAction:(UIBarButtonItem *)button {
    self.cellExpand = !self.cellExpand;
    
    NSString *title = self.cellExpand ? @"取消" : @"编辑";
    [button setTitle:title];
    
    [self.tableView reloadData];
    
    self.bottomConst.constant = self.cellExpand ? 0 : -50;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark-- 选择Action
- (IBAction)selectButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    self.cellChoose = !self.cellChoose;
    [self.tableView reloadData];
    
    if (button.selected)
    {
        self.deleteArr  = [NSMutableArray arrayWithArray:self.cachelist];
        NSString *title = [NSString stringWithFormat:@"删除(%ld)", (unsigned long)self.deleteArr.count];
        [self.deleteBtn setTitle:title forState:UIControlStateNormal];
    }
    else
    {
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
}

#pragma mark-- 根据VideoCacheDownloadObject来删除数据
- (IBAction)deleteButtonAction:(UIButton *)sender {
    if (self.deleteArr.count == 0) return;
    
    [VideoCacheDownloadManager deleteObjectsWith:self.deleteArr];
    
    [self resetUI];
}

- (void)resetUI {
    self.cellExpand = NO;
    
    [self reloadTableView];
    
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.rightItem setTitle:@"编辑"];
    self.bottomConst.constant = -50;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.deleteArr = [NSMutableArray array];
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.downloadlist.count > 0 ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger downloadCount = self.downloadlist.count;
    
    if (downloadCount > 0)
    {
        //正在下载
        if (section == 0)
        {
            return 1;
        }
        else
        { //已经下载
            return self.cachelist.count;
        }
    }
    else
    { //已经下载
        return self.cachelist.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.downloadlist.count > 0)
    {
        //正在下载的cell
        if (indexPath.section == 0)
        {
            VideoCachingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCachingId];
            
            TCBlobDownloadManager *manage = [TCBlobDownloadManager sharedInstance];
            
            TCBlobDownloader *downloader = [manage.operationQueue.operations firstObject];
            
            DownloadChapterObject *chapterObj;
            if (downloader)
            {
                chapterObj = [VideoCacheDownloadManager downloadObjectWithChpaterId:downloader.chapterId];
            }
            else
            {
                chapterObj = [self.downloadlist firstObject];
            }
            
            cell.chapterObj = chapterObj;
            
            downloader.delegate = self;
            
            return cell;
        }
        else
        { //已经缓存的cell
            
            VideoCachedCell *cell            = [tableView dequeueReusableCellWithIdentifier:reuseCachedId];
            VideoCacheDownloadObject *object = self.cachelist[indexPath.row];
            cell.object                      = object;
            cell.expand                      = self.cellExpand;
            cell.choose                      = self.cellChoose;
            
            [self setCellChooseAction:cell];
            
            return cell;
        }
    }
    else
    { //已经缓存的cell
        VideoCachedCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCachedId];
        
        VideoCacheDownloadObject *object = self.cachelist[indexPath.row];
        cell.object                      = object;
        
        cell.expand = self.cellExpand;
        cell.choose = self.cellChoose;
        
        [self setCellChooseAction:cell];
        
        return cell;
    }
}

- (void)setCellChooseAction:(VideoCachedCell *)cell {
    cell.chooseBtnBlock = ^(VideoCacheDownloadObject *object, BOOL choose) {
        
        if (choose)
        {
            [self.deleteArr addObject:object];
        }
        else
        {
            [self.deleteArr removeObject:object];
        }
        
        NSString *title = [NSString stringWithFormat:@"删除(%ld)", (unsigned long)self.deleteArr.count];
        [self.deleteBtn setTitle:title forState:UIControlStateNormal];
        
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[VideoCachedCell class]])
    {
        VideoCachedCell *cachedCell = (VideoCachedCell *)cell;
        
        [self cellDidClickWith:cachedCell.object];
    }
    else
    {
        [self performSegueWithIdentifier:@"CachingVC" sender:nil];
    }
}

//处理cell的点击事件
- (void)cellDidClickWith:(VideoCacheDownloadObject *)object {
    if ([object.objType isEqualToString:CacheObjectTypeVideo])
    { //播放视频
        
        VideoDetail *detail = object.obj;
        
        MediaPlayerViewController *playerVC = [MediaPlayerViewController showWith:self coursePackArray:nil videoDetail:detail courseDetail:nil sopDetail:nil chapter:nil DoctorsHealthDetail:nil isTask:NO isPreview:NO previewTips:nil];
        //播放离线视频不需要上传日志
        playerVC.needToUploadLog = NO;
        playerVC.comeFromCacheFile = YES;
        
    } //课程和SOP，跳转到详情页面
    else
    {
        self.objectId = object.objId;
        [self performSegueWithIdentifier:@"CacheDetail" sender:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 115 : 105;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.5 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CacheDetail"])
    {
        VideoCacheDetailController *detailVC = segue.destinationViewController;
        detailVC.objectId                    = self.objectId;
    }
}

#pragma mark - CustomDelegate 当下载完成时或操作已被取消时调用
- (void)download:(TCBlobDownloader *)blobDownload didFinishWithSuccess:(BOOL)downloadFinished atPath:(NSString *)pathToFile {
    [self reloadTableView];
}
#pragma mark-- 在下载过程中出现错误时调用。
- (void)download:(TCBlobDownloader *)blobDownload didStopWithError:(NSError *)error {
    [self downloadError];
}
#pragma mark-- 当`TCBlobDownloader`对象已经从服务器接收到的第一个响应调用。
- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response {
    [self updateCellWith:blobDownload];
}
#pragma mark-- 如果暂停并重新启动后下载，新的`TABlo Download`将恢复它从它已经停止（见更多的解释`fileName`属性）。因此，您可能要跟踪自己，当你第一次尝试下载该文件的总大小，否则`总Length`是实际剩余长度，下载，如果你做的东西可能不适合你的需求，如进度条。
- (void)download:(TCBlobDownloader *)blobDownload didReceiveData:(uint64_t)receivedLength onTotal:(uint64_t)totalLength progress:(float)progress {
    [self updateCellWith:blobDownload];
}

- (void)updateCellWith:(TCBlobDownloader *)blobDownload {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    VideoCachingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.downloadCount     = self.downloadlist.count;
    cell.downloader        = blobDownload;
}
#pragma mark-- 下载错误方法
- (void)downloadError {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    VideoCachingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.downloadError = YES;
}
#pragma mark-- 重新获取数据，刷新tableview
- (void)reloadTableView {
    self.cachelist    = [VideoCacheDownloadManager firstCompleteObjectLists];
    self.downloadlist = [VideoCacheDownloadManager downloadChapterListExceptComplete];
    
    [self.tableView reloadData];
}

- (void)dealloc {
    TCBlobDownloader *downloader = [[TCBlobDownloadManager sharedInstance].operationQueue.operations firstObject];
    
    downloader.delegate = nil;
}

@end

@interface VideoCachingCell ()

@property (weak, nonatomic) IBOutlet UIButton *countBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end


@interface VideoCachingCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UIProgressView *downLoadProgress;
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UIButton *countButton;

@end

@implementation VideoCachingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countBtn.layer.cornerRadius  = 10;
    self.countBtn.layer.masksToBounds = YES;
}

- (void)setChapterObj:(DownloadChapterObject *)chapterObj {
    _chapterObj = chapterObj;
    
    NSArray *downloadList = [VideoCacheDownloadManager downloadChapterListExceptComplete];
    
    NSString *count = [NSString stringWithFormat:@"%ld", (unsigned long)downloadList.count];
    [self.countBtn setTitle:count forState:UIControlStateNormal];
    
    self.downLoadProgress.progress = chapterObj.progress;
    self.titleL.text               = chapterObj.chapter.name;
    
    if (chapterObj.status == DownloadStatusError)
    {
        self.downLoadProgress.progressTintColor = HEXRGB(0xf66060);
        self.detailL.text                       = @"缓存失败";
    }
    else if (chapterObj.status == DownloadStatusPause)
    {
        self.downLoadProgress.progressTintColor = [UIColor orangeColor];
        self.detailL.text                       = @"暂停下载";
    }
    else if (chapterObj.status == DownloadStatusWaiting)
    {
        self.downLoadProgress.progressTintColor = [UIColor orangeColor];
        self.detailL.text                       = @"等待下载";
    }
}

- (void)setDownloader:(TCBlobDownloader *)downloader {
    _downloader = downloader;
    
    self.titleL.text = downloader.chapterName;
    
    //正常下载
    self.downloadError = NO;
    
    //剩余的正在下载
    NSString *count = [NSString stringWithFormat:@"%ld", (long)self.downloadCount];
    [self.countBtn setTitle:count forState:UIControlStateNormal];
    
    self.downLoadProgress.progress = downloader.progress;
    
    self.titleL.text  = downloader.chapterName;
    self.detailL.text = [NSString stringWithFormat:@"%@/%@", [self formatByteCount:downloader.totalByteWriten], [self formatByteCount:self.downloader.totalLength]];
}

- (void)setDownloadError:(BOOL)downloadError {
    if (downloadError)
    {
        self.downLoadProgress.progressTintColor = HEXRGB(0xf66060);
        self.detailL.text                       = @"缓存失败";
    }
    else
    {
        self.downLoadProgress.progressTintColor = HEXRGB(0x47c1a8);
    }
}

//容量格式化输出
- (NSString *)formatByteCount:(long long)size {
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}

@end


@interface VideoCachedCell ()

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConst;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@end

@implementation VideoCachedCell

- (IBAction)chooseAction:(UIButton *)button {
    button.selected = !button.selected;
    
    if (self.chooseBtnBlock)
    {
        self.chooseBtnBlock(self.object, button.selected);
    }
}

- (void)setObject:(VideoCacheDownloadObject *)object {
    _object = object;
    
    if ([object.objType isEqualToString:CacheObjectTypeVideo])
    {
        self.typeImage.image     = [UIImage imageNamed:@"video_label"];
        VideoDetail *videoDetail = object.obj;
        [self.bgImage sd_setImageWithURL:[NSURL URLWithString:videoDetail.picurl] placeholderImage:PlaceHolderImage];
        self.detailLabel.text    = videoDetail.fileSize;
        self.titleLabel.text     = videoDetail.title;
    }
    else if ([object.objType isEqualToString:CacheObjectTypeCourse])
    {
        self.typeImage.image = [UIImage imageNamed:@"course_label"];
        //获取已经下载
        int completeCount    = 0;
        CourseDetail *course = object.obj;
        for (ChapterModel *chapter in course.chapters)
        {
            if (chapter.isDownloadComplete)
            {
                completeCount++;
            }
        }
        
        int allCount = (int)course.chapters.count;
        
        self.detailLabel.text = [NSString stringWithFormat:@"共%d个视频/已经缓存%d个视频", allCount, completeCount];
        [self.bgImage sd_setImageWithURL:[NSURL URLWithString:course.image] placeholderImage:PlaceHolderImage];
        self.titleLabel.text  = course.name;
    }
    else if ([object.objType isEqualToString:CacheObjectTypeSOP])
    {
        self.typeImage.image = [UIImage imageNamed:@"sop_label"];
        
        int allCount      = 0;
        int completeCount = 0;
        
        SopDetail *detail = object.obj;
        
        for (SopCourseModel *course in detail.sopCourse)
        {
            for (ChapterModel *chapter in course.chapters)
            {
                allCount++;
                if (chapter.isDownloadComplete)
                {
                    completeCount++;
                }
            }
        }
        
        self.detailLabel.text = [NSString stringWithFormat:@"共%d个视频/已经缓存%d个视频", allCount, completeCount];
        [self.bgImage sd_setImageWithURL:[NSURL URLWithString:detail.picUrl] placeholderImage:PlaceHolderImage];
        self.titleLabel.text = detail.name;
    }
}

- (void)setExpand:(BOOL)expand {
    _expand = expand;
    
    self.leftConst.constant = expand ? 0 : -40;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)setChoose:(BOOL)choose {
    _choose = choose;
    
    self.chooseBtn.selected = choose;
}

@end
