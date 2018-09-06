//
//  ClassifyModel.m
//  MYCS
//
//  Created by Yell on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ClassifyModel.h"

@implementation firstClassifyModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation ClassifyModel

+(void)getListSuccess:(void(^)(NSArray * list))success failure:(void(^)(NSError * error))failure
{
    NSString * path = [HOST_URL stringByAppendingString:CATEGORY_PATH];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    User * user = [AppManager sharedManager].user;
    
    [params setObjectNilToEmptyString:@"getCategorys" forKey:@"action"];
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        
        NSError *error;
        NSArray *modelList = [firstClassifyModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelList);
            
        }
        
        
    } failure:^(NSError *error) {
        failure(error);
    }];

    
    
    
}


@end
