//
//  APIClient.h
//  AdGogo
//
//  Created by GuoChengHao on 14-6-21.
//  Copyright (c) 2014年 qiantui. All rights reserved.
//

//#import <AFNetworking.h>
#import "AFHTTPRequestOperationManager.h"
#import "NSMutableDictionary+Util.h"

@interface APIClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

/**
 *  把错误组装成NSError
 *
 *  @param operation 请求返回的信息
 *  @param error     原本返回的NSError
 *
 *  @return 重新组装的NSError
 */
+ (NSError *)formatAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error;

/**
 *  把错误组装成NSError
 *
 *  @param operation 请求返回的信息
 *
 *  @return 重新组装的NSError
 */
+ (NSError *)formatAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation;

/**
 *	@brief	创建基础业务参数
 *
 *	@return	返回字典
 */
+ (NSMutableDictionary *)creatAPIDictionary;

/**
 *  生成MD5加密串
 *
 *  @param params 要传的数据字典
 *
 *  @return MD5加密后的参数摘要
 */
+ (NSString *)keyFromParams:(NSDictionary *)params;

@end
