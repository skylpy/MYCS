//
//  CollectionModel.m
//  MYCS
//
//  Created by wzyswork on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "CollectionModel.h"
#import "SCBModel.h"
#import "DeviceInfoTool.h"

@implementation CollectionVideo

@end
@implementation CollectionDoctor

@end
@implementation CollectionHospital

@end
@implementation CollectionModel

+(void)getCollectionDoctorDataWithUserID:(NSString *)userId success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:@"doctor" forKey:@"action"];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    
    NSString *path = [HOST_URL stringByAppendingString:COLLECTION_PATH];
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        NSArray *array = [CollectionDoctor arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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

+(void)getCollectionHospitalDataWithUserID:(NSString *)userId success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:@"enterprise" forKey:@"action"];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    
    NSString *path = [HOST_URL stringByAppendingString:COLLECTION_PATH];
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        NSArray *array = [CollectionHospital arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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
+(void)getCollectionVideoDataWithUserID:(NSString *)userId success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:@"getVideoInfo" forKey:@"action"];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:[NSString stringWithFormat:@"v%@",[DeviceInfoTool appVersion]] forKey:@"version"];
    
    NSString *path = [HOST_URL stringByAppendingString:COLLECTION_PATH];
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        NSArray *array = [CollectionVideo arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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
//action        delRecord
//type           (video || doctor || hospital)
//ids              可以传单个id，也可以传以","连接的id字符串
//device        机器码
+(void)DeleteCollectionDataWithIDS:(NSString *)Ids Type:(NSString *)type success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:@"delRecord" forKey:@"action"];
    [params setObjectNilToEmptyString:type forKey:@"type"];
     [params setObjectNilToEmptyString:Ids forKey:@"ids"];
    
    NSString *path = [HOST_URL stringByAppendingString:COLLECTION_PATH];
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

+(void)AddCollectDoctorOrOfficeWithCollectId:(NSString *)collectId userId:(NSString *)userId collectType:(int)type Collect:(NSString *)collect success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:@"addCollect" forKey:@"action"];
    [params setObjectNilToEmptyString:@(type) forKey:@"type"];
    [params setObjectNilToEmptyString:collectId forKey:@"id"];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:collect forKey:@"collect"];
    
    NSString *path = [HOST_URL stringByAppendingString:COLLECTION_PATH];
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













