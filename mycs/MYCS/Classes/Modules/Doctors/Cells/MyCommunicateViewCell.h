//
//  CommunicateViewCell.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AcademicExchangeModel.h"

@class MyCommunicateViewCell;

@protocol CommunicateViewCellDelegate <NSObject>

- (void)refreshMyCommunicateViewCellTable:(MyCommunicateViewCell *)cell;

- (void)responseMyCommunicateViewCellReplyAction:(AcademicExchangeModel *)model;

- (void)controlMyCommunicateViewCellActionWith:(AcademicExchangeModel *)model index:(int)index;

- (void)praiseMyCommunicateViewCellBtnDidClick:(MyCommunicateViewCell *)cell andDoctorComment:(AcademicExchangeModel *)model;

@end

@interface MyCommunicateViewCell : UITableViewCell

@property (nonatomic,weak) id<CommunicateViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,strong) NSMutableArray *applyList;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) AcademicExchangeModel *academicModel;

//image数组必须在content前初始化
@property (nonatomic,strong) NSArray *imageArr;

@end
