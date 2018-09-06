//
//  SpolightHelper.h
//  test
//
//  Created by AdminZhiHua on 15/11/4.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpolightModel : NSObject

///Spolight显示的标题-require
@property (nonatomic,copy) NSString *title;

///Spolight显示的描述-require
@property (nonatomic,copy) NSString *desc;

///Spolight显示的缩略图-(imageData二选一设置)
@property (nonatomic,strong) UIImage *image;

///设置image就会自动转换成imageData
@property (nonatomic,strong) NSData *imageData;

///SpolightItem设置的标志-require
@property (nonatomic,copy) NSString *identify;

///SpolightItem设置的标志-option(不设置默认为cn.mycs)
@property (nonatomic,copy) NSString *domain;

///Spolight显示的phoneNumber数组-（设置也不显示）
@property (nonatomic,copy) NSArray *phoneNumbers;


@end

@interface SpolightHelper : NSObject

///添加searchItem
+ (void)addSearchItem:(SpolightModel *)model;

///根据identify删除searchItem
+ (void)deleteSearchItemById:(NSString *)identify;

///根据domain删除searchItem
+ (void)deleteSearchItemByDomain:(NSString *)domain;

///删除所有的searchItems
+ (void)deleteAllSearchItems;

@end
