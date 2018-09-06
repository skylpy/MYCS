//
//  EditImage.h
//  SWWY
//
//  Created by zhihua on 15/5/5.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCBModel;
@interface EditImage : NSObject

//+ (void)editImage:(NSString *)commentType buyID:(NSString *)buy_id imageData:(NSString *)imageData;
+ (void)editImage:(NSString *)commentType buyID:(NSString *)buy_id imageData:(NSString *)imageData success:(void(^)(SCBModel *model))success failure:(void(^)(NSError *error))failure;

@end
