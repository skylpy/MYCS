//
//  RegisterViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/3/3.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *titleSegment;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Action
- (IBAction)titleSegmentAction:(UISegmentedControl *)sender {
    
    NSInteger selectIdx = sender.selectedSegmentIndex;
    
    self.scrollView.contentOffset = CGPointMake(self.view.width*selectIdx, 0);
}

#pragma mark - Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger index = (scrollView.contentOffset.x+scrollView.width*0.5)/scrollView.width;
    
    self.titleSegment.selectedSegmentIndex = index;
    
}

@end
