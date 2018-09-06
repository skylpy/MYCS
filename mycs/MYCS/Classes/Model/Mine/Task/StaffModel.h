//
//  StaffModel.h
//  SWWY
//
//  Created by 黄希望 on 15-1-31.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

/**
 *  员工类
 */
@interface StaffModel : JSONModel

@property (strong,nonatomic) NSString *uid;
@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) NSString *realname;
@property (strong,nonatomic) NSString *deptName;
@property (assign,nonatomic) BOOL isSelected;

/**
 *  【 搜索人员 】接口
 *
 *  @param action   参数值固定  searchStaff
 *  @param keyword  关键字
 */
+ (void)dataWithUserId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
               keyword:(NSString*)keyword
               success:(void (^)(NSArray *list))success
               failure:(void (^)(NSError *error))failure;

@end
