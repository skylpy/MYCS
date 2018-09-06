//
//  TaskPaperViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/27.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaperModel.h"

@class UserAnswer;

@interface TaskPaperViewController : UIViewController

@property (nonatomic,strong) PaperModel *paperModel;

@property (nonatomic,copy) void(^CompleteBlock)(UserAnswer *);

+ (instancetype)presentWith:(UIViewController *)vc paperModel:(PaperModel *)model;

@end

@interface TaskOptionCell : UITableViewCell

@property (nonatomic,strong) OptionModel *optionModel;
@property (nonatomic,copy) NSString *optionType;
@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) void(^buttonAction)(void);

@end

@interface TaskOptionButton : UIButton

@property (nonatomic,copy) NSString *optionType;

@end

@interface UserAnswer : NSObject

@property (nonatomic,copy) NSString *paperId;
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,copy) NSString *answerId;
@property (nonatomic,assign) int finishTime;
@property (nonatomic,copy) NSString *finishTimeString;
@property (nonatomic,strong) NSMutableArray *paperIdArr;
@end