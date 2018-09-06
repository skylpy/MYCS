//
//  CourseOfSOP.h
//  SWWY
//
//  Created by 黄希望 on 15-2-1.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@protocol CourseOfSOP @end
@interface CourseOfSOP : JSONModel

@property (strong,nonatomic) NSString *courseId;
@property (strong,nonatomic) NSString *courseName;
@property (assign,nonatomic) int pass_rate;

+ (void)dataWithUserId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
                 sopId:(NSString*)sopId
               success:(void (^)(NSArray *list))success
               failure:(void (^)(NSError *error))failure;
@end
