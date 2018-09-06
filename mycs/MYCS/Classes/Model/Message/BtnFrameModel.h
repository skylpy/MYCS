//
//  BtnFrameModel.h
//  SWWY
//
//  Created by Yell on 15/5/10.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BtnFrameModel : NSObject

@property (strong, nonatomic) NSString *userName; //接收人显示名称
@property (strong, nonatomic) NSString *userID; //接收人对应系统ID


@property (assign,nonatomic) CGRect btnImageFrame;
@property (assign,nonatomic) CGRect btnTextFrame;
@property (assign,nonatomic) CGRect btnModelFrame;
@property (assign,nonatomic) int type;
@property (assign,nonatomic) CGFloat inRow;

@property (assign,nonatomic) NSInteger index;

@end
