//
//  SearchVideoListBaseView.h
//  MYCS
//
//  Created by wzyswork on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVideoListBaseView : UIView

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
//type = 1 video; type = 2 course; type = 3 sop;
@property (nonatomic,assign) int type;

@property(nonatomic,strong)NSString * keyWord;

@property (nonatomic,strong) NSMutableArray *datasource;

//@property (nonatomic,copy) void (^moreBtnClickBlock)(int type);

+ (instancetype)SearchVideoListBaseView;


@end
