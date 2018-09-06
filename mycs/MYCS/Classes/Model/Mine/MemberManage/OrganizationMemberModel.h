//
//  OrganizationMemberModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "EnumDefine.h"
#import "GradeModel.h"

@interface OrganizationMemberModel : JSONModel

@property (strong, nonatomic) NSString *memberID; //会员ID
@property (strong, nonatomic) NSString *uid; //会员UID
@property (strong, nonatomic) NSString *realname; // 会员名称
@property (strong, nonatomic) NSString *gradeName; //服务名称
@property (strong, nonatomic) NSNumber *audit; // 会员状态, 0表示审核中，1表示审核通过，2表示已拒绝，3表示已过期
@property (strong, nonatomic) NSString *avatar; // 会员头像

//=========【机构列表接口】========//
+ (void)listsWithUerId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
                  page:(int)page
              pageSize:(int)pageSize
                  type:(NSString*)type // 机构 可选，会员类型，参数值： 个人：person，企业：enterprise
               gradeId:(NSString*)gradeId // 机构 可选，服务，参数值见 【返回值例子】中的gradeList的gradeId
                 audit:(NSString*)audit  // 机构 可选，审核状态，参数值： 通过：pass， 审核中: audit, 过期：expire
               success:(void (^)(NSArray *list1,NSArray *list2))success
               failure:(void (^)(NSError *error))failure;

@end
