//
//  updateModel.m
//  SWWY
//
//  Created by Yell on 15/5/13.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "UpdateModel.h"
#import "SCBModel.h"
#import "AFNetworking.h"
#import "appStroeUpdateModel.h"

@implementation UpdateModel

+(JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"up_time": @"up_time"}];
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"force": @"force"}];
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"url": @"url"}];
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"typ": @"typ"}];
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"version": @"version"}];

}

+(void)checkUpdateInServerSuccess:(void (^)(UpdateModel *model))success failure:(void (^)(NSError *))failure
{
 
    //本地具体版本号
    NSString *pathV = [[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil];
    NSMutableDictionary *dict = [ [ NSMutableDictionary alloc ] initWithContentsOfFile:pathV];
    NSString *nowVersion = [dict objectForKey:@"CFBundleShortVersionString"];
    
    NSString * path = [NSString stringWithFormat:@"http://mycsapi.mycs.cn/ios/app/apps/svn.php?action=latest&typ=2&version=%@",nowVersion];

       [SCBModel BPOST:path parameters:nil encrypt:YES success:^(SCBModel *model) {
           
        NSError *error;

        UpdateModel * data =[[UpdateModel alloc]initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(data);
        }

    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+(void)checkUpdateInAppStoreSuccess:(void (^)(appStroeUpdateModel *contentInStore))success failure:(void (^)(NSError * error))failure
{
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", @744623158];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:storeString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        appStroeUpdateModel *receiveModel = [[appStroeUpdateModel alloc] initWithDictionary:responseObject error:&error];
            if (error && failure) {
                failure(error);
            } else if (success) {
                success(receiveModel);
            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        
    }];
}

+(void)update:(NSString *)URLString
   parameters:(id)parameters
      encrypt:(BOOL)encrypt
      success:(void (^)(UpdateModel *model))success
      failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dictionary = [APIClient creatAPIDictionary];
    [dictionary addEntriesFromDictionary:parameters];
    
    if (encrypt) {
        NSString *authKey = [APIClient keyFromParams:dictionary];
        [dictionary setObject:authKey forKey:@"authKey"];
    }
    [[APIClient sharedClient] POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        UpdateModel *update = [[UpdateModel alloc] initWithDictionary:responseObject error:&error];
        if (error) {

                failure(error);
        }else {

            success(update);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSError *formatError = [APIClient formatAFHTTPRequestOperation:operation error:error];
        if (failure) {
            failure(formatError);
        }
    }];

}


@end
