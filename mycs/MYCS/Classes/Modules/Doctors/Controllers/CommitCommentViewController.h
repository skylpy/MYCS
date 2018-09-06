//
//  CommitCommentViewController.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommitCommentControllerDelegate <NSObject>

- (void)commitSuccess;

@end

@interface CommitCommentViewController : UIViewController

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,weak) id<CommitCommentControllerDelegate> delegate;

@end
