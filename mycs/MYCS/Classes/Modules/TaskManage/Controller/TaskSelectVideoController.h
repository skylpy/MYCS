//
//  TaskSelectVideoController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TaskSelectVideoType) {
    TaskSelectVideoTypeCommon,
    TaskSelectVideoTypeSOP
};

@class Course,Sop;
@interface TaskSelectVideoController : UIViewController

@property (nonatomic,copy) void(^completeBlock)(Course *courseModel,Sop *sopModel);

@property (nonatomic,assign) TaskSelectVideoType type;

@end

@interface TaskSelectVideoCell : UITableViewCell

@property (nonatomic,strong) Course *courseModel;
@property (nonatomic,strong) Sop *sopModel;

- (void)setCellSelect:(BOOL)select;

@end
