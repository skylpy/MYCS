//
//  VSCEditModel.m
//  SWWY
//
//  Created by 黄希望 on 15-2-7.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "VSCEditModel.h"
#import "SCBModel.h"

@implementation VSCEditModel

+ (void)editWithUserId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
            check_word:(NSString*)check_word
        int_permission:(int)int_permission
        ext_permission:(int)ext_permission
          person_price:(int)person_price
           group_price:(int)group_price
                 title:(NSString*)title
                dataId:(NSString*)dataId
               vscType:(int)vscType
               success:(void (^)(BOOL success))success
               failure:(void (^)(NSError *error))failure{
    
    NSString *path = nil;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    
    [params setObjectNilToEmptyString:check_word forKey:@"check_word"];
    [params setObjectNilToEmptyString:@(int_permission) forKey:@"int_permission"];
    [params setObjectNilToEmptyString:@(ext_permission) forKey:@"ext_permission"];
    [params setObjectNilToEmptyString:@(person_price) forKey:@"person_price"];
    [params setObjectNilToEmptyString:@(group_price) forKey:@"group_price"];
    [params setObjectNilToEmptyString:title forKey:@"title"];
    
    if (dataId) {
        if (vscType == 1) {
            [params setObject:dataId forKey:@"videoId"];
            path = [HOST_URL stringByAppendingString:VIDEO_PATH];
        }else if (vscType == 2){
            [params setObject:dataId forKey:@"courseId"];
            path = [HOST_URL stringByAppendingString:COURSE_PATH];
        }else if (vscType == 3){
            [params setObject:dataId forKey:@"sopId"];
            path = [HOST_URL stringByAppendingString:SOP_PATH];
        }
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        BOOL suc = [model.code intValue] == 1 ? YES : NO;
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(suc);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
