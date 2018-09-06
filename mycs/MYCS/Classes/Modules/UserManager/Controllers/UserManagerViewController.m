//
//  UserManagerViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "UserManagerViewController.h"

@interface UserManagerViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greenViewLeft;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menusBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) UIButton * selectBtn;

@end

@implementation UserManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户管理";
    
    self.scrollView.delegate = self;
   
    
    [self menusBtnAction:self.menusBtn[0]];
}


#pragma mark -- menusBtn Action
- (IBAction)menusBtnAction:(UIButton *)sender
{
    
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    self.selectBtn.selected = YES;
    NSInteger tag = sender.tag;
    
     self.scrollView.contentSize = CGSizeMake(ScreenW * 2, self.scrollView.height);
    [UIView animateWithDuration:0.25 animations:^{
        
        self.greenViewLeft.constant = sender.x;
        self.scrollView.contentOffset = CGPointMake(self.view.width*tag, 0);
        
    } completion:^(BOOL finished) {
        
        if (tag == 0)
        {
            
        }else if (tag == 1)
        {
            
        }
    }];

}

#pragma mark - *** UIScrollView Delegate ***
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSUInteger page = scrollView.contentOffset.x/self.view.width;
    if (page >= 2)
    {
        self.scrollView.contentOffset = CGPointMake(self.view.width*1, 0);
        return;
    }
    UIButton *button = self.menusBtn[page];
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    
    [self menusBtnAction:button];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
