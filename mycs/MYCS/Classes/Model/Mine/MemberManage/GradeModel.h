//
//  GradeModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "EnumDefine.h"

@protocol GradeModel 

@end

/**
 *  服务等级类
 */
@interface GradeModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *memberID; //会员主键ID
@property (nonatomic,strong) NSString<Optional> *gradeId; // 服务ID
@property (nonatomic,strong) NSString<Optional> *gradeName; // 服务名称
@property (nonatomic,strong) NSString<Optional> *detail; // 服务说明
@property (nonatomic,strong) NSNumber<Optional> *money; //每人每年的价格
@property (nonatomic, strong) NSString<Optional> *year; //年限
@property (strong, nonatomic) NSString<Optional> *staff; //人数
@property (nonatomic,strong) NSNumber<Optional> *audit; // 申请状态，-1表示未申请， 0表示审核中，1表示审核通过，2表示已拒绝，3表示已过期

@end
