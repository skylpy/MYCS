//
//  HeadView.h
//  MYCS
//
//  Created by wzyswork on 16/2/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(NSInteger index);


@interface HeadView : UIView
{
    Block _block;
}

- (void)showBlock:(void(^)(NSInteger index))block;

@property (weak, nonatomic) IBOutlet UIButton *searchBar;

+ (instancetype)headView;

@end
