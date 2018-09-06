//
//  watiToDoTaskTool.m
//  SWWY
//
//  Created by zhihua on 15/4/23.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "WaitToDoTaskTool.h"
#import "SCBModel.h"
#import "waitToDoTaskParam.h"
#import "AppManager.h"

@implementation WaitToDoTaskTool

/**
 *  请求任务，当要获取普通任务时填getCommonTask,获取SOP任务时填getSOPTask，每次返回10条记录
 *
 */
+ (void)requestWaitDoTaskWithAction:(NSString *)action taskStatus:(NSString *)taskStatus page:(NSUInteger)pageNo success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:MYWAITDOTASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@"10" forKey:@"pageSize"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:[NSString stringWithFormat:@"%lu",(unsigned long)pageNo] forKey:@"page"];
    
    if (taskStatus !=nil)
        [params setObjectNilToEmptyString:taskStatus forKey:@"taskStatus"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSMutableArray *listArr = [NSMutableArray array];
        
        for (NSDictionary *dict in model.data[@"list"]) {
            
            WaitToDoTask *task = [WaitToDoTask objectWithKeyValues:dict];
            
            [listArr addObject:task];
            
        }
        
        if (success) {
            success(listArr);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

@end

@implementation WaitToDoTask

@end

@implementation WaitToDoTaskResult

// 告诉MJ框架，数组里的字典转换成哪个模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"list":[WaitToDoTask class]};
}

@end



