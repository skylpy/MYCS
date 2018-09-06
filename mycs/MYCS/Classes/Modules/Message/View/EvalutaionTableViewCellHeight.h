//
//  EvalutaionTableViewCellHeight.h
//  MYCS
//
//  Created by Yell on 16/1/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvaluationModel.h"



@interface EvalutaionTableViewCellHeight : NSObject

+(CGFloat)calculateCellHeightWithOtherModel:(EvaluationOtherModel *)model view:(UIView *)view andStutasType:(EvaluationStutasType)stutasType andTargeType:(EvaluationTargetType)targeType;

+(CGFloat)calculateCellHeightWithInsidersModel:(EvaluationInsidersModel *)model view:(UIView *)view andStutasType:(EvaluationStutasType)stutasType;
@end
