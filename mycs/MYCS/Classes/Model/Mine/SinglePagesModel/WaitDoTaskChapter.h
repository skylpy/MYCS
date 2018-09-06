//
//  WaitDoTaskChapter.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "PaperModel.h"
#import "WaitDoTaskVideo.h"

@protocol WaitDoTaskChapter
@end

//=======================任务章节列表对象======================//
@interface WaitDoTaskChapter : JSONModel

@property (strong, nonatomic) NSString *chapterId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *paperCount;
@property (strong, nonatomic) NSArray<PaperModel> *papers;
@property (strong, nonatomic) NSNumber *tryChapter;
@property (strong, nonatomic) WaitDoTaskVideo *video;

@end
