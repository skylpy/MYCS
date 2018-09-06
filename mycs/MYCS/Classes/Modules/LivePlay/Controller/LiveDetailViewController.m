//
//  LiveDetailViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/4/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "LiveDetailViewController.h"

@interface LiveDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avartView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostipalLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constBottom;

@end

@implementation LiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configRightBartItems];

    [self buildLiveDetailOther];
}

- (void)buildLiveDetailOther {
    //默认就是自己的直播详情页
    if (self.type == LiveDetailTypeSelf) return;

    self.constBottom.constant = -50;
    [self.view layoutIfNeeded];
}

- (void)configRightBartItems {
    UIBarButtonItem *inviteItem             = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Live_invite"] style:UIBarButtonItemStylePlain target:self action:@selector(inviteAction)];
    UIBarButtonItem *spaceItem              = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *shareItem              = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Live_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItems = @[ spaceItem, inviteItem, shareItem ];
}

#pragma mark - Action
- (void)inviteAction {
}

- (void)shareAction {
}

- (IBAction)editAction:(id)sender {
}
- (IBAction)removeAction:(id)sender {
}
- (IBAction)moreAction:(id)sender {
}


@end
