//
//  HealthCommentCell.h
//  MYCS
//
//  Created by GuiHua on 16/7/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralCommentModel.h"

@class HealthCommentCell,ReplayContentControl;
@protocol HealthCommentCellDelegate <NSObject>

- (void)HealthCommentCell:(HealthCommentCell *)cell didTapReplyLabel:(ReplayContentControl *)control commentModel:(GeneralCommentModel *)model;
- (void)HealthCommentCell:(HealthCommentCell *)cell showAllButtonAction:(UIButton *)button;
- (void)HealthCommentCell:(HealthCommentCell *)cell replyButtonAction:(UIButton *)button commentModel:(GeneralCommentModel *)model;

@end

@interface HealthCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameL;

@property (weak, nonatomic) IBOutlet UILabel *userCommentL;

@property (weak, nonatomic) IBOutlet UILabel *commentTimeL;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (weak, nonatomic) IBOutlet UIView *replyContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyContentViewConstH;

@property (nonatomic, strong) UIButton *showAllReplyButton;

@property (strong, nonatomic)GeneralCommentModel *model;

@property (nonatomic,weak) id<HealthCommentCellDelegate> delegate;

- (CGFloat)configWith:(GeneralCommentModel *)model;

@end


@interface ReplayContentControl : UIControl

@property (nonatomic,strong) GeneralCommentModel *sunModel;

@end

