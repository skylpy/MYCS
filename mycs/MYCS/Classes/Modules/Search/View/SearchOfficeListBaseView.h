//
//  SearchOfficeListBaseView.h
//  MYCS
//
//  Created by wzyswork on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfficePagesViewController.h"

@interface SearchOfficeListBaseView : UIView

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) NSMutableArray *datasource;

+ (instancetype)searchOfficeListBaseView;

@property(nonatomic,strong)NSString * keyWord;

@property (nonatomic,assign)OfficeType type;//1-科室，2-医院，3-实验室，4-企业；

@end
