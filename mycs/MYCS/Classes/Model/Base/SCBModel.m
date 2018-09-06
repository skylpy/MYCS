//
//  SCBModel.m
//  zlds
//
//  Created by GuoChengHao on 14-7-4.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "SCBModel.h"
#import "AppManager.h"
#import "DataCacheTool.h"
#import "PushControllerView.h"

@implementation SCBModel

- (void)setDataWithNSDictionary:(NSDictionary *)data
{
    if ([data isKindOfClass:[NSDictionary class]]) {
        _data = (NSDictionary *)data;
    } else {
        _data = nil;
    }
}

+ (void)BGET:(NSString *)URLString
  parameters:(id)parameters
     encrypt:(BOOL)encrypt
     success:(void (^)(SCBModel *model))success
     failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dictionary = [self reduceParameter:parameters encrypt:encrypt];
    
    AFNetworkReachabilityStatus status = [AppManager sharedManager].status;
    BOOL hasNetWork = (status!=AFNetworkReachabilityStatusUnknown&&status!=AFNetworkReachabilityStatusNotReachable);
      //有网情况下直接从后台请求
        if (hasNetWork)
        {
            
            [[APIClient sharedClient] GET:URLString parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                            NSLog(@"SuccessResponse:%@ \n %@",operation.response,responseObject);
                
                [self successOperation:operation resopnseObj:responseObject authKey:dictionary[@"authKey"] success:success failure:failure];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                //            NSLog(@"ErrorResponse:%@ \n%@",operation.response,error);
                
                [self failureOperation:operation error:error failure:failure];
            }];
            
        }
        else
        {
            //从本地数据库中获取数据
            [self localDataWith:dictionary[@"authKey"] success:success failure:failure];
        }
    
}

//统一处理参数
+ (NSDictionary *)reduceParameter:(id)parameters encrypt:(BOOL)encrypt {
    
    if ([AppManager hasLogin])
    {
        parameters[@"loginToken"] = [AppManager sharedManager].user.loginToken;
        parameters[@"userId"] = [AppManager sharedManager].user.uid;
    }
    else
    {
        parameters[@"loginToken"] = @"";
        parameters[@"userId"] = @"";
    }
    
    NSMutableDictionary *dictionary = [APIClient creatAPIDictionary];
    [dictionary addEntriesFromDictionary:parameters];
    
    if (encrypt) {
        NSString *authKey = [APIClient keyFromParams:dictionary];
        [dictionary setObject:authKey forKey:@"authKey"];
    }
    
    return dictionary;
}

//处理成功的数据返回
+ (void)successOperation:(AFHTTPRequestOperation *)operation resopnseObj:(id)responseObject authKey:(NSString *)authKey success:(void (^)(SCBModel *model))success failure:(void (^)(NSError *error))failure {
    
    //将返回的数据保存到数据库中
    if (authKey&&[AppManager sharedManager].user.uid)
    {
        [DataCacheTool saveDataWithDic:responseObject userID:[AppManager sharedManager].user.uid authKey:authKey];
    }
    
    SCBModel *receiveModel;
    NSError *error;
    @try {
        receiveModel = [[SCBModel alloc] initWithDictionary:responseObject error:&error];
    } @catch (id ex) {
        error = [JSONModelError errorInvalidDataWithMessage:@"服务器响应格式错误"];
    }
    
    if (error)
    {//一般是返回的数据不是json，或者后台数据缺少某些字段
        if ([self hasAlertViewInKeyWindow]) return;
        if (failure) failure(error);
    }
    else
    {
        [self reduseWith:receiveModel operation:operation success:success failure:failure];
    }
}

//处理错误的数据返回
+ (void)failureOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error failure:(void (^)(NSError *error))failure{
    
    if ([self hasAlertViewInKeyWindow]) return;
    
    NSError *formatError = [APIClient formatAFHTTPRequestOperation:operation error:error];
    
    if (failure) failure(formatError);
    
}

//处理返回的模型数据
+ (void)reduseWith:(SCBModel *)model operation:(AFHTTPRequestOperation *)operation success:(void (^)(SCBModel *model))success failure:(void (^)(NSError *error))failure {
    
    if ([model.code isEqualToString:@"1"])
    {
        if(success) success(model);
    }//帐号在其他设备登录
    else if ([model.code isEqualToString:@"10011"])
    {
        if ([self hasAlertViewInKeyWindow]) return;
        
        SCBModel * model = [[SCBModel alloc] init];
        model.code = @"1";
        model.msg = @"";
        model.data = [NSDictionary dictionaryWithObject:@"" forKey:@""];
        
        if (success) success(model);
        
        [PushControllerView showOtherPlaceloginCurrentUserCode];
    }
    else
    {
        if ([self hasAlertViewInKeyWindow]) return;
        
        NSError *formatError = [APIClient formatAFHTTPRequestOperation:operation];
        if (failure) failure(formatError);
    }
    
}

//获取本地数据
+ (void)localDataWith:(NSString *)authKey success:(void (^)(SCBModel *model))success failure:(void (^)(NSError *error))failure {
    
    SCBModel *model = [[SCBModel alloc] initWithDictionary:[DataCacheTool getDataWithUserID:[AppManager sharedManager].user.uid authKey:authKey] error:nil];
    
    //没网的情况下从数据库中获取
    if (model)
    {
        if(success) success(model);
    }
    else
    {
        if ([self hasAlertViewInKeyWindow]) return;
        //本地数据库中没有数据,提示网络错误
        if (failure)
        {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"似乎与网络断开连接!"                                                                      forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"cn.mycs.www" code:404 userInfo:userInfo];
            failure(error);
        }
    }
    
}

//判断KeyWindow下是否有其他的子View
//防止在一个控制器中有多个网络请求，请求错误弹出多个AlertView;
+ (BOOL)hasAlertViewInKeyWindow {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    for (UIView *subView in window.subviews)
    {
        if ([subView isMemberOfClass:[UIView class]])
        {
            return YES;
        }
    }
    
    return NO;
}

+ (void)BPOST:(NSString *)URLString
   parameters:(id)parameters
      encrypt:(BOOL)encrypt
      success:(void (^)(SCBModel *model))success
      failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dictionary = [self reduceParameter:parameters encrypt:encrypt];
    
    AFNetworkReachabilityStatus status = [AppManager sharedManager].status;
    BOOL hasNetWork = (status!=AFNetworkReachabilityStatusUnknown&&status!=AFNetworkReachabilityStatusNotReachable);
  
        //有网情况下直接从后台请求
        if (hasNetWork)
        {
            [[APIClient sharedClient] POST:URLString parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
//                            NSLog(@"SuccessResponse:%@ \n %@",operation.response,responseObject);
                
                [self successOperation:operation resopnseObj:responseObject authKey:dictionary[@"authKey"] success:success failure:failure];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                //            NSLog(@"ErrorResponse:%@",operation.response);
                
                [self failureOperation:operation error:error failure:failure];
            }];
            
        }else{
            
            [self localDataWith:dictionary[@"authKey"] success:success failure:failure];
        }
    
}

@end
