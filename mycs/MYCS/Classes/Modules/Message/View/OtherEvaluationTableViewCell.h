//
//  OtherEvaluationTableViewCell.h
//  MYCS
//
//  Created by Yell on 16/1/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationModel.h"
@class OtherEvaluationTableViewCell;

@protocol OtherEvaluationTableViewCellDelegate <NSObject>

-(void)selectCell:(OtherEvaluationTableViewCell *)cell WithModel:(EvaluationOtherModel *)model;

@end

@interface OtherEvaluationTableViewCell : UITableViewCell

@property (nonatomic,strong) EvaluationOtherModel * model;

@property (nonatomic,assign) id<OtherEvaluationTableViewCellDelegate> delegate;

@property (nonatomic,assign) EvaluationTargetType targeType;

@property (nonatomic,assign) EvaluationStutasType stutasType;

@end
