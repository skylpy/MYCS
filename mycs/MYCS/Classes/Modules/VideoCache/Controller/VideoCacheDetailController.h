//
//  VideoCacheDetailController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/2/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChapterModel;
@interface VideoCacheDetailController : UIViewController

@property (nonatomic,copy) NSString *objectId;

@end

@interface CachedDetailCell : UITableViewCell

@property (nonatomic,copy) ChapterModel *chapter;

@property (nonatomic,copy) void(^chooseBtnAction)(ChapterModel *cacheChapter,BOOL choose);

@property (nonatomic,assign) BOOL expand;
@property (nonatomic,assign) BOOL choose;

@end
