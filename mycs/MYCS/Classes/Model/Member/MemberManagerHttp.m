//
//  MemberManagerHttp.m
//  SWWY
//
//  Created by zhihua on 15/5/10.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "MemberManagerHttp.h"
#import "SCBModel.h"
#import "ZHMemberInfo.h"
#import "MJExtension.h"

@implementation MemberManagerHttp

+ (void)getMemberDetail:(NSString *)userID userType:(NSString *)userType action:(NSString *)action page:(int) page pageSize:(int)pageSize success:(void (^)(NSArray *memberDetailList))success failure:(void(^)(NSError *error))failure{
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    
    paramDict[@"userId"] = userID;
    paramDict[@"userType"] = userType;
    paramDict[@"action"] = action;
    paramDict[@"page"] = [NSString stringWithFormat:@"%d",page];
    paramDict[@"pageSize"] = [NSString stringWithFormat:@"%d",pageSize];
    
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    [SCBModel BPOST:path parameters:paramDict encrypt:YES success:^(SCBModel *model) {
        
        ZHMemberInfoResutl *result = [ZHMemberInfoResutl objectWithKeyValues:model.data];
        
        NSMutableArray *memberInfoArr = [NSMutableArray array];
        
        for (NSDictionary *dict in result.list) {
            
            ZHMemberInfo *info = [ZHMemberInfo objectWithKeyValues:dict];
            [memberInfoArr addObject:info];
            
        }
        
        if (success) {
            success(memberInfoArr);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
