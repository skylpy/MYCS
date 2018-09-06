//
//  UserInfoCellModel.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/17.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UserInfoCellModel.h"

@implementation UserInfoCellModel


+ (instancetype)initWith:(NSString *)reuseId title:(NSString *)title detail:(NSString *)detail isShowArrow:(BOOL)showArrow pushIdentifier:(NSString *)identifier {
    
    UserInfoCellModel *model = [[UserInfoCellModel alloc] init];
    model.reuseId = reuseId;
    model.title = title;
    model.detail = detail;
    model.showArrow = showArrow;
    model.pushIdentifier = identifier;
    
    return model;
    
}



@end
