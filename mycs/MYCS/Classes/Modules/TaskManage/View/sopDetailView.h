//
//  sopDetailView.h
//  MYCS
//
//  Created by wzyswork on 16/2/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sopDetailView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSArray * sopSourse;

+(instancetype)getSopDetailView;
@end
