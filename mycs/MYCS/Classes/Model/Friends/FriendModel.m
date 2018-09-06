//
//  FriendModel.m
//  MYCS
//
//  Created by Yell on 16/1/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "FriendModel.h"
#import "SCBModel.h"
#import "user.h"
#import "AppManager.h"
#import "DataCacheTool.h"

@interface FriendModel ()

@end

@implementation FriendGroupModel


+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation FriendModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(void)addFriendWithFriendId:(NSString *)friendId demand:(NSString *)demand checkcontent:(NSString *)check_content Success:(void(^)(void))success failure:(void(^)(NSError *error))failure
{
    
    User * user = [AppManager sharedManager].user;
    NSString *path = [HOST_URL stringByAppendingString:FRIEND_PATH];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:friendId forKey:@"friendId"];
    [params setObjectNilToEmptyString:@"addFriends" forKey:@"action"];
    
    //ask ||accept
    [params setObjectNilToEmptyString:demand forKey:@"demand"];
    if ([demand isEqualToString:@"ask"])
        [params setObjectNilToEmptyString:check_content forKey:@"check_content"];

    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}


+(void)removeFriendWithFriendId:(NSString *)friendId Success:(void(^)(void))success failure:(void(^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:FRIEND_PATH];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    User * user = [AppManager sharedManager].user;
    
    [params setObjectNilToEmptyString:@"removeFriend" forKey:@"action"];
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:friendId forKey:@"friendId"];
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
                
        [DataCacheTool deleteFriendDataWithfriendId:friendId];

        success();
    } failure:^(NSError *error) {
        failure(error);
    }];

    
}

+(void)getFriendListsSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:FRIEND_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    User * user = [AppManager sharedManager].user;

    [params setObjectNilToEmptyString:@"getFanList" forKey:@"action"];
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    
    success([DataCacheTool getAllFriendData]);
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        
        NSArray *modelList = [FriendGroupModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"group"] error:&error];

         [DataCacheTool clearFriendData];
        
        for (FriendGroupModel * groupModel in modelList)
        {
            for (FriendModel * friendModel in groupModel.fans)
            {
                [DataCacheTool saveFriendDataWithModel:friendModel Initial:groupModel.sort];
            }
            
        }

        if (error && failure) {
            failure(error);
        } else if (success) {
            success (modelList);
        }
        
        
    } failure:^(NSError *error) {
        if (failure) {
            

            failure(error);
        }
    }];
    
}


+(void)getTokenSuccess:(void(^)(NSString * token))success Failure:(void (^)(NSError *error))failure
{
    
    NSString *path = [HOST_URL stringByAppendingString:FRIEND_PATH];
    
    User * user = [AppManager sharedManager].user;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:@"getToken" forKey:@"action"];
    [params setObjectNilToEmptyString:user.realname forKey:@"name"];
    [params setObjectNilToEmptyString:user.userPic forKey:@"url"];
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    

    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success)
        {
            success([model.data objectForKey:@"token"]);
        }
        
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}

+(void)searchFriendWithKeyword:(NSString *)keyword Searchtype:(NSString *)type Success:(void(^)(NSMutableArray * friendList))success Failure:(void(^)(NSError* error))failure
{
    NSString * path = [HOST_URL stringByAppendingString:FRIEND_PATH];
    User * user = [AppManager sharedManager].user;

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:keyword forKey:@"keyword"];
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@"searchFriends" forKey:@"action"];
    [params setObjectNilToEmptyString:type forKey:@"searchType"];

    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        
        NSMutableArray * ListArr = [FriendModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(ListArr);
            
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}


+(void)getRelationListSuccess:(void(^)(NSArray *list))success Failure:(void (^)(NSError *error))failure
{
    
    NSString *path = [HOST_URL stringByAppendingString:FRIEND_PATH];
    
    User * user = [AppManager sharedManager].user;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:@"getRelationList" forKey:@"action"];
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    
    
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {

        
        NSError * error;
        NSArray * list = [FriendModel arrayOfModelsFromDictionaries:model.data[@"fans"] error:&error];
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


@end
