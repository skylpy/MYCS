//
//  VideoPlayModel.h
//  SWWY
//
//  Created by Yell on 15/7/8.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SopDetail.h"

@interface VideoPlayModel : NSObject

@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSArray *list;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString *chapterId;
@property (nonatomic,strong) SopDetail *sopDetail;
@property (nonatomic,copy) NSString *taskID;
@property (nonatomic,copy) NSString *courseID;
@property (nonatomic,assign) int taskType;

@end
