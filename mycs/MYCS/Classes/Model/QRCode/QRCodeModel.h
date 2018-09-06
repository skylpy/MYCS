//
//  QRCodeModel.h
//  SWWY
//
//  Created by zhihua on 15/7/6.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    QRCodeTypeUnkonw,
    QRCodeTypeUser,
    QRCodeTypeVideo,
    QRCodeTypeCourse,
    QRCodeTypeSOP
}QRCodeType;

@interface QRCodeModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) int agroup_id;

@property (nonatomic, assign) QRCodeType type;

@property (nonatomic, assign) int userType;


@end
