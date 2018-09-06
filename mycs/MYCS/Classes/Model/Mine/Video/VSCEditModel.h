//
//  VSCEditModel.h
//  SWWY
//
//  Created by 黄希望 on 15-2-7.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface VSCEditModel : JSONModel

/**
 *  编辑接口（视频，教程，sop）
 *
 *  @param userId         登陆用户id
 *  @param userType       登录用户的类型
 *  @param action         参数值固定：update
 *  @param check_word     对外验证可看时传验证码
 *  @param int_permission '内部权限,0--内部不公开,1--内部公开',
 *  @param ext_permission '外部权限,0--外部不公开,1--外部公开,2--外部验证可看,3--外部付费可看',
 *  @param person_price   个人价格
 *  @param proup_price    团体价格
 *  @param title          标题
 *  @param videoId        视频时传该参数
 *  @param courseId       教程时传该参数
 *  @param sopId          sop时传该参数
 *  @param success        success description
 *  @param failure        failure description
 */
+ (void)editWithUserId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
            check_word:(NSString*)check_word
        int_permission:(int)int_permission
        ext_permission:(int)ext_permission
          person_price:(int)person_price
           group_price:(int)group_price
                 title:(NSString*)title
                dataId:(NSString*)dataId
               vscType:(int)vscType
               success:(void (^)(BOOL success))success
               failure:(void (^)(NSError *error))failure;


@end
