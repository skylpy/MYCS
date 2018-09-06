//
//  NewsListViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/3/17.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NewsType) {
    NewsTypeLast,
    NewsTypeSkill,
    NewsTypeCenter
};

@interface NewsListViewController : UIViewController

@property (nonatomic,assign) NewsType type;

- (void)loadTableView;

@end
