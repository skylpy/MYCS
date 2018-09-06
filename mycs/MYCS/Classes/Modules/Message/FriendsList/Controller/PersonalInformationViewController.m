//
//  PersonalInformationViewController.m
//  MYCS
//
//  Created by Yell on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "UIButton+WebCache.h"
#import "UIAlertView+Block.h"
#import "AddFriendVerifyViewController.h"
#import <RongIMKit/RongIMKit.h>

#import "DataCacheTool.h"

@interface PersonalInformationViewController ()
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inforViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (weak, nonatomic) IBOutlet UITextView *inforTextView;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细信息";
    [self setInformation];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACCOUNTLOGINERROR object:nil];
}

-(void)setModel:(FriendModel *)model
{
    _model = model;
    
    [self setInformation];
}

-(void)setInformation
{
    self.informationLabel.numberOfLines = 0;
    self.nameLabel.text = _model.name;
    self.areaLabel.text = _model.area;
    self.inforTextView.text = _model.introduction;
    self.informationLabel.text = _model.introduction;
    [self.informationLabel sizeToFit];
    self.informationLabel.text = nil;
    if (self.informationLabel.height + 20 > 50)
    {
        if (self.informationLabel.height + 20 < 180)
        {
            if (ScreenH <= 480)
            {
                self.inforViewHeight.constant = 130;
            }else
            {
                
                self.inforViewHeight.constant = self.informationLabel.height + 20;
            }
        }else
        {
            if (ScreenH <= 480)
            {
                self.inforViewHeight.constant = 130;
            }
            else
            {
                
                self.inforViewHeight.constant = 180;
            }
        }
    }
    else
    {
        self.inforViewHeight.constant = 50;
    }
    
    
    
    if(_model.isfriend){
        [self.addBtn setTitle:@"删除" forState:UIControlStateNormal];
        self.addBtn.backgroundColor = HEXRGB(0xf66060);
    }else
    {
        [self.addBtn setTitle:@"添加好友" forState:UIControlStateNormal];
        self.addBtn.backgroundColor = HEXRGB(0x47c1a9);
    }
    
    [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_model.pic_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"face-h"]];
    
    [FriendModel searchFriendWithKeyword:self.model.friendId Searchtype:@"fanId" Success:^(NSMutableArray * list) {
        FriendModel * model = list[0];
        
        [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.pic_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"face-h"]];
        
    } Failure:^(NSError *error) {
        
    }];
}
- (IBAction)addOrRemoveACtion:(id)sender {
    if (_model.isfriend) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除好友,将与他失去联系 是否继续操作" cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
        [alertView showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
            }else if (buttonIndex == 1)
            {
                [DataCacheTool deleteFriendDataWithfriendId:self.model.friendId];
                
                [self showLoadingHUD];
                [FriendModel removeFriendWithFriendId:self.model.friendId Success:^{
                    
                    [self dismissLoadingHUD];
                    [self showSuccessWithStatusHUD:@"删除成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewsFriends" object:nil];
                    
                    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:self.model.friendId];
                    
                    if (self.isComeFromChatView)
                    {
                        [[AppDelegate sharedAppDelegate].rootNavi popViewControllerAnimated:YES];
                    }
                    [[AppDelegate sharedAppDelegate].rootNavi popViewControllerAnimated:YES];
                    
                } failure:^(NSError *error) {
                    
                    [self dismissLoadingHUD];
                    [self showErrorMessageHUD:@"删除失败"];
                }];
            }
        }];
    }else
    {
        
        AddFriendVerifyViewController *Vc = [[UIStoryboard storyboardWithName:@"AddFriendVerifyViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"AddFriendVerifyViewController"];
        Vc.model = self.model;
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:Vc animated:YES];
        
    }
    
    
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
