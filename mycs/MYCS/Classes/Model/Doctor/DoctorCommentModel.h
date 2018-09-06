//
//  DoctorCommentModel.h
//  SWWY
//
//  Created by zhihua on 15/6/29.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@class SCBModel;
@interface DoctorComment : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *lid;//--评价id
@property (nonatomic,copy) NSString *content;//--评价内容
@property (nonatomic,copy) NSString *addTime;//--评价时间
@property (nonatomic,assign) int score;//--评分
@property (nonatomic,copy) NSString *from_uid;//--评价者uid
@property (nonatomic,copy) NSString *to_uid;//
@property (nonatomic,copy) NSString *praiseNum;//--点赞数
@property (nonatomic,copy) NSString *from_uname;//--评价者昵称
@property (nonatomic,copy) NSString *from_imageUrl;//--评价者头像链接，空字符串为没有头像
//@property (nonatomic,copy) NSString *isPraise;// --是否已经点赞，0--未点赞，1--已点赞
@property (nonatomic,assign) BOOL isPraise;


@end


@interface DoctorCommentModel : NSObject

@property (nonatomic,copy) NSString *total;
@property (nonatomic,strong) NSArray *list;

+ (void)commentListsWithUserId:(NSString *)userid
                       checkID:(NSString *)checkUid
                          page:(int)page
                      pageSize:(int)pageSize
                       success:(void (^)(DoctorCommentModel *commentListModel))success
                       failure:(void (^)(NSError *error))failure;

+ (void)commitCommentWithUserId:(NSString *)userid
                          toUid:(NSString *)toUid
                        content:(NSString *)content
                          score:(int)score
                        success:(void (^)(SCBModel *model))success
                        failure:(void (^)(NSError *error))failure;


@end
