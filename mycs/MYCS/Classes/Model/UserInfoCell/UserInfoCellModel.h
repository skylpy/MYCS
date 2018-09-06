//
//  UserInfoCellModel.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/17.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoCellModel : NSObject

@property (nonatomic,copy) NSString *reuseId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,assign,getter=isShowArrow) BOOL showArrow;

///push的控制器的ID
@property (nonatomic,copy) NSString *pushIdentifier;

+ (instancetype)initWith:(NSString *)reuseId title:(NSString *)title detail:(NSString *)detail isShowArrow:(BOOL)showArrow pushIdentifier:(NSString *)identifier;

@end
