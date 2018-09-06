//
//  CourseDownLoadView.m
//  MYCS
//
//  Created by AdminZhiHua on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "CourseDownLoadView.h"
#import "CourseDetail.h"
//#import "VideoCacheDataManager.h"
//#import "TCBlobDownloadManager.h"
#import "UIView+Message.h"
//#import "VideoCacheTool.h"
#import "VideoCacheDownloadManager.h"

@interface CourseDownLoadView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewConstH;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,strong) CourseDetail *detail;
@property (nonatomic,copy) NSString *objectId;

@property (nonatomic,strong) NSArray *digitalArr;

@property (weak, nonatomic) IBOutlet AllCacheBtn *allCacheBtn;

@property (nonatomic,copy) void(^completeAction)(void);

@end

@implementation CourseDownLoadView

+ (instancetype)showWith:(CourseDetail *)detail InView:(UIView *)superView belowView:(UIView *)belowView action:(void(^)(void))actionBlock{
    
    CourseDownLoadView *downloadView = [[[NSBundle mainBundle] loadNibNamed:@"TaskDownLoadView" owner:nil options:nil]firstObject];
    
    downloadView.detail = detail;
    downloadView.completeAction = actionBlock;
    downloadView.frame = [UIScreen mainScreen].bounds;
    
    [superView insertSubview:downloadView belowSubview:belowView];
    
    [downloadView buildUIWith:detail.chapters];
    
    return downloadView;
}

- (void)buildUIWith:(NSArray *)list {
    
    CGFloat margin = 15;
    CGFloat topY = 0;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i<list.count; i++)
    {
        CacheCahpterBtn *button = [CacheCahpterBtn buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:button];
        
        //设置layer
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
        button.layer.borderWidth = 1;
        
        //设置frame
        int col = i%3;
        int row = i/3;
        
        CGFloat buttonW = (ScreenW-margin*(3+1))/3;
        CGFloat buttonH = 40;
        CGFloat buttonX = margin + (buttonW+margin)*col;
        CGFloat buttonY = margin + (buttonH+margin)*row;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        //设置属性
        NSString *title = [NSString stringWithFormat:@"章节%@",self.digitalArr[i]];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:HEXRGB(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = i;
        
        //设置按钮的状态属性
        ChapterModel *chapter = list[i];
        DownloadChapterObject *downloadChapter = [VideoCacheDownloadManager downloadObjectWithChpaterId:chapter.chapterId];
        
        CacheBtnStatus status;
        if (!downloadChapter)
        {
            status = CacheBtnStatusNormal;
        }
        else
        {
            if (downloadChapter.status==DownloadStatusComplete)
            {
                status = CacheBtnStatusAddComplete;
            }
            else
            {
                status = CacheBtnStatusAddNoComplete;
            }
        }
        
        button.status = status;
        
        //添加事件
        [button addTarget:self action:@selector(chapterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        topY = CGRectGetMaxY(button.frame)+margin;
    }
    
    self.viewConstH.constant = topY+50;
    
    [self.allCacheBtn updateBadgeNumber];
    
    [self layoutIfNeeded];
    
    [self showWithAnimation];
}

- (void)showWithAnimation {
    
    self.headerView.transform = CGAffineTransformTranslate(self.headerView.transform, 0, -self.viewConstH.constant);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.headerView.transform = CGAffineTransformTranslate(self.headerView.transform, 0, self.viewConstH.constant+64);
        
    }];
    
}

#pragma mark - Action
- (IBAction)closeAction:(UIButton *)sender {
    
    if (self.completeAction)
    {
        self.completeAction();
    }
    
    [self dismissWithAnimation];
    
}

- (IBAction)allCacheAction:(UIButton *)sender {
    
    for (CacheCahpterBtn *button in self.contentView.subviews)
    {
        [self addDownloadListWith:button];
    }
    
    [self.allCacheBtn updateBadgeNumber];
}

- (void)addDownloadListWith:(CacheCahpterBtn *)button {
    
    ChapterModel *chapter = self.detail.chapters[button.tag];
    chapter.picUrl = self.detail.image;
    
    DownloadChapterObject *downloadChapter = [VideoCacheDownloadManager downloadObjectWithChpaterId:chapter.chapterId];
    
    if (!downloadChapter)
    {
        //添加到下载列表
        button.status = CacheBtnStatusAddNoComplete;
        [VideoCacheDownloadManager addDownloadChapterWithId:self.detail.id chapterId:chapter.chapterId chapter:chapter];
        [self showSuccessWithStatus:@"添加下载"];
    }
    else
    {
        if (downloadChapter.status==DownloadStatusComplete)
        {
            button.status = CacheBtnStatusAddComplete;
        }
    }
}

- (void)dismissWithAnimation {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.headerView.transform = CGAffineTransformTranslate(self.headerView.transform, 0, -self.viewConstH.constant-64);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

- (void)chapterBtnAction:(CacheCahpterBtn *)button {
    
    ChapterModel *chapter = self.detail.chapters[button.tag];
    chapter.picUrl = self.detail.image;
    
    DownloadChapterObject *downloadChapter = [VideoCacheDownloadManager downloadObjectWithChpaterId:chapter.chapterId];
    
    if (!downloadChapter)
    {
        //添加到下载列表
        button.status = CacheBtnStatusAddNoComplete;
        [VideoCacheDownloadManager addDownloadChapterWithId:self.detail.id chapterId:chapter.chapterId chapter:chapter];
        [self showSuccessWithStatus:@"添加下载"];
    }
    else
    {
        if (downloadChapter.status==DownloadStatusComplete)
        {
            button.status = CacheBtnStatusAddComplete;
        }
        else
        {
            button.status = CacheBtnStatusNormal;
            //删除下载记录
            [VideoCacheDownloadManager deleteDownloadChapterByChapterId:chapter.chapterId];
            [self showSuccessWithStatus:@"取消下载"];
        }
    }
    
    [self.allCacheBtn updateBadgeNumber];
}

#pragma mark - Delegate
- (NSArray *)digitalArr {
    if (!_digitalArr) {
        _digitalArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十"];
    }
    return _digitalArr;
}

- (void)setDetail:(CourseDetail *)detail {
    _detail = detail;
    
    //添加到缓存模型数据库中
    [VideoCacheDownloadManager addObjectWith:detail.id cacheType:CacheObjectTypeCourse object:detail];
}

@end

@interface CacheCahpterBtn ()

@property (nonatomic,strong) UIImageView *imgView;

@end

@implementation CacheCahpterBtn

- (void)setStatus:(CacheBtnStatus)status {
    _status = status;
    
    if (status == CacheBtnStatusNormal)
    {
        self.imgView.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.enabled = YES;
    }
    else if (status == CacheBtnStatusAddComplete)
    {
        self.imgView.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"choose-aaa"];
        self.backgroundColor = HEXRGB(0xeeeeee);
        self.enabled = NO;
    }
    else if (status == CacheBtnStatusAddNoComplete)
    {
        self.imgView.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"choose_hightlinght"];
        self.backgroundColor = [UIColor whiteColor];
        self.enabled = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imgView.x = self.width-self.imgView.width;
    self.imgView.y = self.height-self.imgView.height;
}

#pragma mark - Getter&Setter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.bounds = CGRectMake(0, 0, 23, 22);
        [self addSubview:_imgView];
    }
    return _imgView;
}

@end

@interface AllCacheBtn ()

@property (nonatomic,strong) UIButton *badgeBtn;

@end

@implementation AllCacheBtn

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.badgeBtn.x = CGRectGetMaxX(self.imageView.frame)-5;
    self.badgeBtn.y = self.imageView.y-5;
    
}

- (void)updateBadgeNumber {
    
    NSArray *list = [VideoCacheDownloadManager downloadChapterListExceptComplete];
    
    if (list.count==0)
    {
        self.badgeBtn.hidden = YES;
    }
    else
    {
        self.badgeBtn.hidden = NO;
        NSString *title = [NSString stringWithFormat:@"%lu",(unsigned long)list.count];
        [self.badgeBtn setTitle:title forState:UIControlStateNormal];
    }
    
}

- (UIButton *)badgeBtn {
    if (!_badgeBtn)
    {
        _badgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _badgeBtn.bounds = CGRectMake(0, 0, 20, 20);
        [_badgeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_badgeBtn setBackgroundColor:[UIColor redColor]];
        _badgeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_badgeBtn];
        _badgeBtn.layer.cornerRadius = 10;
        _badgeBtn.layer.masksToBounds = YES;
    }
    return _badgeBtn;
}

@end
