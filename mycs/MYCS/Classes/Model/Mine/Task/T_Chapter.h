//
//  T_Chapter.h
//  SWWY
//
//  Created by 黄希望 on 15-1-25.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "PaperModel.h"
@protocol T_Chapter @end

/**
 *  普通任务详情中的章节类
 */
@interface T_Chapter : JSONModel

@property (strong,nonatomic) NSString *videoId;         // 视频ID
@property (strong,nonatomic) NSString *name;            // 视频名称
@property (strong,nonatomic) NSString *mp4Url;          // 视频地址




@end
