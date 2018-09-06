//
//  SOPDownLoadView.m
//  MYCS
//
//  Created by AdminZhiHua on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SOPDownLoadView.h"
#import "CourseDownLoadView.h"
#import "SopDetail.h"
#import "SopDownloadCell.h"
#import "UIView+Message.h"
#import "VideoCacheDownloadManager.h"

static NSString *const reuseId = @"SopDownloadCell";

@interface SOPDownLoadView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet AllCacheBtn *allCacheBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *database;

@property (nonatomic,strong) SopDetail *detail;
@property (nonatomic,copy) NSString *objectId;

@property (nonatomic,strong) NSArray *digitalArr;

@property (nonatomic,copy) void(^completeBlock)(void);

@end

@implementation SOPDownLoadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.tableFooterView = [UIView new];
    UINib *cellNib = [UINib nibWithNibName:@"SopDownloadCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:reuseId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

+ (instancetype)showWith:(SopDetail *)detail InView:(UIView *)superView belowView:(UIView *)belowView action:(void(^)(void))actionBlock {
    
    SOPDownLoadView *downloadView = [[[NSBundle mainBundle] loadNibNamed:@"TaskDownLoadView" owner:nil options:nil] lastObject];
    
    downloadView.detail = detail;
    downloadView.completeBlock = actionBlock;
    
    downloadView.frame = [UIScreen mainScreen].bounds;
    
    [superView insertSubview:downloadView belowSubview:belowView];
    
    downloadView.database = detail.sopCourse;
    
    //显示时的动画
    [downloadView showWithAnimation];
    
    [downloadView.tableView reloadData];
    
    //更新
    [downloadView.allCacheBtn updateBadgeNumber];
    
    return downloadView;
}

#pragma mark - Show&Hiden
- (void)showWithAnimation {
    
    self.transform = CGAffineTransformTranslate(self.transform, 0, ScreenH);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    }];
    
}

- (void)dismissWithAnimation {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.transform = CGAffineTransformTranslate(self.transform, 0, ScreenH);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}


#pragma mark - Action
- (IBAction)allCacheAction:(id)sender {
    
    for (SopCourseModel *course in self.detail.sopCourse)
    {
        for (ChapterModel *chapter in course.chapters)
        {
            chapter.picUrl = course.image;
            [self addToDownloadWith:chapter];
        }
    }
    
    [self.tableView reloadData];
    
    [self.allCacheBtn updateBadgeNumber];
}

- (void)addToDownloadWith:(ChapterModel *)chapter {
    
    DownloadChapterObject *downloadChapter = [VideoCacheDownloadManager downloadObjectWithChpaterId:chapter.chapterId];
    
    if (!downloadChapter)
    {
        //添加到下载列表
        [VideoCacheDownloadManager addDownloadChapterWithId:self.detail.id chapterId:chapter.chapterId chapter:chapter];
        [self showSuccessWithStatus:@"添加下载"];
    }
}


- (IBAction)closeBtnAction:(id)sender {
    
    if (self.completeBlock)
    {
        self.completeBlock();
    }
    
    [self dismissWithAnimation];
}


#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.database.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SopDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    cell.sopId = self.detail.id;
    SopCourseModel *sopCourse = self.database[indexPath.row];
    [cell heightForCellWith:sopCourse];

    cell.isOpen = sopCourse.isOpen;
    
    __weak typeof(self) weakSelf = self;
    cell.cellHeaderAction = ^(void) {
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.allCacheBtn updateBadgeNumber];
    };
    
    cell.nameLabel.text = [NSString stringWithFormat:@"教程%@",self.digitalArr[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SopCourseModel *course = self.database[indexPath.row];
    
    if (course.isOpen)
    {
        SopDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        
        CGFloat cellH = [cell heightForCellWith:course];
        
        return cellH;
    }
    
    return 50;
}

#pragma mark - Delegate
- (NSArray *)digitalArr {
    if (!_digitalArr) {
        _digitalArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十"];
    }
    return _digitalArr;
}

- (void)setDetail:(SopDetail *)detail {
    _detail = detail;
    
    [VideoCacheDownloadManager addObjectWith:detail.id cacheType:CacheObjectTypeSOP object:detail];
}

@end
