//
//  VideoDetailView.h
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorsHealthList.h"

@interface VideoDetailView : UIView

//视频标题
@property (weak, nonatomic) IBOutlet UILabel *titleL;
//视频详情
@property (weak, nonatomic) IBOutlet UILabel *detailL;
//观看次数
@property (weak, nonatomic) IBOutlet UIButton *lookL;
//日期
@property (weak, nonatomic) IBOutlet UILabel *dateL;

@property (weak, nonatomic) IBOutlet UILabel *DoctorInterviewL;

@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet UIButton *showDetailBtn;

@property (nonatomic,assign) BOOL isFisrt;

@property (nonatomic,assign) BOOL showVideoDetail;

@property (nonatomic ,strong) DoctorsHealthDetail *model;

@property (nonatomic,copy) void(^ShowDetailblock)(BOOL showDetail);


+ (instancetype)videoDetailView;

-(void)setlookL;

@end
