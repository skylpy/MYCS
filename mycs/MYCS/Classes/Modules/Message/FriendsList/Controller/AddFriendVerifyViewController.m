//
//  FriendVerifyViewController.m
//  MYCS
//
//  Created by Yell on 16/1/28.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AddFriendVerifyViewController.h"

@interface AddFriendVerifyViewController ()

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

@end

@implementation AddFriendVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写验证信息";
    UIBarButtonItem * navRightBtn =[[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendVerifyAction)];
    self.navigationItem.rightBarButtonItem = navRightBtn;
}

-(void)sendVerifyAction
{
    [self showLoadingHUD];
    [FriendModel addFriendWithFriendId:self.model.friendId demand:@"ask" checkcontent:self.verifyTextField.text Success:^{
        [self dismissLoadingHUD];
        [self showSuccessWithStatusHUD:@"好友请求已发送"];
        [[AppDelegate sharedAppDelegate].rootNavi popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        [self showError:error];

    }];
    
}


- (void)didReceiveMemoryWarning {
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
