//
//  InfomationModel.h
//  SWWY
//
//  Created by zhihua on 15/7/2.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfomationModel : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *titlePic;//--封面图片地址
@property (nonatomic,copy) NSString *createTime;//--发布时间
@property (nonatomic,copy) NSString *click;//--点击量
@property (nonatomic,copy) NSString *title;//--资讯标题
@property (nonatomic,copy) NSString *detail;//--资讯简介
@property (nonatomic,copy) NSString *linkURL;// --详情访问地址
@property (nonatomic,copy) NSString *lid;


//authKey       参数加密验证码
//pageSize      分页数据页记录数
//page          当前分页
//cid        分类id， 最新资讯--46， 技术大全--47， 会展中心--54
+ (void)InformationListWithPage:(int)page
                       pageSize:(int)pageSize
                            cid:(int)cid
                     fromeCache:(BOOL)isFromCache
                        success:(void (^)(NSArray *list))success
                        failure:(void (^)(NSError *error))failure;

+ (void)InformationListWithCheckID:(NSString *)checkID
                              Page:(int)page
                       pageSize:(int)pageSize
                        success:(void (^)(NSArray *list))success
                        failure:(void (^)(NSError *error))failure;



@end
