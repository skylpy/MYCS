//
//  MessageSend.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageSend : NSObject

+ (void)messageSendWith:(NSString *)title content:(NSString *)content toUID:(NSString *)toUId Success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
