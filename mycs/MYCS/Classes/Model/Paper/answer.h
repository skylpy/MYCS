//
//  answer.h
//  SWWY
//
//  Created by zhihua on 15/4/30.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answer : NSObject

//试卷的id
@property (nonatomic,copy) NSString *paperID;

//试卷完成的时间
@property (nonatomic,assign) int  finishTime;

//试卷的题目ID组成
@property (nonatomic,copy) NSString *itemID;

//试卷的答案组成
@property (nonatomic,copy) NSString *answers;


@end
