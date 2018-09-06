//
//  SelectedView.h
//  MYCS
//
//  Created by AdminZhiHua on 16/2/1.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChapterModel,SopDetail,CourseDetail,CoursePackChapter;
@interface SelectedView : UIView

@property (nonatomic,copy) void(^cellCoursePackChapterBlock)(CoursePackChapter *coursePackChapter);

+ (instancetype)showInView:(UIView *)superView and:(void (^)())block;

-(void)setSOPDetail:(SopDetail *)sopDetail CourseDeatil:(CourseDetail *)courseDetail chapter:(ChapterModel *)chapter coursePackArray:(NSArray *)coursePackArray;

@property (nonatomic,copy) void(^cellBlock)(ChapterModel *chapter);

@property (copy, nonatomic) void (^block)();

-(void)dismissWithBlock:(void (^)())block;

@end

@interface SelectedViewCell : UITableViewCell

/*!
 *  @brief 课程播放选集
 */
@property (nonatomic,strong) CoursePackChapter *coursePackChapter;

@property (nonatomic,copy) void(^buttonCoursePackChapterBlock)(CoursePackChapter *coursePackChapter);


@property (nonatomic,strong) ChapterModel *chapter;

@property (nonatomic,copy) void(^buttonBlock)(ChapterModel *chapter);

- (void)setButtonSelected:(BOOL)selected;

-(void)setChapter:(ChapterModel*)chapter andIndex:(NSInteger)index;

-(void)setCoursePackChapter:(CoursePackChapter*)chapter andIndex:(NSInteger)index;

@end

@interface SelectedChapterButton : UIButton


@end
