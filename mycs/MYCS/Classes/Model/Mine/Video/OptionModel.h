//
//  OptionModel.h
//  SWWY
//
//  Created by 黄希望 on 15-1-24.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@protocol OptionModel @end

/**
 *  答案选项对象
 */
@interface OptionModel : JSONModel

@property (strong,nonatomic) NSString *content;    // 选项内容
@property (assign,nonatomic) int index;            // 选项索引标识
@property (assign,nonatomic) BOOL isAnswer;        // 是否为正确答案，true或false
@property (assign,nonatomic) BOOL selected;        // 选中
@property (nonatomic,assign) BOOL userSelected;

@end
