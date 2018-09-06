//
//  ProfileButton.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileButton : UIButton

- (void)setBadgeValue:(int)value;

@end

@interface ProfileBtnModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *iconName;

@property (nonatomic,copy) NSString *storyBoardName;
@property (nonatomic,copy) NSString *controllerId;

+ (instancetype)modelWithTitle:(NSString *)title iconName:(NSString *)iconName storyBoardName:(NSString *)storyBoardName controllerId:(NSString *)controllerId;

+ (NSArray *)modelMenuesWith:(UserType)userType;

@end