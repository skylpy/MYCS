//
//  PreviewStatusTool.h
//  MYCS
//
//  Created by AdminZhiHua on 16/3/23.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @author zhihua, 16-03-23 12:03:43
 *
 *  这个工具类用来请求获取审核状态，或者其他状态的公交类
 */
@interface PreviewStatusTool : NSObject

//检测统计分析是否开放
+ (void)fectchStaticsIsOpenView:(void(^)(BOOL isOpenView))block;

@end
