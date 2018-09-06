//
//  EvaluationListViewController.h
//  MYCS
//
//  Created by Yell on 16/1/21.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationListTableView.h"


@interface EvaluationListViewController : UIViewController

@property (nonatomic,assign) EvaluationTargetType targetType;
@property (nonatomic,assign) EvalutaionTableViewType ViewType;

@end
