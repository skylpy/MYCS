//
//  VSCParam.h
//  SWWY
//
//  Created by 黄希望 on 15-2-7.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSCParam : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) int vscType;
@property (nonatomic,assign) int int_permission;
@property (nonatomic,assign) int ext_permission;
@property (nonatomic,assign) int personPrice;
@property (nonatomic,assign) int groupPrice;
@property (nonatomic,strong) NSString *checkWord;
@property (nonatomic,strong) NSString *dataId;
@property (nonatomic,assign) int source;

//        comment_type   详情里面的comment_type
@property (nonatomic,assign) int comment_type;

//        buy_cid        详情里面的buy_cid
@property (nonatomic,copy) NSString *buy_cid;

//图片的url
@property (nonatomic,strong) UIImage *image;

@end
