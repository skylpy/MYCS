//
//  VideoManageController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,VideoSpaceType) {
    VideoSpaceTypeVideo,
    VideoSpaceTypeCourse,
    VideoSpaceTypeSOP
};

@interface VideoSpaceController : UIViewController

@property (nonatomic,assign) VideoSpaceType type;

@end
