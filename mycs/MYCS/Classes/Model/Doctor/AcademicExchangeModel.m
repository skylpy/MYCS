//
//  AcademicExchangeModel.m
//  SWWY
//
//  Created by zhihua on 15/6/30.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "AcademicExchangeModel.h"
#import "SCBModel.h"
#import "MJExtension.h"

@implementation Reply


@end

@implementation AcademicExchangeModel

+ (void)AcademicExchangeListWithTargetId:(NSString *)targetID
                                  userID:(NSString *)userID
                                    page:(int)page
                                pageSize:(int)pageSize
                              targetType:(int)targetType
                                 success:(void (^)(NSArray *list))success
                                 failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"list";
    param[@"page"] = @(page);
    param[@"pageSize"] = @(pageSize);
    param[@"target_type"] = @(targetType);
    param[@"target_id"] = targetID;
    param[@"userId"] = userID;
    
    NSString *path = [HOST_URL stringByAppendingString:ACADEMICEXCHANGE];
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        NSMutableArray *list = [NSMutableArray array];
        
        for (NSDictionary *dict in model.data[@"list"]) {
            AcademicExchangeModel *model = [AcademicExchangeModel objectWithKeyValues:dict];
            
            NSMutableArray *replyArr = [NSMutableArray array];
            for (NSDictionary *dict in model.replyList) {
                Reply *reply = [Reply objectWithKeyValues:dict];
                [replyArr addObject:reply];
            }
            
            model.replyList = replyArr;
            
            //图片列表
            NSMutableArray *array = [NSMutableArray array];
            for (NSString *urlStr in model.picList) {
                [array addObject:urlStr];
            }
            
            model.picList = array;
            
            [list addObject:model];
            
        }
        if (success) {
            success(list);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

//authKey       参数加密验证码
//action        参数值固定：add
//userId        当前登录用户id
//content        发表内容
//toEid    所属的交流话题id，默认值0则为发起交流话题，非0为话题讨论（所有回复需要传此参数）
//toUid    被回复者uid，默认值0则为回复话题,非0则为话题内回复某个用户(回复单个评论需传此参数，否则为对话题评论)
//target_type    评论目标类型，0--名医学术交流,4--案例资源回复，1--视频评论，2--教程评论，3--sop评论（灰色暂不启用）
//target_id    评论目标id,名医学术交流则为当前名医首页用户uid

+ (void)commentWithUserID:(NSString *)userid conetent:(NSString *)content toEid:(NSString *)edi toUid:(NSString *)toUid reply_id:(NSString *)reply_id targetType:(int)targetType targetID:(NSString *)targetID success:(void (^)(void))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"add";
    param[@"userId"] = userid;
    param[@"content"] = content;
    param[@"toEid"] = edi;
    param[@"toUid"] = toUid;
    param[@"target_type"] = @(targetType);
    param[@"target_id"] = targetID;
    param[@"reply_id"] = reply_id;
    
    NSString *path = [HOST_URL stringByAppendingString:ACADEMICEXCHANGE];
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        if ([model.code intValue] == 1) {
            if (success) {
                success();
            }
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}


@end
