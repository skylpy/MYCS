//
//  TaskChapterView.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/21.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskExamDeatilModel.h"

@interface TaskCourseView : UIView

@property (nonatomic,assign) NSUInteger index;

- (CGFloat)heightWith:(TaskCourseList *)course;

@end

@interface TaskChapterView : UIView

@property (nonatomic,assign) NSUInteger index;

- (CGFloat)configWith:(TaskChapters *)chapter;

@end

@interface TaskPaperView : UIView

@property (nonatomic,assign) NSUInteger index;

- (CGFloat)configWith:(TaskPapers *)paper;

@end

@interface TaskItemView : UIView

@property (nonatomic,assign) NSUInteger index;

- (CGFloat)configWith:(TaskItems *)item;

@end

@interface OptionButton : UIButton

@end
