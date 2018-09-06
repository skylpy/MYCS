//
//  FriendModel.h
//  MYCS
//
//  Created by Yell on 16/1/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "JSONModel.h"


/*
 addStatus == 1 已接受 ==2 已添加 ==3 等待同意 ==4 等待接受
*/

@protocol FriendModel <NSObject>
@end
@interface FriendModel : JSONModel

@property(nonatomic,copy) NSString<Optional> *name;
@property(nonatomic,copy) NSString<Optional> *area;
@property(nonatomic,copy) NSString<Optional> *friendId;
@property(nonatomic,copy) NSString<Optional> *pic_url;
@property(nonatomic,copy) NSString<Optional> *introduction;
@property(nonatomic,copy) NSString<Optional> *addStatus;
@property(nonatomic,copy) NSString<Optional> *check_content;
@property(nonatomic,assign)BOOL isfriend;




//获取好友列表接口
+(void)getFriendListsSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;


//获取token接口
+(void)getTokenSuccess:(void(^)(NSString * token))success Failure:(void (^)(NSError *error))failure;

/*添加||接受好友接口
 
 friendId 好友Id
 demand 请求类型 ask（添加）||accept(接受）
 */
+(void)addFriendWithFriendId:(NSString *)friendId demand:(NSString *)demand checkcontent:(NSString *)check_content Success:(void(^)(void))success failure:(void(^)(NSError *error))failure;

//移除好友
+(void)removeFriendWithFriendId:(NSString *)friendId Success:(void(^)(void))success failure:(void(^)(NSError *error))failure;

/*搜索好友接口
 Searchtype fanId时为根据userId搜索 
 Keyword
 
 */
+(void)searchFriendWithKeyword:(NSString *)keyword Searchtype:(NSString *)type Success:(void(^)(NSMutableArray * friendList))success Failure:(void(^)(NSError* error))failure;

//获取请求好友列表

+(void)getRelationListSuccess:(void(^)(NSArray *list))success Failure:(void (^)(NSError *error))failure;

@end

@protocol FriendGroupModel <NSObject>
@end

@interface FriendGroupModel : JSONModel

//首字母
@property (nonatomic,copy) NSString<Optional> * sort;
//好友列表
@property (nonatomic,strong) NSMutableArray<FriendModel> * fans;

@property (nonatomic,strong) NSString <FriendModel> * total;


@end

