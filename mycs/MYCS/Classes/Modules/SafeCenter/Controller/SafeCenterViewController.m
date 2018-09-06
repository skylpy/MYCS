//
//  SafeCenterViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SafeCenterViewController.h"

#import "BindEmailController.h"
#import "BindPhoneController.h"
#import "MotifyBindEmailController.h"
#import "MotifyBindPhoneController.h"

#import "UserCenterModel.h"
#import "UMengHelper.h"
#import "TencentOAuthHttp.h"
#import "UIAlertView+Block.h"

@interface SafeCenterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UILabel *emailL;
@property (weak, nonatomic) IBOutlet UILabel *weiXInL;
@property (weak, nonatomic) IBOutlet UILabel *qqL;

@property (nonatomic,strong) UserCenterModel * userCenterModel;

@end

@implementation SafeCenterViewController

#pragma mark - 懒加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"安全中心";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self reloadUserCenterData];
}

-(void)refleshData
{
    [self reloadUserCenterData];
}


-(void)buildUIWith:(UserCenterModel *)centerModel{
    
    self.phoneL.text = centerModel.mobile?centerModel.mobile : @"";
    self.phoneL.text = centerModel.mobile.length > 10?centerModel.mobile : @"";
    self.emailL.text = centerModel.email?centerModel.email : @"";
    self.emailL.text = centerModel.email.length > 3?centerModel.email : @"";
    
    self.qqL.text = @"绑定QQ";
    self.weiXInL.text = @"绑定微信";
    
    for (UserBindModel *model in centerModel.bind)
    {
        if ([model.bindType isEqualToString:@"qq"])
        {
            self.qqL.text = model.thusername;
        }
        else if ([model.bindType isEqualToString:@"wx"])
        {
            self.weiXInL.text = model.thusername;
        }
    }
    
    [self dismissLoadingHUD];
    
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier;
    //绑定手机
    if (indexPath.row==0&&indexPath.section==0)
    {
        identifier = self.phoneL.text.length<=10?@"bandPhone":@"modifyPhone";
    }//邮箱
    else if (indexPath.row==1&&indexPath.section==0)
    {
        identifier = self.emailL.text.length<=3?@"bandEmail":@"modifyEmail";
    }//微信
    else if (indexPath.row==2&&indexPath.section==0)
    {
        //微信绑定
        if ([self.weiXInL.text isEqualToString:@"绑定微信"])
        {
            if ([UMengHelper isInstallWechatPlatform])
            {
                [self WechatOAuthLogin];
            }
            else
            {
                [self showErrorMessage:@"请安装手机微信！"];
            }
        }//微信解绑
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您当前绑定的微信昵称为：%@",self.weiXInL.text] cancelButtonTitle:@"取消" otherButtonTitle:@"解绑"];
            
            [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                if (buttonIndex == 1)
                {
                    [self wechatUnBand];
                }
            }];
            
        }
        
    }//QQ
    else if (indexPath.row==3&&indexPath.section==0)
    {
        //QQ绑定
        if ([self.qqL.text isEqualToString:@"绑定QQ"])
        {
            if ([UMengHelper isInstallQQPlatform])
            {
                [self QQOAuthLogin];
            }
            else
            {
                [self showErrorMessage:@"请安装手机QQ！"];
            }
            
        }//QQ解绑
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您当前绑定的QQ昵称为：%@",self.qqL.text] cancelButtonTitle:@"取消" otherButtonTitle:@"解绑"];
            
            [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                if (buttonIndex == 1)
                {
                    [self QQUnBand];
                }
            }];
            
        }
        
    }//微博
    else if (indexPath.row==4&&indexPath.section==0)
    {
        
    }//修改密码
    else if (indexPath.row==0&&indexPath.section==1)
    {
        identifier = @"modifyPassword";
    }
    
    if (identifier)
    {
        [self performSegueWithIdentifier:identifier sender:nil];
    }
}

- (void)QQOAuthLogin {
    
    [UMengHelper tencentLoginWith:self successHandler:^(NSString *openId, NSString *token,NSString *nickName) {
        
        [TencentOAuthHttp thirPartBundlingWithUserID:[AppManager sharedManager].user.uid QQopenID:openId accessToken:token nickName:nickName bundingType:@"qq" success:^(SCBModel *model) {
            
            [self showSuccessWithStatusHUD:@"绑定成功!"];
            [self reloadUserCenterData];
            
        } failure:^(NSError *error) {
            [self showError:error];
        }];
    }];
    
}

- (void)QQUnBand {
    
    [TencentOAuthHttp thirdPartUnBundlingWithUserID:[AppManager sharedManager].user.uid bundType:@"qq" success:^(SCBModel *model) {
        
        [self showSuccessWithStatusHUD:@"解绑成功"];
        [self reloadUserCenterData];

    } failure:^(NSError *error) {
        
        [self showError:error];
        
    }];
    
}

- (void)WechatOAuthLogin {
    
    [UMengHelper wechatLoginWith:self successHandler:^(NSString *openId, NSString *token,NSString *nickName) {
        
        [TencentOAuthHttp thirPartBundlingWithUserID:[AppManager sharedManager].user.uid QQopenID:openId accessToken:token nickName:nickName bundingType:@"wx" success:^(SCBModel *model) {
            
            [self showSuccessWithStatusHUD:@"绑定成功!"];
            [self reloadUserCenterData];

        } failure:^(NSError *error) {
            [self showError:error];
        }];
        
    }];
    
}

- (void)wechatUnBand {
    
    [TencentOAuthHttp thirdPartUnBundlingWithUserID:[AppManager sharedManager].user.uid bundType:@"wx" success:^(SCBModel *model) {
        
        [self showSuccessWithStatusHUD:@"解绑成功"];
        [self reloadUserCenterData];

    } failure:^(NSError *error) {
        
        [self showError:error];
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    __weak typeof(self)SafeVC = self;
    
    if ([segue.identifier isEqualToString:@"modifyPhone"])
    {
        MotifyBindPhoneController *modifyPhone = segue.destinationViewController;
        modifyPhone.oldPhone = self.userCenterModel.mobile;
        
        modifyPhone.SafeCenterDataRefleshBlock = ^(){
            
            [SafeVC reloadUserCenterData];
        };
    }
    else if ([segue.identifier isEqualToString:@"modifyEmail"])
    {
        MotifyBindEmailController *modifyEmailVC = segue.destinationViewController;
        modifyEmailVC.oldEamil = self.userCenterModel.email;
        
        modifyEmailVC.SafeCenterDataRefleshBlock = ^(){
            [SafeVC reloadUserCenterData];
        };
    }
    else if ([segue.identifier isEqualToString:@"bandPhone"])
    {
        BindPhoneController * bindPhoneVC = segue.destinationViewController;
        
        bindPhoneVC.SafeCenterDataRefleshBlock = ^(){
            [SafeVC reloadUserCenterData];
        };
    }
    else if ([segue.identifier isEqualToString:@"bandEmail"])
    {
        BindEmailController * bindEmailVC = segue.destinationViewController;
        
        bindEmailVC.SafeCenterDataRefleshBlock = ^(){
            [SafeVC reloadUserCenterData];
        };
    }
}

#pragma mark - 授权登陆完成代理
- (void)reloadUserCenterData
{
    [self showLoadingHUD];
    
    [UserCenterModel requestUserCenterInformationWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] success:^(UserCenterModel *centerModel) {
        
        self.userCenterModel = centerModel;
        [self buildUIWith:centerModel];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        [self showError:error];
        
    }];
    
}

@end

