//
//  MessageEidtorViewCellFrame.h
//  SWWY
//
//  Created by Yell on 15/5/10.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReceiverModel.h"

@interface MessageEidtorViewCellFrame : NSObject

@property(nonatomic,strong)NSArray * peopleList;

@property(nonatomic,strong)NSMutableArray * modelList;

@property(nonatomic,assign)CGFloat btnBeginX;
@property(nonatomic,assign)CGFloat btnEndX;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)int type;
@property(nonatomic,assign)CGFloat rowNum;
@property(nonatomic,assign)CGFloat hiddenCellHeight;

@property(nonatomic,assign)CGFloat cellHeight;

@end
