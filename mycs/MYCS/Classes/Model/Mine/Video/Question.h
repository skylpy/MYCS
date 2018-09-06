//
//  Question.h
//  SWWY
//
//  Created by 黄希望 on 15-2-4.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@class SCBModel;
@interface Question : JSONModel

+ (void)submitAnswerWithUserId:(NSString *)userId
                      userType:(NSString *)userType
                    testResult:(NSString *)testResult
                        itemId:(NSString *)itemId
                      joinTime:(NSString *)joinTime
                       paperId:(NSString *)paperId
                       task_id:(NSString *)task_id
                      taskType:(int)taskType
                    chapter_id:(NSString *)chapter_id
                     course_id:(NSString *)course_id
                     startTime:(NSString *)startTime
                         logId:(NSString *)logId
                       success:(void (^)(SCBModel *model))success
                       failure:(void (^)(NSError *error))failure;

@end
