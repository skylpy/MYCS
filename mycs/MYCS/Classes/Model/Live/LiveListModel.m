//
//  LiveListModel.m
//  MYCS
//
//  Created by GuiHua on 16/8/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "LiveListModel.h"
#import "MJExtension.h"

@implementation LiveListModel

+(void)requestListDataWithStatus:(NSString *)status Action:(NSString *)action Sort:(NSString *)sort Page:(int)page PageSize:(int)pageSize Success:(void (^)(NSArray *))success Failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:LIVE_PATH];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectNilToEmptyString:status forKey:@"status"];
    [param setObjectNilToEmptyString:action forKey:@"action"];
    [param setObjectNilToEmptyString:sort forKey:@"sort"];
    [param setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    [param setObjectNilToEmptyString:@([AppManager sharedManager].user.userType) forKey:@"userType"];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@(pageSize) forKey:@"pageSize"];
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *list = [LiveListModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(list);
        }
        
    } failure:^(NSError *error) {
        
        if (failure)
        {
            failure(error);
        }
    }];
    
}

+(void)releaseLiveWithRoomId:(NSString *)roomId CateId:(NSString *)cateId AnchorIntro:(NSString *)anchorIntro anchor:(NSString *)anchor liveTime:(NSString *)liveTime tilte:(NSString *)title coverId:(NSString *)coverId checkWord:(NSString *)checkWord detail:(NSString *)detail extPermission:(NSString *)extPermission action:(NSString *)action Success:(void (^)(SCBModel *))success Failure:(void (^)(NSError *))failure
{

    NSString *path = [HOST_URL stringByAppendingString:LIVE_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:roomId forKey:@"room_id"];
    [params setObjectNilToEmptyString:cateId forKey:@"cate_id"];
    [params setObjectNilToEmptyString:anchorIntro forKey:@"anchor_intro"];
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@([AppManager sharedManager].user.userType) forKey:@"userType"];
    [params setObjectNilToEmptyString:anchor forKey:@"anchor"];
    
    [params setObjectNilToEmptyString:liveTime forKey:@"live_time"];
    [params setObjectNilToEmptyString:title forKey:@"title"];
    [params setObjectNilToEmptyString:coverId forKey:@"cover_id"];
    [params setObjectNilToEmptyString:detail forKey:@"detail"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:extPermission forKey:@"ext_permission"];
    if (extPermission.intValue == 3)
    {
        
        [params setObjectNilToEmptyString:checkWord forKey:@"check_word"];
    }
    
    [SCBModel BGET:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success)
        {
            success(model);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)requestLiveDetailWithRoomId:(NSString *)roomId action:(NSString *)action Success:(void (^)(LiveDetail *))success Failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:LIVE_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:roomId forKey:@"room_id"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@([AppManager sharedManager].user.userType) forKey:@"userType"];

    
    [SCBModel BGET:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        LiveDetail *detail = [LiveDetail objectWithKeyValues:model.data];
        if (success)
        {
            success(detail);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+(void)deleteLiveDetailWithRoomId:(NSString *)roomId action:(NSString *)action Success:(void (^)(SCBModel *))success Failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:LIVE_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:roomId forKey:@"room_id"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@([AppManager sharedManager].user.userType) forKey:@"userType"];
    
    
    [SCBModel BGET:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success)
        {
            success(model);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}
+(void)changeLiveStatusWithRoomId:(NSString *)roomId action:(NSString *)action status:(NSString *)status Success:(void (^)(SCBModel *))success Failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:LIVE_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:roomId forKey:@"room_id"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:status forKey:@"status"];
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@([AppManager sharedManager].user.userType) forKey:@"userType"];
    
    [SCBModel BGET:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success)
        {
            success(model);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+(void)checkCheckWordWithRoomId:(NSString *)roomId checkWord:(NSString *)checkWord action:(NSString *)action Success:(void (^)(SCBModel *))success Failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:LIVE_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:roomId forKey:@"room_id"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:checkWord forKey:@"check_word"];
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@([AppManager sharedManager].user.userType) forKey:@"userType"];
    
    
    [SCBModel BGET:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success)
        {
            success(model);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    

}
+(void)silentWith:(NSString *)userID and:(NSString *)liveID Success:(void (^)(SCBModel *))success Failure:(void (^)(NSError *))failure
{
    NSString *path = @"http://192.168.1.13:8080/silent";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:liveID forKey:@"liveid"];
    [params setObjectNilToEmptyString:userID forKey:@"userid"];
    
    [SCBModel BGET:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success)
        {
            success(model);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)getPushUrl:(NSString *)roomId Success:(void (^)(LiveURLModel *model))success Failure:(void (^)(NSError *))failure
{

    NSString *path = [HOST_URL stringByAppendingString:LIVE_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:roomId forKey:@"room_id"];
    [params setObjectNilToEmptyString:@"getUpUrl" forKey:@"action"];
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@([AppManager sharedManager].user.userType) forKey:@"userType"];
    
    
    [SCBModel BGET:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        LiveURLModel *lModel = [[LiveURLModel alloc] initWithDictionary:model.data error:&error];
        
        if (error&&failure)
        {
            failure(error);
        }
        if (success)
        {
            success(lModel);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end

@implementation LiveURLModel



@end

@implementation LiveDetail



@end