//
//  PaperModel.h
//  SWWY
//
//  Created by 黄希望 on 15-1-24.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "ItemModel.h"

@protocol PaperModel @end

@interface PaperModel : JSONModel

@property (assign,nonatomic) int finishTime;                    // 要求完成的时长
@property (strong,nonatomic) NSString *paperId;                 // 试卷id
@property (assign,nonatomic) int timeSpot;                      // 试卷弹出时间点（秒）
@property (strong,nonatomic) NSString *timeSpot_his;            // 试卷弹出时间点（时间格式：H:i:s）
@property (strong,nonatomic) NSString *title;                   // 题目标题
@property (strong,nonatomic) NSArray<ItemModel> *items;         // 当前试卷的题目列表数组

@end
