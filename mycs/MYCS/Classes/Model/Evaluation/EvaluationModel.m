//
//  EvaluationModel.m
//  MYCS
//
//  Created by Yell on 16/1/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "EvaluationModel.h"

@implementation EvaluationInsidersModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation EvaluationOtherModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation EvaluationListModel

+(instancetype)makeEvaluationListModelWithIconName:(NSString *)iconName Title:(NSString *)title TargetType:(EvaluationTargetType)targetType ViewType:(EvalutaionTableViewType)viewType
{
    EvaluationListModel * model = [[EvaluationListModel alloc]init];
    model.iconName = iconName;
    model.title = title;
    model.targetType = targetType;
    model.ViewType = viewType;
    return model;
}

@end

@implementation EvaluationCommentCountModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation EvaluationModel



//评价方法
+(void)getInsidersListWithListType:(EvaluationStutasType)type page:(int)page Success:(void(^)(NSArray * list))success Failure:(void(^)(NSError* error))failure
{
    NSString * path = [HOST_URL stringByAppendingString:ACADEMICEXCHANGE];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    NSString * typeStr;
    if (type == EvaluationStutasTypeSend)
        typeStr = @"send";
    else
        typeStr = @"accept";
    
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:[NSString stringWithFormat:@"%i",page] forKey:@"page"];
    [params setObjectNilToEmptyString:@"10" forKey:@"pageSize"];
    [params setObjectNilToEmptyString:typeStr forKey:@"type"];
    [params setObjectNilToEmptyString:@"getDoctorEvaluate" forKey:@"action"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError * error;
        NSArray * List = [EvaluationInsidersModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        
        if (failure && error)
        {
            failure (error);
        }else
        {
            success(List);
        }
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }

    }];
    
}

//学术交流，案例中心，视频空间
+(void)getOtherListWithListType:(EvaluationStutasType)listType targetType:(EvaluationTargetType)targetType page:(int)page Success:(void(^)(NSArray * list))success Failure:(void(^)(NSError* error))failure
{
    NSString * path = [HOST_URL stringByAppendingString:ACADEMICEXCHANGE];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    NSString * typeStr;
    if (listType == EvaluationStutasTypeSend)
        typeStr = @"send";
    else
        typeStr = @"accept";
    
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:[NSString stringWithFormat:@"%i",page] forKey:@"page"];
    [params setObjectNilToEmptyString:@"10" forKey:@"pageSize"];
    [params setObjectNilToEmptyString:typeStr forKey:@"type"];
    [params setObjectNilToEmptyString:[NSString stringWithFormat:@"%i",targetType] forKey:@"target_type"];
    [params setObjectNilToEmptyString:@"getCommentList" forKey:@"action"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError * error;
        NSArray * List = [EvaluationOtherModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        
        if (failure && error) {
            failure (error);
        }else
        {
            if (success)
            {
                success(List);
            }
            
        }
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
        
    }];
    
}



+(void)sendReplyCommentWithParentId:(NSString *)parentId targetId:(NSString *)targetId targetType:(NSString *)targetType replyId:(NSString *)replyId reply_uid:(NSString *)reply_uid toUid:(NSString *)toUid contentStr:(NSString *)contentStr Success:(void(^)(void))success Failure:(void(^)(NSError* error))failure
{
    NSString * path = [HOST_URL stringByAppendingString:ACADEMICEXCHANGE];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    
    [params setObjectNilToEmptyString:parentId forKey:@"parent_id"];
    [params setObjectNilToEmptyString:targetId forKey:@"target_id"];
    [params setObjectNilToEmptyString:targetType forKey:@"target_type"];
    [params setObjectNilToEmptyString:replyId forKey:@"reply_id"];
    [params setObjectNilToEmptyString:reply_uid forKey:@"reply_uid"];
    [params setObjectNilToEmptyString:toUid forKey:@"to_uid"];
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"from_uid"];
    [params setObjectNilToEmptyString:contentStr forKey:@"content"];

    [params setObjectNilToEmptyString:@"addComment" forKey:@"action"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success)
        {
            success();
        }
    } failure:^(NSError *error) {
        
        if (failure)
        {
            failure(error);
        }
    }];
}

+(void)getNotReadCommentCountSuccess:(void(^)(NSArray * list))success Failure:(void(^)(NSError* error))failure
{
    NSString * path = [HOST_URL stringByAppendingString:ACADEMICEXCHANGE];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@"getEachCount" forKey:@"action"];

    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError * error;
        NSArray * List = [EvaluationCommentCountModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        
        if (failure && error)
        {
            failure (error);
        }
        else
        {
            if (success)
            {
                success(List);
            }
            
        }
    } failure:^(NSError *error) {
        
        if (failure)
        {
            failure(error);
        }
        
        
    }];
}


@end
