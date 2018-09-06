//
//  DoctorDetailView.h
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorsHealthList.h"

@interface DoctorDetailView : UIView

#pragma mark - 第三个View
//医生头像（不是疾病的时候是医院头像）
@property (weak, nonatomic) IBOutlet UIImageView *doctorImageView;
//医生名称（不是疾病的时候是医院头名称）
@property (weak, nonatomic) IBOutlet UILabel *doctorNameL;
//医生岗位（不是疾病的时候是隐藏）
@property (weak, nonatomic) IBOutlet UILabel *doctorObjL;
//医生相关的委员会（不是疾病的时候是医院相关的委员会）
@property (weak, nonatomic) IBOutlet UILabel *doctorOfficeL;
//医生所在医院（不是疾病的时候隐藏）
@property (weak, nonatomic) IBOutlet UILabel *doctorHospital;
//医生详情（不是疾病的时候是医院详情）
@property (weak, nonatomic) IBOutlet UILabel *doctorDetailL;
//第三个view的高度

@property (weak, nonatomic) IBOutlet UIButton *showDetailBtn;

@property (nonatomic,assign) BOOL showDoctorDetail;

@property (nonatomic,strong) DoctorsHealthDoctor *model;

@property (nonatomic,copy) void(^ShowDetailblock)(BOOL showDetail);

@property (nonatomic,copy) void(^tapImageViewblock)();

@property (nonatomic,copy) void(^hospitalNameTapblock)();

+ (instancetype)doctorDetailView;

@end
