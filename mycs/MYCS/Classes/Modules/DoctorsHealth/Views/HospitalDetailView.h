//
//  HospitalDetailView.h
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorsHealthList.h"

@interface HospitalDetailView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *hospitalImageView;

@property (weak, nonatomic) IBOutlet UILabel *hospitalNameL;

@property (weak, nonatomic) IBOutlet UILabel *hospitalOfficeL;

@property (weak, nonatomic) IBOutlet UILabel *hospitalDetailL;

@property (weak, nonatomic) IBOutlet UIButton *showDetailBtn;

@property (nonatomic,assign) BOOL showHopitalDetail;

@property (nonatomic ,strong) DoctorsHealthHosptial * model;

@property (nonatomic,copy) void(^ShowDetailblock)(BOOL showDetail);

@property (nonatomic,copy) void(^tapImageViewblock)();

+ (instancetype)hospitalDetailView;

@end
