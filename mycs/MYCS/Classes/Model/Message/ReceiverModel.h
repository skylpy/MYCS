//
//  ReceiverModel.h
//  SWWY
//  选择收件人时用来保存收件人信息的统一类
//  Created by GuoChenghao on 15/2/27.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface ReceiverModel : JSONModel

@property (strong, nonatomic) NSString *userName; //接收人显示名称
@property (strong, nonatomic) NSString *userID; //接收人对应系统ID
@property (assign, nonatomic) int type;

/**
 *  设置值
 *
 *  @param name 接收人显示名称
 *  @param ID   接收人对应系统ID
 */
- (void)userName:(NSString *)name userID:(NSString *)ID;

@end
