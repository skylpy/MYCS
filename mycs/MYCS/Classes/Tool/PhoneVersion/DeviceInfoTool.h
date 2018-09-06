//
//  phoneVersion.h
//  MYCS
//
//  Created by wzyswork on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoTool : NSObject

//手机型号
+ (NSString*)deviceVersion;

//CPU型号
+ (NSString *)cpuModel;

//系统版本号
+ (NSString *)systemVersion;

//应用的版本号
+ (NSString *)appVersion;

//MAC地址
+ (NSString *)macAddress;

//内存容量
+ (NSString *)totalMemoryInfo;

//硬盘容量
+ (NSString *)totalDiskSize;

//上传激活信息
+ (void)postActiveInfo;

@end
