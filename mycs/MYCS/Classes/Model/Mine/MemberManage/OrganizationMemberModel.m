//
//  OrganizationMemberModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "OrganizationMemberModel.h"
#import "SCBModel.h"

@implementation OrganizationMemberModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"memberID"}];
}

+ (void)listsWithUerId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
                  page:(int)page
              pageSize:(int)pageSize
                  type:(NSString*)type // 机构 可选，会员类型，参数值： 个人：person，企业：enterprise
               gradeId:(NSString*)gradeId // 机构 可选，服务，参数值见 【返回值例子】中的gradeList的gradeId
                 audit:(NSString*)audit  // 机构 可选，审核状态，参数值： 通过：pass， 审核中: audit, 过期：expire
               success:(void (^)(NSArray *list1,NSArray *list2))success
               failure:(void (^)(NSError *error))failure{
    
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:@(page) forKey:@"page"];
    [params setObjectNilToEmptyString:@(pageSize) forKey:@"pageSize"];
    [params setObjectNilToEmptyString:type forKey:@"type"];
    [params setObjectNilToEmptyString:gradeId forKey:@"gradeId"];
    [params setObjectNilToEmptyString:audit forKey:@"audit"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        
        NSArray *array1 = [GradeModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"gradeList"] error:&error];
        NSArray *array2 = [OrganizationMemberModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(array1,array2);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
