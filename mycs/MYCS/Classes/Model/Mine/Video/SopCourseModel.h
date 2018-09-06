//
//  SopCourseModel.h
//  SWWY
//
//  Created by 黄希望 on 15-1-24.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "ChapterModel.h"

@protocol SopCourseModel @end

@interface SopCourseModel : JSONModel

@property (strong,nonatomic) NSString *courseName;
@property (strong,nonatomic) NSString *courseId;
@property (nonatomic,copy) NSString *image;
@property (assign,nonatomic) int hasPaper;
@property (assign,nonatomic) int passRate;
@property (assign,nonatomic) int usedTime;
@property (assign,nonatomic) BOOL isOpen;
@property (strong,nonatomic) NSArray<ChapterModel> *chapters;

@end
