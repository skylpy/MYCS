//
//  CommentViewController.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,strong) NSMutableArray *commentList;

-(void)reloadData;

@end
