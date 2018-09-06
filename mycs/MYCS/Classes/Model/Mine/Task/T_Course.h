//
//  T_Course.h
//  SWWY
//
//  Created by 黄希望 on 15-1-25.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "T_Chapter.h"

@protocol T_Course @end

/**
 *  任务管理课程类
 */
@interface T_Course : JSONModel

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *courseId;
@property (assign,nonatomic) BOOL isOpen;
@property (strong,nonatomic) NSArray<T_Chapter> *chapters;

@end
