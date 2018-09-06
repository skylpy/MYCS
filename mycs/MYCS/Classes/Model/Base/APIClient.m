//
//  APIClient.m
//  AdGogo
//
//  Created by GuoChengHao on 14-6-21.
//  Copyright (c) 2014年 qiantui. All rights reserved.
//

#import "APIClient.h"
#import "NSString+Util.h"

@implementation APIClient

+ (instancetype)sharedClient{
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] init];
        _sharedClient.requestSerializer.timeoutInterval = 15.0f;
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"charset=UTF-8", @"application/json", nil];
    });
    return _sharedClient;
}

+ (NSError *)formatAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error
{
    id responseObject = operation.responseObject;
    id msg = [responseObject valueForKey:@"msg"];
    if(msg){
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:error.userInfo];
        [userInfo setObject:msg forKey:NSLocalizedFailureReasonErrorKey];
        NSError *formattedError = [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:userInfo];
        return formattedError;
    } else {
        return error;
    }
}

+ (NSError *)formatAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation
{
    id responseObject = operation.responseObject;
    id msg = [responseObject valueForKey:@"msg"];
    
    NSInteger code = 0;
    if ([responseObject valueForKey:@"code"]) {
        code = [[responseObject valueForKey:@"code"] integerValue];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (msg) {
        [userInfo setObject:msg forKey:NSLocalizedFailureReasonErrorKey];
    } else {
        [userInfo setObject:@"服务异常" forKey:NSLocalizedFailureReasonErrorKey];
    }
    NSError *formattedError = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:code userInfo:userInfo];
    return formattedError;
}

+ (NSMutableDictionary *)creatAPIDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"4" forKey:@"device"];
    return dic;
}


+ (NSString *)keyFromParams:(NSDictionary *)params
{
    if (params == nil) {
        return nil;
    }
    
    NSMutableArray *paramNames = [NSMutableArray arrayWithArray:[params allKeys]];
    
    //判断参数中是否含有uploadPhotoData字段，如果含有就不进行加密
    for (int index = 0; index < paramNames.count; index++) {
        
        NSString *aparam = paramNames[index];
        
        if ([aparam isEqualToString:@"uploadPhotoData"]) {
            [paramNames removeObjectAtIndex:index];
            index--;//注意这里不要漏掉
        }
        
    }
    
    // 即是key是我要传输的参数名按ASCII顺序追加起来（再加上固定名称）md5出来的
    NSArray *newParamNames = [paramNames sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *string1 = (NSString *)obj1;
        NSString *string2 = (NSString *)obj2;
        
        return [string1 compare:string2 options:NSNumericSearch];
    }];
    
    NSMutableString *key = [[NSMutableString alloc] init];
    
    
    for (NSString *paramName in newParamNames)
    {
        
        if ([paramName isEqualToString:@"uploadPhotoData"]) {
            break;
        }
        
        id paramValue = params[paramName];
        NSString *paramValueString = [NSString stringWithFormat:@"%@", paramValue];
        [key appendString:paramValueString];
    }
    
    [key appendString:@"51atgc.com"];
    
    return [key MD5];
}

@end



