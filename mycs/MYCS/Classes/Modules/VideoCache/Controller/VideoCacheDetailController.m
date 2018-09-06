//
//  VideoCacheDetailController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/2/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "VideoCacheDetailController.h"
#import "CourseDownLoadView.h"
#import "MediaPlayerViewController.h"
#import "SOPDownLoadView.h"
#import "VideoCacheDownloadManager.h"
#import "UIImageView+WebCache.h"

static NSString *const reuseId = @"CachedDetailCell";
@interface VideoCacheDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *eidtItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *database;

//编辑按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@property (nonatomic, assign) BOOL expand;
@property (nonatomic, assign) BOOL cellChoose;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;

@property (nonatomic, strong) NSMutableArray *deleteArr;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic, strong) CourseDetail *course;
@property (nonatomic, strong) SopDetail *sop;

@property (nonatomic, strong) VideoCacheDownloadObject *object;

@end

@implementation VideoCacheDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [UIView new];

    self.deleteArr = [NSMutableArray array];

    [self loadData];

    self.bottomConst.constant = -50;
}

- (void)loadData {
    self.database = [NSMutableArray array];

    VideoCacheDownloadObject *object = [VideoCacheDownloadManager objectWithId:self.objectId];
    self.object                      = object;

    if ([object.objType isEqualToString:CacheObjectTypeCourse])
    {
        CourseDetail *course = object.obj;
        self.course          = course;
    }
    else if ([object.objType isEqualToString:CacheObjectTypeSOP])
    {
        SopDetail *sop = object.obj;
        self.sop       = sop;
    }

    [self.tableView reloadData];
}

#pragma mark - Action
- (IBAction)moreCacheAction:(UIButton *)sender {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.rightItem.enabled                        = NO;

    if ([self.object.objType isEqualToString:CacheObjectTypeCourse])
    {
        [CourseDownLoadView showWith:self.course InView:self.navigationController.view belowView:self.navigationController.navigationBar action:^{

            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.rightItem.enabled                        = YES;

        }];
    }
    else if ([self.object.objType isEqualToString:CacheObjectTypeSOP])
    {
        [SOPDownLoadView showWith:self.sop InView:self.navigationController.view belowView:self.navigationController.navigationBar action:^{

            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.rightItem.enabled                        = YES;

        }];
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editItemAction:(UIBarButtonItem *)button {
    self.expand = !self.expand;

    NSString *title = self.expand ? @"取消" : @"编辑";
    [button setTitle:title];

    [self.tableView reloadData];

    self.bottomConst.constant = self.expand ? 0 : -50;

    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)allSelectAction:(UIButton *)button {
    button.selected = !button.selected;
    self.cellChoose = !self.cellChoose;
    [self.tableView reloadData];

    if (button.selected)
    {
        self.deleteArr  = [NSMutableArray arrayWithArray:self.database];
        NSString *title = [NSString stringWithFormat:@"删除(%ld)", (unsigned long)self.deleteArr.count];
        [self.deleteBtn setTitle:title forState:UIControlStateNormal];
    }
    else
    {
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
}

- (IBAction)deleteAction:(UIButton *)button {
    for (ChapterModel *chapter in self.deleteArr)
    {
        [VideoCacheDownloadManager deleteDownloadChapterByChapterId:chapter.chapterId];
        chapter.downloadComplete = NO;
    }

    if ([self.object.objType isEqualToString:CacheObjectTypeCourse])
    {
        [VideoCacheDownloadManager updateCacheObjectWith:self.course account:self.object.objId];
    }
    else if ([self.object.objType isEqualToString:CacheObjectTypeSOP])
    {
        [VideoCacheDownloadManager updateCacheObjectWith:self.sop account:self.object.objId];
    }

    [self resetUI];
}


- (void)removeFileWithPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    //删除文件
    if ([manager fileExistsAtPath:filePath])
    {
        [manager removeItemAtPath:filePath error:nil];
    }
}

- (void)resetUI {
    self.expand = NO;

    [self loadData];

    self.deleteArr = [NSMutableArray array];

    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.rightItem setTitle:@"编辑"];
    self.bottomConst.constant = -50;

    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];

    self.deleteArr = [NSMutableArray array];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.database.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CachedDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];

    ChapterModel *chapter = self.database[indexPath.row];

    cell.chapter = chapter;

    cell.expand = self.expand;
    cell.choose = self.cellChoose;

    [self setCellChooseAction:cell];

    return cell;
}

- (void)setCellChooseAction:(CachedDetailCell *)cell {
    cell.chooseBtnAction = ^(ChapterModel *object, BOOL choose) {

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CachedDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([self.object.objType isEqualToString:CacheObjectTypeCourse])
    {
        MediaPlayerViewController *playerVC = [MediaPlayerViewController showWith:self coursePackArray:nil videoDetail:nil courseDetail:self.course sopDetail:nil chapter:cell.chapter DoctorsHealthDetail:nil isTask:NO isPreview:NO previewTips:nil];

        //播放离线视频不需要上传日志
        playerVC.needToUploadLog = NO;
        playerVC.comeFromCacheFile = YES;
    }
    else if ([self.object.objType isEqualToString:CacheObjectTypeSOP])
    {
        MediaPlayerViewController *playerVC = [MediaPlayerViewController showWith:self coursePackArray:nil videoDetail:nil courseDetail:nil sopDetail:self.sop chapter:cell.chapter DoctorsHealthDetail:nil isTask:NO isPreview:NO previewTips:nil];
        //播放离线视频不需要上传日志
        playerVC.needToUploadLog = NO;
        playerVC.comeFromCacheFile = YES;
    }
}


#pragma mark - Getter&Setter
- (void)setCourse:(CourseDetail *)course {
    _course = course;

    self.database = [NSMutableArray array];
    for (ChapterModel *chapter in course.chapters)
    {
        if (chapter.isDownloadComplete)
        {
            chapter.picUrl = course.image;
            
            [self.database addObject:chapter];
        }
    }

    [self.tableView reloadData];
}

- (void)setSop:(SopDetail *)sop {
    _sop = sop;

    self.database = [NSMutableArray array];
    for (SopCourseModel *course in sop.sopCourse)
    {
        for (ChapterModel *chapter in course.chapters)
        {
            if (chapter.isDownloadComplete)
            {
                chapter.picUrl = course.image;
                [self.database addObject:chapter];
            }
        }
    }

    [self.tableView reloadData];
}

@end

@interface CachedDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLaebl;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConst;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@end

@implementation CachedDetailCell


- (void)setChapter:(ChapterModel *)chapter {
    _chapter = chapter;

    self.titleLaebl.text = chapter.name;
    self.sizeLabel.text  = chapter.fileSize;
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:chapter.picUrl] placeholderImage:PlaceHolderImage];
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

- (IBAction)chooseBtnAction:(UIButton *)button {
    button.selected = !button.selected;

    if (self.chooseBtnAction)
    {
        self.chooseBtnAction(self.chapter, button.selected);
    }
}


@end
