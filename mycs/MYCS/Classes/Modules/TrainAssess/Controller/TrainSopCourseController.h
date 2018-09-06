//
//  TrainSopCourseController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/27.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SopDetail.h"

@interface TrainSopCourseController : UIViewController

@property (nonatomic,strong) SopCourseModel *sopCourse;

@property (nonatomic,copy) void(^cellAction)(SopCourseModel *sopCourse,ChapterModel *model);

@end

@interface TrainChapterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *chapterOrderLabel;

@property (nonatomic,strong) ChapterModel *chapter;

@end
