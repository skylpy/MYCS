//
//  CasePlayerCell.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AcademicExchangeModel.h"

@class CasePlayerCell;

@protocol CasePlayerCellDelegate <NSObject>

@optional
- (void)refreshCasePlayerCellTable:(CasePlayerCell *)cell;

- (void)responseCasePlayerCellReplyAction:(AcademicExchangeModel *)model;

- (void)controlCasePlayerCellActionWith:(AcademicExchangeModel *)model index:(int)index;

- (void)praiseCasePlayerCellBtnDidClick:(CasePlayerCell *)cell andDoctorComment:(AcademicExchangeModel *)model;

- (void)playCasePlayerCellVideoWith:(AcademicExchangeModel *)model titil:(NSString *)title;

@end

@interface CasePlayerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

@property (nonatomic,strong) NSArray *imageArr;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,weak) id<CasePlayerCellDelegate> delegate;

@property (nonatomic,strong) AcademicExchangeModel *academicModel;


@end
