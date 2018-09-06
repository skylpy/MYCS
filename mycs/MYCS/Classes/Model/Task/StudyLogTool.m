//
//  StudyLog.m
//  SWWY
//
//  Created by AdminZhiHua on 15/12/2.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "StudyLogTool.h"
#import "SCBModel.h"
#import "AppManager.h"

@implementation StudyLogTool

+ (void)startStudyLog:(NSString *)goodsId goodsType:(int)type courseId:(NSString *)courseId chapterId:(NSString *)chapterId lastLogId:(NSString *)logId taskId:(NSString *)taskId success:(void (^)(NSString *logId))success failure:(void (^)(NSError *error))failure {
    //判断是否是匿名播放
    NSString *userId = [AppManager sharedManager].user.uid;
    
    NSString *path = [HOST_URL stringByAppendingString:STUDYLOG_PATH];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"action"]    = @"addLog";
    dict[@"device"]    = @"4";
    dict[@"userId"]    = userId;
    dict[@"goodsId"]   = goodsId;
    dict[@"goodsType"] = @(type);
    dict[@"courseId"]  = courseId;
    dict[@"chapterId"] = chapterId;
    dict[@"lastLogId"] = logId;
    dict[@"taskId"]    = taskId;
    
    [SCBModel BPOST:path parameters:dict encrypt:YES success:^(SCBModel *model) {
        
        NSString *logId = model.data[@"logId"];
        
        if (logId)
        {
            if (success)
            {
                success(logId);
            }
        }
        
    }
            failure:^(NSError *error) {
                
                if (failure)
                {
                    failure(error);
                }
                
            }];
}

+ (void)exitLogWiht:(NSString *)logId viewTime:(NSTimeInterval)viewTime videoTimeSpot:(NSTimeInterval)videoTimeSpot success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    //判断是否是匿名播放
    NSString *userId = [AppManager sharedManager].user.uid;
    
    NSString *path = [HOST_URL stringByAppendingString:STUDYLOG_PATH];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"]           = @"timeCounter";
    param[@"userId"]           = userId;
    param[@"logId"]            = logId;
    param[@"viewTime"]         = @(viewTime);
    param[@"videoTimeSpot"]    = @(videoTimeSpot);
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        if ([model.code isEqualToString:@"1"])
        {
            if (success)
            {
                success();
            }
        }
        
    }
            failure:^(NSError *error) {
                
                if (failure)
                {
                    failure(error);
                }
                
            }];
}

+ (void)endStudyLogWith:(NSString *)logId breakPointPlay:(BOOL)breakPointPlay viewTime:(NSTimeInterval)viewTime videoTimeSpot:(NSTimeInterval)videoTimeSpot success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    //判断是否是匿名播放
    NSString *userId = [AppManager sharedManager].user.uid;
    
    NSString *path = [HOST_URL stringByAppendingString:STUDYLOG_PATH];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"]           = @"endLog";
    param[@"userId"]           = userId;
    param[@"logId"]            = logId;
    param[@"breakpointplay"]   = @(breakPointPlay);
    param[@"viewTime"]         = @(viewTime);
    param[@"videoTimeSpot"]    = @(videoTimeSpot);
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        if ([model.code isEqualToString:@"1"])
        {
            if (success)
            {
                success();
            }
        }
        
    }
            failure:^(NSError *error) {
                if (failure)
                {
                    failure(error);
                }
            }];
}

+(void)updateViewClickStudyLogWith:(NSString *)goodsId userId:(NSString *)userId userType:(NSString *)userType action:(NSString *)action success:(void (^)(void))success failure:(void (^)(NSError *))failure

{
    NSString *path = [HOST_URL stringByAppendingString:STUDYLOG_PATH];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectNilToEmptyString:goodsId forKey:@"goodsId"];
    [param setObjectNilToEmptyString:userId forKey:@"userId"];
    [param setObjectNilToEmptyString:userType forKey:@"userType"];
    [param setObjectNilToEmptyString:action forKey:@"action"];
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        if ([model.code isEqualToString:@"1"])
        {
            if (success)
            {
                success();
            }
        }
        
    }failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}

@end
