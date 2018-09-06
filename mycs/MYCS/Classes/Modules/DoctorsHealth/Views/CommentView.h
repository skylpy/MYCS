//
//  CommentView.h
//  MYCS
//
//  Created by GuiHua on 16/7/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthCommentCell.h"
#import "GeneralCommentModel.h"
#import "UIView+Message.h"
#import "MJRefresh.h"

@interface CommentView : UIView<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HealthCommentCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *numbL;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *plceHolderL;

@property (nonatomic,strong) NSMutableArray * dataArrs;

@property (nonatomic,strong) UIView *tapView;

@property (nonatomic ,assign) CGFloat cellHeight;

@property (nonatomic ,assign) int page;

@property (nonatomic, copy) NSString * targetId;

//发表评论需要
@property (nonatomic, copy) NSString *toEid;
@property (nonatomic, copy) NSString *toUid;
//评论后的id
@property (nonatomic, copy) NSString * commentId;

+ (instancetype)showInView:(UIView *)superView WithTargetId:(NSString *)targetId;

- (void)addKeyboardNotification;
- (void)removeNotification;
@end
