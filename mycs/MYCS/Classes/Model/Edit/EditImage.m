//
//  EditImage.m
//  SWWY
//
//  Created by zhihua on 15/5/5.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "EditImage.h"
#import "AppManager.h"
#import "SCBModel.h"

@implementation EditImage

+ (void)editImage:(NSString *)commentType buyID:(NSString *)buy_id imageData:(NSString *)imageData success:(void(^)(SCBModel *model))success failure:(void(^)(NSError *error))failure{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"userId"] = [AppManager sharedManager].user.uid;
    dict[@"userType"] = [NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType];
    dict[@"comment_type"] = commentType;
    dict[@"buy_cid"] = buy_id;
    dict[@"uploadPhotoData"] = imageData;
    
    NSString *editImageRUL = [HOST_URL stringByAppendingString:EDIT_IMAGE];
    
    [SCBModel BPOST:editImageRUL parameters:dict encrypt:YES success:^(SCBModel *model) {
        
        if (success) {
            success(model);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

@end
