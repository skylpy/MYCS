//
//  ItemModel.h
//  SWWY
//
//  Created by 黄希望 on 15-1-24.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "OptionModel.h"

@protocol ItemModel @end

@interface ItemModel : JSONModel

@property (strong,nonatomic) NSString *itemId;                  // 题目ID
@property (assign,nonatomic) int optionCount;                   // 答案选项数量
@property (strong,nonatomic) NSString *title;                   // 题目标题
@property (strong,nonatomic) NSString *type;                    // 题目类型，汉字字符串：单选，多选择，判断题，
@property (strong,nonatomic) NSArray<OptionModel> *options;     // 当前题目的答案选项列表数组

@end
