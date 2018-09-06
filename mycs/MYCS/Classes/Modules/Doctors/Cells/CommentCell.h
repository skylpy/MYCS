//
//  CommentCell.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoctorComment,CommentCell;

@protocol CommentCellDelegate <NSObject>

- (void)refreshTable:(CommentCell *)cell;

- (void)praiseBtnDidClick:(CommentCell *)cell andDoctorComment:(DoctorComment *)comment;

@end

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

@property (nonatomic,weak) id<CommentCellDelegate> delegate;

@property (nonatomic,strong) DoctorComment *Dcomment;

@end
