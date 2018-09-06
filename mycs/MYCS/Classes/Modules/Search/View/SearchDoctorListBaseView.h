//
//  SearchDoctorListBaseView.h
//  MYCS
//
//  Created by wzyswork on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchDoctorListBaseView : UIView


@property (weak, nonatomic) IBOutlet UIView *headView;

@property (nonatomic,strong) NSMutableArray *datasource;

@property(nonatomic,strong)NSString * keyWord;


-(void)reflesh;

+ (instancetype)searchDoctorListBaseView;

@end
