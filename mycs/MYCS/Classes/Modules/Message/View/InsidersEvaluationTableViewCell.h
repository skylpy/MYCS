//
//  InsidersEvaluationTableViewCell.h
//  MYCS
//
//  Created by Yell on 16/1/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationModel.h"

@interface InsidersEvaluationTableViewCell : UITableViewCell

@property (nonatomic,assign) EvaluationStutasType stutasType;

@property (nonatomic,strong) EvaluationInsidersModel * model;

@end
