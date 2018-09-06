//
//  EvaluationListTableView.h
//  MYCS
//
//  Created by Yell on 16/1/21.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvalutaionTableViewCellHeight.h"
#import "EvaluationModel.h"

@class EvaluationListTableView;
@protocol EvaluationTableViewCellDelegate <NSObject>

-(void)selectReplyButton:(EvaluationListTableView *)tableView WithModel:(EvaluationOtherModel *)model;

@end

@interface EvaluationListTableView : UITableView

@property (nonatomic,strong) NSMutableArray * listDataSource;

@property (assign,nonatomic) int page;

@property (nonatomic,assign) id<EvaluationTableViewCellDelegate> delegateVS;

@property (nonatomic,assign) EvalutaionTableViewType ViewType;

@property (nonatomic,assign) EvaluationStutasType StatusType;

@property (nonatomic,assign) EvaluationTargetType targetType;


-(void)RefreshList;

@end
