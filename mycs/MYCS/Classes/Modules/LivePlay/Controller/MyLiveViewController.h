//
//  MyLiveViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/4/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

@interface MyLiveViewController : UIViewController

@end

@interface MyLiveCell : UITableViewCell

@property (nonatomic ,strong) LiveListModel *model;

@end




