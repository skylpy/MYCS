//
//  UserCenterInfoController.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/17.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UserCenterInfoController.h"
#import "UserCenterModel.h"
#import "AppManager.h"
#import "UserInfoCellModel.h"
#import "UserInfoCell.h"
#import "UserAvartCell.h"
#import "EnumDefine.h"
#import "NSDate+Util.h"
#import "UIViewController+Message.h"
#import "UserCenterImagePickerView.h"
#import "UIViewController+Message.h"
#import "SDImageCache.h"
#import "UIImage+FX.h"
#import "UIImageView+WebCache.h"
#import "UserEditIntroductionController.h"
#import "UserEditSkillController.h"
#import "UserEditResponserController.h"
#import "UserEditCompanyPositionController.h"
#import "SelectPickView.h"
#import "RefreshUserInfoRCIM.h"

#import "PopUpView.h"

@interface UserCenterInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) NSArray *cellInfoArr;

@property(nonatomic,strong) NSString * edictTitle;

@property(nonatomic,strong) UserCenterModel * centerModel;

@property (retain,nonatomic)NSArray * arrays;

@property (nonatomic,strong)PopUpView * popUpView;

@property (nonatomic,strong) SelectPickView *pickView;

@end

@implementation UserCenterInfoController

#pragma mark – life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    //    [super viewWillAppear:animated];
    
    AppManager *manager = [AppManager sharedManager];
    self.centerModel = manager.userCenterModel;
    if (self.centerModel)
    {
        [self getArr:self.centerModel];
        
    }else
    {
        [self requestUserInfo];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.pickView removeFromSuperview];
    
}

#pragma mark – Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellInfoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = self.cellInfoArr[section];
    return arr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *sectionArr = self.cellInfoArr[indexPath.section];
    UserInfoCellModel *model = sectionArr[indexPath.row];
    
    if ([model.reuseId isEqualToString:@"UserAvartCell"])
    {
        UserAvartCell *cell = [tableView dequeueReusableCellWithIdentifier:model.reuseId];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:model.reuseId];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *sectionArr = self.cellInfoArr[indexPath.section];
    UserInfoCellModel *model = sectionArr[indexPath.row];
    
    if ([model.reuseId isEqualToString:@"UserAvartCell"])
    {
        return 90;
    }
    else
    {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArr = self.cellInfoArr[indexPath.section];
    UserInfoCellModel *model = sectionArr[indexPath.row];
    
    if ([model.pushIdentifier isEqualToString:@"exit"])
    {
        [self.popUpView removeFromSuperview];
        
        __weak __typeof(self)weakSelf = self;
        [[PopUpView popUpView] showInitView:self array: self.dataSouces bools:YES  block:^(NSInteger index) {
            
            if (index == 1) {
                [self.popUpView removeFromSuperview];
                [AppManager loginOut];
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                //跳转到首页
                UITabBarController *mainTabBar = (UITabBarController *)[AppDelegate sharedAppDelegate].rootNavi.topViewController;
                
                mainTabBar.selectedIndex = 0;
                
                return;
            }
            
        }];
        
    }
    else if ([model.pushIdentifier isEqualToString:@"this"])
    {
        
        [UserCenterImagePickerView showWithComplete:^(UserCenterImagePickerView *view, NSUInteger index) {
            
            //index == 1(拍照)，index == 2(选择)，index == 0(取消)
            if (index == 1)
            {
                [self takePhotoAction];
            }
            else if (index == 2)
            {
                [self pickImageAction];
            }
            
        }];
        
    }else if([model.pushIdentifier isEqualToString:@"city"])
    {
        [self.pickView removeFromSuperview];
        
        self.pickView = [SelectPickView selectPickView];
        self.pickView.type = SelectPickViewTypeArea;
        
        
        if (self.centerModel.placeStr.length > 3)
        {
            NSString *prov = [self.centerModel.placeStr substringToIndex:4];
            if ([prov hasSuffix:@" "])
            {
                prov = [prov substringToIndex:3];
            }
            
            NSArray * arr = [[self.centerModel.placeStr substringFromIndex:3] componentsSeparatedByString:@" "];
            
            if (arr.count <= 1)
            {
                [self.pickView selectWith:prov andCity:@"" andArea:@""];
                
            }else if (arr.count == 2)
            {
                [self.pickView selectWith:prov andCity:arr[1] andArea:@""];
            }
            else if (arr.count == 3)
            {
                
                [self.pickView selectWith:prov andCity:arr[1] andArea:arr[2]];
            }
            
        }
        else
        {
            
            if (self.centerModel.placeStr.length > 0 || self.centerModel.placeStr.length == 0)
            if (self.centerModel.placeStr.length >= 0.f)
            {
                [self.pickView selectWith:self.centerModel.placeStr andCity:@"" andArea:@""];
            }
            
        }
        
        [self.pickView showWithBlock:^(SelectPickView *view, NSString *selectString, NSString *provId, NSString *cityId, NSString *areaId, NSString *itemId) {
            
            NSString * upLoadAreaId = [NSString string];
            
            if (areaId == nil && cityId == nil)
            {
                upLoadAreaId = provId;
                
            }else if (areaId == nil)
            {
                upLoadAreaId = cityId;
                
            }else
            {
                upLoadAreaId = areaId;
            }
            
            [self changeCityWith:upLoadAreaId];
        }];
    }
    else
    {
        if (!model.pushIdentifier) return;
        [self performSegueWithIdentifier:model.pushIdentifier sender:nil];
    }
    
}
/*!
 @author Sky, 16-04-18 11:04:32
 
 @brief 弹出的数据
 
 */
-(NSArray *)dataSouces{
    
    ComfirmModel *model1 = [ComfirmModel comfirmModelWith:@"是否退出登录？" titleColor:[UIColor blackColor]];
    ComfirmModel *model2 = [ComfirmModel comfirmModelWith:@"退出登录" titleColor:[UIColor redColor]];
    ComfirmModel *model3 = [ComfirmModel comfirmModelWith:@"取消" titleColor:[UIColor blackColor]];
    
    
    NSArray *dataSource = @[ model1, model2, model3];
    
    return dataSource;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditIntroduction"])
    {
        UserEditIntroductionController * edictVC = segue.destinationViewController;
        
        edictVC.title = self.edictTitle;
        
        edictVC.SureBlock = ^(){
            [self requestUserInfo];
        };
    }else if ([segue.identifier isEqualToString:@"EditSkill"])
    {
        UserEditSkillController * edictVC = segue.destinationViewController;
        
        edictVC.SureBlock = ^(){
            [self requestUserInfo];
        };
    }else if ([segue.identifier isEqualToString:@"EditCompanyPosition"])
    {
        UserEditCompanyPositionController * edictVC = segue.destinationViewController;
        
        edictVC.SureBlock = ^(){
            [self requestUserInfo];
        };
    }else if ([segue.identifier isEqualToString:@"EditResponser"])
    {
        UserEditResponserController * edictVC = segue.destinationViewController;
        
        edictVC.SureResponserBlock = ^(){
            [self requestUserInfo];
        };
    }
}

-(void)changeCityWith:(NSString *)changeId;
{
    
    [UserCenterModel changePlaceWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] areaId:changeId  success:^{
        
        [self requestUserInfo];
        
        [self showSuccessWithStatusHUD:@"修改成功"];
        
    } failure:^(NSError *error) {
        
        [self showErrorMessage:@"修改失败"];
        
    }];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self showLoadingHUD];
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *newImage = [self renderImage:image];
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.8);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    NSString *imageStr = [imageData base64Encoding];
    
#pragma clang diagnostic pop
    
    [UserCenterModel uploadPhotoDataWithuploadPhotoData:imageStr success:^(NSString *str) {
        
        [self dismissLoadingHUD];
        
        [self showSuccessWithStatusHUD:@"头像上传成功"];
        
        NSString *key = [NSString stringWithFormat:@"%@?imageView2/0/w/%d/h/%d/format/jpg/q/100",[AppManager sharedManager].user.userPic,60*2,60 * 2];
        
        [[SDImageCache sharedImageCache] storeImage:newImage forKey:key];
        
        ///重新加载信息
        //            [self requestUserInfo];
        
        UserAvartCell * cell = (UserAvartCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.avartView.image = newImage;
        
        //刷新融云聊天的自己头像
        [RefreshUserInfoRCIM refreshUserInfoCacheUserID:[AppManager sharedManager].user.uid];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        [self showErrorMessage:@"头像上传失败"];
        
    }];
    
}

- (UIImage *)renderImage:(UIImage *)image {
    
    UIImage *newImage = [image imageCroppedAndScaledToSize:CGSizeMake(60, 60) contentMode:UIViewContentModeScaleToFill padToFit:NO];
    
    return newImage;
}


#pragma mark – CustomDelegate



#pragma mark – Event
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

///拍照
- (void)takePhotoAction {
    
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    [imagePickerVC setSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePickerVC.delegate = self;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

//从手机相册中选择
- (void)pickImageAction {
    
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imagePickerVC.delegate = self;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - Network
- (void)requestUserInfo {
    
    [self showLoadingHUD];
    
    User *user = [AppManager sharedManager].user;
    
    [UserCenterModel requestUserCenterInformationWithUserID:user.uid userType:[NSString stringWithFormat:@"%d",user.userType] success:^(UserCenterModel *centerModel) {
        
        AppManager *manager = [AppManager sharedManager];
        manager.userCenterModel = centerModel;
        
        self.centerModel = centerModel;
        
        [self getArr:centerModel];
        
        [self dismissLoadingHUD];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        
    }];
    
}

-(void)getArr:(UserCenterModel *)centerModel
{
    User *user = [AppManager sharedManager].user;
    
    if (user.userType == UserType_personal) {
        
        self.title = @"个人信息";
        self.cellInfoArr = [self createPersonInfoModelArr:centerModel];
        
    } else if (user.userType == UserType_employee) {
        
        self.title = @"员工信息";
        self.cellInfoArr = [self createEmployeeInfoModelArr:centerModel];
        
    } else if (user.userType == UserType_company)
    {
        if ([AppManager sharedManager].user.agroup_id.intValue == 9 || [AppManager sharedManager].user.agroup_id.intValue == 10) {
            
            self.title = @"帐号资料";
            self.cellInfoArr = [self createCommissionInfoModelArr:centerModel];
        }
        else{
        
            if ([centerModel.enterType integerValue] == platform_company) {
                
                self.title = @"企业信息";
                self.cellInfoArr = [self createEnterpriseModelArr:centerModel];
                
            } else if ([centerModel.enterType integerValue] == platform_hospital)
            {
                
                self.title = @"医院信息";
                self.cellInfoArr = [self createHospitalModelArr:centerModel];
                
            } else if ([centerModel.enterType integerValue] == platform_laboratory) {
                
                self.title = @"实验室信息";
                self.cellInfoArr = [self createLaboratoryModelArr:centerModel];
                
            } else if ([centerModel.enterType integerValue] == platform_office)
            {
                
                self.title = @"科室信息";
                self.cellInfoArr = [self createOfficeModelArr:centerModel];
                
            }

        }
    }
    else if (user.userType == UserType_organization)
    {
        
        self.title = @"机构信息";
        self.cellInfoArr = [self createOrganizeModelArr:centerModel];
        
    }
    
    [self.tableView reloadData];
}

#pragma mark – Private
//卫计委账号中心
-(NSArray *)createCommissionInfoModelArr:(UserCenterModel *)model {

    UserInfoCellModel *model1 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"专属域名" detail:model.domain isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model2 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"机构全称" detail:model.realname isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model3 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"所在城市" detail:model.placeStr isShowArrow:YES pushIdentifier:@"city"];
    
    UserInfoCellModel *model4 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"联系人姓名" detail:model.contact isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model5 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"联系人电话" detail:model.mobile isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model6 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"联系人职位" detail:model.jobTitleStr isShowArrow:NO pushIdentifier:nil];
    NSArray *section = @[model1,model2,model3,model4,model5,model6];
    
    UserInfoCellModel *model9 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"退出登录" detail:nil isShowArrow:NO pushIdentifier:@"exit"];
    
    NSArray *section2 = @[model9];
    
    return @[section,section2];
    
}

/*!
 @author Sky, 16-05-23 15:05:26
 
 @brief
 
 @param model
 
 @return
 
 @since
 */
- (NSArray *)createEmployeeInfoModelArr:(UserCenterModel *)model {
    
    UserInfoCellModel *model1 = [UserInfoCellModel initWith:@"UserAvartCell" title:@"头像" detail:model.avatar isShowArrow:YES pushIdentifier:@"this"];
    
    NSArray *section1 = @[model1];
    
    UserInfoCellModel *model2 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"真实姓名" detail:model.realname isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model3 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"所属公司" detail:model.company isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model4 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"公司职位" detail:model.position isShowArrow:YES pushIdentifier:@"EditCompanyPosition"];
    
    UserInfoCellModel *model5 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"个人简介" detail:model.introduction isShowArrow:YES pushIdentifier:@"EditIntroduction"];
    
    self.edictTitle = @"个人简介";
    
    NSArray *section2 = @[model2,model3,model4,model5];
    
    UserInfoCellModel *model9 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"退出登录" detail:nil isShowArrow:NO pushIdentifier:@"exit"];
    
    NSArray *section4 = @[model9];
    
    return @[section1,section2,section4];
}

- (NSArray *)createPersonInfoModelArr:(UserCenterModel *)model {
    
    UserInfoCellModel *model1 = [UserInfoCellModel initWith:@"UserAvartCell" title:@"头像" detail:model.avatar isShowArrow:YES pushIdentifier:@"this"];
    
    NSArray *section1 = @[model1];
    
    UserInfoCellModel *model2 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"真实姓名" detail:model.realname isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model3 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"昵    称" detail:[AppManager sharedManager].user.username isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model4 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"个人主页" detail:model.domain isShowArrow:NO pushIdentifier:nil];
    
    NSString *workTime;
    if (model.work_time_end.floatValue == 0) {
        workTime = [NSString stringWithFormat:@"%@ - 至今", [NSDate dateWithTimeInterval:[model.work_time_start floatValue] format:@"yyyy-MM-dd"]];
    }else
    {
        workTime = [NSString stringWithFormat:@"%@ - %@", [NSDate dateWithTimeInterval:[model.work_time_start floatValue] format:@"yyyy-MM-dd"],[NSDate dateWithTimeInterval:[model.work_time_end floatValue] format:@"yyyy-MM-dd"]];
    }
    UserInfoCellModel *model5 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"工作时长" detail:workTime isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model6 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"所在城市" detail:model.placeStr isShowArrow:YES pushIdentifier:@"city"];
    
    UserInfoCellModel *model7 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"擅    长" detail:model.skill isShowArrow:YES pushIdentifier:@"EditSkill"];
    
    UserInfoCellModel *model8 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"个人简介" detail:model.introduction isShowArrow:YES pushIdentifier:@"EditIntroduction"];
    
    self.edictTitle = @"个人简介";
    
    NSArray *section2;
    if ([model.agroup_id isEqualToString:@"193"])
    {
        section2 = @[model2,model3,model4,model5,model6,model7,model8];
    }
    else
    {
        section2 = @[model2,model3,model4,model8];
    }
    
    UserInfoCellModel *model13 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"退出登录" detail:nil isShowArrow:NO pushIdentifier:@"exit"];
    
    NSArray *section4 = @[model13];
    
    return @[section1,section2,section4];
}

- (NSArray *)createEnterpriseModelArr:(UserCenterModel *)model {
    
    UserInfoCellModel *model1 = [UserInfoCellModel initWith:@"UserAvartCell" title:@"头像" detail:model.avatar isShowArrow:YES pushIdentifier:@"this"];
    
    NSArray *section1 = @[model1];
    
    UserInfoCellModel *model2 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"企业名称" detail:model.realname isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model3 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"所属专业" detail:model.industry isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model4 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"专属域名" detail:model.domain isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model5 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"企业介绍" detail:model.introduction isShowArrow:YES pushIdentifier:@"EditIntroduction"];
    
    self.edictTitle = @"企业介绍";
    
    UserInfoCellModel *model11 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"负责人" detail:model.contact isShowArrow:YES pushIdentifier:@"EditResponser"];
    
    NSArray *section2 = @[model2,model3,model4,model5,model11];
    
    UserInfoCellModel *model10 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"退出登录" detail:nil isShowArrow:NO pushIdentifier:@"exit"];
    
    NSArray *section4 = @[model10];
    
    return @[section1,section2,section4];
}

- (NSArray *)createHospitalModelArr:(UserCenterModel *)model {
    
    UserInfoCellModel *model1 = [UserInfoCellModel initWith:@"UserAvartCell" title:@"头像" detail:model.avatar isShowArrow:YES pushIdentifier:@"this"];
    
    NSArray *section1 = @[model1];
    
    UserInfoCellModel *model2 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"医院全称" detail:model.realname isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model3 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"负责人" detail:model.contact isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model4 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"专属域名" detail:model.domain isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model5 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"行政职位" detail:model.posTitle isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model6 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"职    称" detail:model.jobTitleStr isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model7 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"所在城市" detail:model.placeStr isShowArrow:YES pushIdentifier:@"city"];
    
    
    NSArray *section2 = @[model2,model3,model4,model5,model6,model7];
    
    UserInfoCellModel *model12 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"退出登录" detail:nil isShowArrow:NO pushIdentifier:@"exit"];
    
    NSArray *section4 = @[model12];
    
    return @[section1,section2,section4];
}

- (NSArray *)createLaboratoryModelArr:(UserCenterModel *)model {
    
    UserInfoCellModel *model1 = [UserInfoCellModel initWith:@"UserAvartCell" title:@"头像" detail:model.avatar isShowArrow:YES pushIdentifier:@"this"];
    
    NSArray *section1 = @[model1];
    
    UserInfoCellModel *model2 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"实验室名称" detail:model.realname isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model3 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"专属域名" detail:model.domain isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model4 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"实验室介绍" detail:model.introduction isShowArrow:YES pushIdentifier:@"EditIntroduction"];
    
    self.edictTitle = @"实验室介绍";
    
    UserInfoCellModel *model5 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"负责人" detail:model.contact isShowArrow:YES pushIdentifier:@"EditResponser"];
    
    
    NSArray *section2 = @[model2,model3,model4,model5];
    
    UserInfoCellModel *model12 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"退出登录" detail:nil isShowArrow:NO pushIdentifier:@"exit"];
    
    NSArray *section4 = @[model12];
    
    return @[section1,section2,section4];
}

- (NSArray *)createOfficeModelArr:(UserCenterModel *)model {
    
    UserInfoCellModel *model1 = [UserInfoCellModel initWith:@"UserAvartCell" title:@"头像" detail:model.avatar isShowArrow:YES pushIdentifier:@"this"];
    
    NSArray *section1 = @[model1];
    
    UserInfoCellModel *model2 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"昵    称" detail:model.realname isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model3 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"所属科室" detail:model.divisionName isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model4 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"专属域名" detail:model.domain isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model5 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"医院全称" detail:model.hospital isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model6 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"负责人" detail:model.contact isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model7 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"行政职位" detail:model.posTitle isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model13 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"所在城市" detail:model.placeStr isShowArrow:YES pushIdentifier:@"city"];
    
    NSArray *section2 = @[model2,model3,model4,model5,model6,model7,model13];
    
    UserInfoCellModel *model12 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"退出登录" detail:nil isShowArrow:NO pushIdentifier:@"exit"];
    
    NSArray *section4 = @[model12];
    
    return @[section1,section2,section4];
}

- (NSArray *)createOrganizeModelArr:(UserCenterModel *)model {
    
    UserInfoCellModel *model1 = [UserInfoCellModel initWith:@"UserAvartCell" title:@"头像" detail:model.avatar isShowArrow:YES pushIdentifier:@"this"];
    
    NSArray *section1 = @[model1];
    
    UserInfoCellModel *model2 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"机构全称" detail:model.realname isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model3 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"机构主页" detail:model.domain isShowArrow:NO pushIdentifier:nil];
    
    UserInfoCellModel *model4 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"机构简介" detail:model.introduction isShowArrow:YES pushIdentifier:@"EditIntroduction"];
    
    self.edictTitle = @"机构简介";
    
    UserInfoCellModel *model5 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"平台负责人" detail:model.contact isShowArrow:YES pushIdentifier:@"EditResponser"];
    
    UserInfoCellModel *model6 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"所属行业" detail:model.industry isShowArrow:NO pushIdentifier:nil];
    
    NSArray *section2 = @[model2,model3,model4,model5,model6];
    
    UserInfoCellModel *model12 = [UserInfoCellModel initWith:@"UserInfoCell" title:@"退出登录" detail:nil isShowArrow:NO pushIdentifier:@"exit"];
    
    NSArray *section4 = @[model12];
    
    return @[section1,section2,section4];
}

#pragma mark – Getter/Setter


@end
