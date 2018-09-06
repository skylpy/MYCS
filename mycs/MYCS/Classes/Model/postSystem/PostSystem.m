//
//  PostSystem.m
//  MYCS
//
//  Created by wzyswork on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PostSystem.h"
#import "SCBModel.h"

@implementation PostSystemVideo

@end

@implementation PostSystem

//authKey     参数加密验证码
//action        getDeptCount
//userId        登陆用户id
//device       机器码
//岗位体系首页
+(void)getPostSystemDataWithUserID:(NSString *)userId DeptID:(NSString *)deptId page:(int)page pageSize:(int)pageSize success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:@"getDeptCount" forKey:@"action"];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:deptId forKey:@"deptId"];
    [params setObjectNilToEmptyString:@(pageSize) forKey:@"pageSize"];
    [params setObjectNilToEmptyString:@(page) forKey:@"page"];
    [params setObjectNilToEmptyString:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] forKey:@"userType"];
    
    NSString *path = [HOST_URL stringByAppendingString:POSTSYSTEM_PATH];
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        NSArray *array = [PostSystem arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(array);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//authKey     参数加密验证码
//action        getAllList
//userId        登陆用户id
//deptId       来源部门
//device       机器码
//岗位体系详情
+(void)getPostSystemVideoDataWithUserID:(NSString *)userId DeptId:(NSString *)deptId page:(int)page pageSize:(int)pageSize success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:@"getAllList" forKey:@"action"];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:deptId forKey:@"deptId"];
    [params setObjectNilToEmptyString:@(pageSize) forKey:@"pageSize"];
    [params setObjectNilToEmptyString:@(page) forKey:@"page"];
    [params setObjectNilToEmptyString:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] forKey:@"userType"];
    
    NSString *path = [HOST_URL stringByAppendingString:POSTSYSTEM_PATH];
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        NSArray *array = [PostSystemVideo arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(array);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
   
}

+(void)DeletePostSystemDataWithIDS:(NSString *)Ids success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:@"delDepRecord" forKey:@"action"];
    [params setObjectNilToEmptyString:Ids forKey:@"ids"];
    
    NSString *path = [HOST_URL stringByAppendingString:POSTSYSTEM_PATH];
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success) {
            success(model.msg);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}
@end
