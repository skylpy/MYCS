//
//  AssessTaskTableView.h
//  MYCS
//
//  Created by Yell on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitToDoTaskTool.h"


typedef enum{
    AssessTypeTaskCourse,
    AssessTaskTypeSOP
}AssessTaskType;

@class AssessTaskTableView;

@protocol AssessTaskTableViewDelegate <NSObject>

-(void)AssessTaskTableView:(AssessTaskTableView *)view cellDidSelectWithModel:(WaitToDoTask *)model type:(AssessTaskType)type;
@end


@interface AssessTaskTableView : UITableView


@property (nonatomic,assign) AssessTaskType type;

@property (nonatomic,copy) NSString * taskStatus;

@property (nonatomic,assign) id<AssessTaskTableViewDelegate> taskDelegate;


-(void)BeginRefreshing;

@end
