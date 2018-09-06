//
//  VCSDetailViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,VCSDetailType) {
    VCSDetailTypeVideo = 1,
    VCSDetailTypeCourse = 2,
    VCSDetailTypeSOP = 3
};

@class commentListModel,commentReplyListModel,VCSCommentCell,ReplayControl;
@interface VCSDetailViewController : UIViewController

@property (nonatomic,assign) VCSDetailType type;

@property (nonatomic,copy) NSString *videoId;

//活动ID
@property (nonatomic,copy) NSString *activityId;
//是否从活动进入,YES代表是，
@property (nonatomic,assign,getter=isActivity) BOOL activity;

//是否从我的进入,YES代表是，
@property (nonatomic,assign,getter=isMySelft) BOOL mySelft;

@end

@protocol VCSCommentCellDelegate <NSObject>

- (void)VCSCommentCell:(VCSCommentCell *)cell didTapReplyLabel:(ReplayControl *)control commentModel:(commentListModel *)model;
- (void)VCSCommentCell:(VCSCommentCell *)cell showAllButtonAction:(UIButton *)button;
- (void)VCSCommentCell:(VCSCommentCell *)cell replyButtonAction:(UIButton *)button commentModel:(commentListModel *)model;

@end

@interface VCSCommentCell : UITableViewCell

@property (nonatomic,strong) commentListModel *model;

@property (nonatomic,weak) id<VCSCommentCellDelegate> delegate;

- (CGFloat)configWith:(commentListModel *)model;

@end

@interface ReplayControl : UIControl

@property (nonatomic,strong) commentReplyListModel *model;

@end