//
//  StudyRecord.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/13.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "StudyRecord.h"
#import "SCBModel.h"

@implementation StudyRecord

+ (void)requestStudyRecordListWithUerId:(NSString*)userId userType:(NSString*)userType memberID:(NSString *)memberID pageNo:(int)pageNo pageSize:(NSString *)pageSize success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:@"task" forKey:@"action"];
    [params setObjectNilToEmptyString:memberID forKey:@"id"];
    [params setObjectNilToEmptyString:@(pageNo) forKey:@"page"];
    [params setObjectNilToEmptyString:pageSize forKey:@"pageSize"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *temp = [StudyRecord arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(temp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
