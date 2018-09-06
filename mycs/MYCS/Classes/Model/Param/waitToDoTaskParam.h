//
//  waitToDoTaskParam.h
//  SWWY
//
//  Created by zhihua on 15/4/22.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface waitToDoTaskParam : NSObject


//device 3 固定值 表示android客户端
@property (nonatomic,copy) NSString *device;
//userId 用户id
@property (nonatomic,copy) NSString *userId;
//authKey 加密值(固定名称，加密规则所得值authKey)
@property (nonatomic,copy) NSString *authKey;
//action: 当要获取普通任务时填getCommonTask,获取SOP任务时填getSOPTask
@property (nonatomic,copy) NSString *action;
@property (nonatomic,copy) NSString *pageSize;
@property (nonatomic,copy) NSString *page;

@end
