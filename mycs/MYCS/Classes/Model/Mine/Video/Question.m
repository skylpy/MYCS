//
//  Question.m
//  SWWY
//
//  Created by 黄希望 on 15-2-4.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "Question.h"
#import "SCBModel.h"

@implementation Question

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
                       failure:(void (^)(NSError *error))failure {
    NSString *path              = [HOST_URL stringByAppendingString:ANSWERSAVE_PATH];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    //    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:testResult forKey:@"testResult"];
    [params setObjectNilToEmptyString:itemId forKey:@"itemId"];
    [params setObjectNilToEmptyString:joinTime forKey:@"joinTime"];
    [params setObjectNilToEmptyString:paperId forKey:@"paperId"];
    [params setObjectNilToEmptyString:task_id forKey:@"task_id"];
    [params setObjectNilToEmptyString:chapter_id forKey:@"chapter_id"];

    [params setObjectNilToEmptyString:course_id forKey:@"course_id"];

    params[@"taskType"]  = [NSString stringWithFormat:@"%d", taskType];
    params[@"startTime"] = startTime;
    params[@"logId"]     = logId;

    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {

        if (success)
        {
            success(model);
        }

    }
        failure:^(NSError *error) {

            if (failure)
            {
                failure(error);
            }

        }];
}

@end
