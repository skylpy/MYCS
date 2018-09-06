//
//  SopDownloadCell.m
//  MYCS
//
//  Created by AdminZhiHua on 16/2/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SopDownloadCell.h"
#import "CourseDownLoadView.h"
//#import "VideoCacheChapter.h"
//#import "VideoCacheObject.h"
//#import "VideoCacheDataManager.h"
#import "SopCourseModel.h"
#import "UIView+Message.h"
#import "VideoCacheDownloadManager.h"

@interface SopDownloadCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *expandImage;
@property (weak, nonatomic) IBOutlet UIView *contenView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic,strong) NSArray *digitalArr;

@end

@implementation SopDownloadCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerDidTap:)];
    
    [self.headerView addGestureRecognizer:tapGest];
    
}

- (CGFloat)heightForCellWith:(SopCourseModel *)course {
    
    [self.contenView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.course = course;
    
    CGFloat margin = 15;
    CGFloat topY = 0;
    
    for (int i = 0; i<course.chapters.count; i++)
    {
        CacheCahpterBtn *button = [CacheCahpterBtn buttonWithType:UIButtonTypeCustom];
        [self.contenView addSubview:button];
        
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
        ChapterModel *chapter = course.chapters[i];
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

    return topY+50;
}

#pragma mark - Action
- (void)chapterBtnAction:(CacheCahpterBtn *)button {
    
    ChapterModel *chapter = self.course.chapters[button.tag];
    chapter.picUrl = self.course.image;
    
    DownloadChapterObject *downloadChapter = [VideoCacheDownloadManager downloadObjectWithChpaterId:chapter.chapterId];
    
    if (!downloadChapter)
    {
        //添加到下载列表
        button.status = CacheBtnStatusAddNoComplete;
        [VideoCacheDownloadManager addDownloadChapterWithId:self.sopId chapterId:chapter.chapterId chapter:chapter];
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

}

- (void)headerDidTap:(UIGestureRecognizer *)gest {
    
    self.course.isOpen = !self.course.isOpen;
    
    if (self.cellHeaderAction)
    {
        self.cellHeaderAction();
    }
}


#pragma mark - Delegate
- (NSArray *)digitalArr {
    if (!_digitalArr) {
        _digitalArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十"];
    }
    return _digitalArr;
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    
    if (isOpen)
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.expandImage.transform = CGAffineTransformRotate(self.expandImage.transform, M_PI);
            
        }];

    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.expandImage.transform = CGAffineTransformIdentity;
            
        }];

    }
    
}

@end
