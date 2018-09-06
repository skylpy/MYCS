//
//  MemberJoin.m
//  SWWY
//
//  Created by 黄希望 on 15-1-29.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "MemberJoin.h"
#import "SCBModel.h"

@implementation JoinModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"user_id":@"userId"}];
}
@end

@implementation MemberJoin

+ (void)dataWithUserId:(NSString*)userId
                action:(NSString*)action
                taskId:(NSString*)taskId
                passed:(int)passed
              pageSize:(int)pageSize
                  page:(int)page
               success:(void (^)(MemberJoin *memberJoin))success
               failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId) {
        [params setObject:userId forKey:@"userId"];
    }
    if (action) {
        [params setObject:action forKey:@"action"];
    }
    if (taskId) {
        [params setObject:taskId forKey:@"taskId"];
    }
    if (passed>-1) {
        [params setObject:@(passed) forKey:@"passed"];
    }
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(page) forKey:@"page"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        MemberJoin *memberJoin = [[MemberJoin alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(memberJoin);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
