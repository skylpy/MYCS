//
//  OrganizeRegisterViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/3/3.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "OrganizeRegisterViewController.h"
#import "UIImage+Color.h"
#import "SelectPickView.h"
#import "NSString+Util.h"
#import "CheckCodeView.h"
#import "UserCenterImagePickerView.h"

@interface OrganizeRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *entOrHosTextView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailAddressTextView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *identityCardTextField;

@property (nonatomic,strong) UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardTmpBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardOtherTmpBtn;
@property (weak, nonatomic) IBOutlet UIButton *materialTmpBtn;

@property (nonatomic,assign) CGFloat heightForEntOrHos;
@property (nonatomic,assign) CGFloat heightForDetailAddr;

//用来判断TextView是否换行
@property (nonatomic,assign) CGFloat entOrHosSizeHeigh;
@property (nonatomic,assign) CGFloat detailAddrSizeHeigh;

//身份证正面
@property (nonatomic,copy) NSString *idCardTmpId;
//身份证反面
@property (nonatomic,copy) NSString *idCardOtherTmpId;
//相关资料
@property (nonatomic,copy) NSString *materialTmpId;

@property (weak, nonatomic) IBOutlet UILabel *entAndOrgPlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressPlaceHolder;

@end

@implementation OrganizeRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    
}

- (void)buildUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.tableFooterView = [UIView new];
    self.sendCodeButton.layer.cornerRadius = 2;
    self.sendCodeButton.layer.masksToBounds = YES;
    
    [self.sendCodeButton setBackgroundImage:[UIImage imageWithColor:HEXRGB(0x47c1a8)] forState:UIControlStateNormal];
    [self.sendCodeButton setBackgroundImage:[UIImage imageWithColor:HEXRGB(0x999999)] forState:UIControlStateDisabled];
    
    self.entOrHosTextView.contentInset = UIEdgeInsetsMake(9, 0, 0, 0);
    self.detailAddressTextView.contentInset = UIEdgeInsetsMake(9, 0, 0, 0);
}

#pragma mark - Action
- (void)commitAction:(UIButton *)button {
    
    if (![self validateEntOrOrgName]) return;
    if (![self validateCity]) return;
    if (![self validateDetailAddress]) return;
    if (![self validateEmail]) return;
    if (![self validateResponserName]) return;
    if (![self validatePhoneNumber]) return;
    if (![self valideteCode]) return;
    if (![self validateIdentityCard]) return;
    
    if (![self validateSelectedImage]) return;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"regType"] = @(2);
    param[@"realname"] = self.entOrHosTextView.text;
    param[@"area"] = self.addressTextField.text;
    param[@"address"] = self.detailAddressTextView.text;
    param[@"email"] = self.emailTextField.text;
    param[@"contacts"] = self.nameTextField.text;
    param[@"phone"] = self.phoneTextField.text;
    param[@"phoneCode"] = self.codeTextField.text;
    param[@"idCard"] = self.identityCardTextField.text;
    
    //上传身份证正反面
    param[@"idCardPic"] = [NSString stringWithFormat:@"%@,%@",self.idCardTmpId,self.idCardOtherTmpId];
    param[@"zjPic"] = self.materialTmpId;
    
    [self showLoadingWithStatusHUD:@"正在申请"];
    
    [User registWithUserInformation:param success:^(User *user) {
        
        [self showSuccessWithStatusHUD:@"申请成功"];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        [self dismissLoadingHUD];
        
    }];
    
}

- (void)uploadPhoto {
    
    
}

- (IBAction)sendCodeAction:(UIButton *)sender {
    
    if (![self validatePhoneNumber]) return;
    
    [self.view endEditing:YES];
    
    ///弹出验证码
    [CheckCodeView showInView:self WithPhone:self.phoneTextField.text complete:^(CheckCodeView *view, NSString *code) {
        
        if (!code||code.length == 0) return;
        
        [UserCenterModel sendCodeInUserCenterWithPhone:self.phoneTextField.text validCode:code action:@"send" success:^{
            
            [self cutdownWith:sender];
            
        } failure:^(NSError *error) {
            
            [self showError:error];
            
        }];
        
    }];
    
}

- (void)cutdownWith:(UIButton *)button {
    
    button.enabled = NO;
    
    __block int timeout=89; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                button.enabled = YES;
            });
        }else{
            //			int minutes = timeout / 60;
            int seconds = timeout % 90;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:[NSString stringWithFormat:@"剩余%@秒",strTime] forState:UIControlStateDisabled];
                button.enabled = NO;
                
            });
            
            timeout--;
            
        }
    });
    
    dispatch_resume(_timer);
}

//选择所在城市
- (void)selectAddressAction {
    
    [SelectPickView showWithType:SelectPickViewTypeArea complete:^(SelectPickView *view, NSString *selectString, NSString *provId, NSString *cityId, NSString *areaId, NSString *itemId) {
        
        self.addressTextField.text = selectString;
        
    }];
    
}

- (IBAction)selectImageAction:(UIButton *)sender {
    
    self.selectBtn = sender;
    
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
        self.tabBarController.tabBar.hidden = NO;
        
    }];
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    [self.selectBtn setImage:image forState:UIControlStateNormal];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    NSString *imageStr = [imageData base64Encoding];
    
#pragma clang diagnostic pop
    
    [self showLoadingView:0];
    LoadingView *loadingView = (LoadingView *)[self.view viewWithTag:999999];
    loadingView.titleL.text = @"上存中...";
    loadingView.titleL.textColor = HEXRGB(0x47c1a8);
    
    //身份证正面
    if (self.selectBtn.tag==1)
    {
        [self.cardTmpBtn setImage:image forState:UIControlStateNormal];
        
        [User uploadIdentityCardAndMaterial:imageStr success:^(NSString *tmpId) {
            [self dismissLoadingView];
            self.idCardTmpId = tmpId;
            [self showSuccessWithStatusHUD:@"身份证照片一上传成功"];
            
        } failure:^(NSError *error) {
            [self dismissLoadingView];
            [self showErrorMessageHUD:@"身份证照片一上传失败"];
            [self.cardTmpBtn setImage:[UIImage imageNamed:@"register_add"] forState:UIControlStateNormal];
            self.idCardTmpId = nil;
            
        }];
    }//身份证反面
    else if (self.selectBtn.tag==2)
    {
        [self.cardOtherTmpBtn setImage:image forState:UIControlStateNormal];
        
        [User uploadIdentityCardAndMaterial:imageStr success:^(NSString *tmpId) {
            [self dismissLoadingView];
            self.idCardOtherTmpId = tmpId;
            [self showSuccessWithStatusHUD:@"身份证照片二上传成功"];
            
        } failure:^(NSError *error) {
            [self dismissLoadingView];
            [self showErrorMessageHUD:@"身份证照片二上传失败"];
            [self.cardOtherTmpBtn setImage:[UIImage imageNamed:@"register_add"] forState:UIControlStateNormal];
            self.idCardOtherTmpId = nil;

            
        }];
    }//相关资料
    else if (self.selectBtn.tag==3)
    {
        [self.materialTmpBtn setImage:image forState:UIControlStateNormal];
        
        [User uploadIdentityCardAndMaterial:imageStr success:^(NSString *tmpId) {
            
            self.materialTmpId = tmpId;
            [self dismissLoadingView];
            [self showSuccessWithStatusHUD:@"相关证件照上传成功"];

        } failure:^(NSError *error) {
            [self dismissLoadingView];
            [self showErrorMessageHUD:@"相关证件照上传失败"];
            [self.materialTmpBtn setImage:[UIImage imageNamed:@"register_add"] forState:UIControlStateNormal];
            self.materialTmpId = nil;
        }];
    }
}

#pragma mark - Private
///校验手机号码格式是否正确
- (BOOL)validatePhoneNumber {
    
    NSString *phone = [self.phoneTextField.text trimmingWhitespaceAndNewline];
    self.phoneTextField.text = phone;
    
    if (!phone||phone.length==0)
    {
        [self showErrorMessage:@"请输入手机号码!"];
        return NO;
    }
    
    if (![NSString matchRegularExpress:@"1[3578]\\d{9}" inString:phone]) {
        
        [self showErrorMessage:@"手机号码格式不正确!"];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)validateEntOrOrgName {
    
    NSString *entOrHos = self.entOrHosTextView.text;
    entOrHos = [entOrHos trimmingWhitespaceAndNewline];
    self.entOrHosTextView.text = entOrHos;
    
    if (!entOrHos||entOrHos.length==0)
    {
        [self showErrorMessage:@"请输入医疗机构全称!"];
        return NO;
    }
    
    if (entOrHos.length>40)
    {
        [self showErrorMessage:@"医疗机构全称在40个字符内!"];
        return NO;
    }
    
    return YES;
}

- (BOOL)validateDetailAddress {
    
    NSString *detailAddr = self.detailAddressTextView.text;
    detailAddr = [detailAddr trimmingWhitespaceAndNewline];
    self.detailAddressTextView.text = detailAddr;
    
    if (!detailAddr||detailAddr.length==0)
    {
        [self showErrorMessage:@"请输入详细地址!"];
        return NO;
    }
    
    if (detailAddr.length>50)
    {
        [self showErrorMessage:@"详细地址在50个字符内!"];
        return NO;
    }
    
    return YES;

}

- (BOOL)validateResponserName {
    
    NSString *responserName = self.nameTextField.text;
    responserName = [responserName trimmingWhitespaceAndNewline];
    self.nameTextField.text = responserName;
    
    if (!responserName||responserName.length==0)
    {
        [self showErrorMessage:@"请输入负责人名称!"];
        return NO;
    }

    if (responserName.length>20)
    {
        [self showErrorMessage:@"负责人名称在20个字符内!"];
        return NO;
    }
    
    return YES;
}

//所在城市
- (BOOL)validateCity {
    
    if (self.addressTextField.text.length==0||!self.addressTextField.text)
    {
        [self showErrorMessage:@"请选择所在地址!"];
        return NO;
    }
    
    return YES;
}

- (BOOL)valideteCode {
    
    NSString *code = [self.codeTextField.text trimmingWhitespaceAndNewline];
    self.codeTextField.text = code;
    
    if (!code||code.length == 0)
    {
        [self showErrorMessage:@"请输入验证码"];
        return NO;
    }
    
    return YES;
    
}

///校验邮箱格式
- (BOOL)validateEmail {
    
    NSString *email = [self.emailTextField.text trimmingWhitespaceAndNewline];
    self.emailTextField.text = email;
    
    if (!email||email.length==0)
    {
        [self showErrorMessage:@"请输入邮箱!"];
        return NO;
    }
    
    if (![NSString matchRegularExpress:@"[A-Za-z_0-9]+@\\w+.\\w{2,3}" inString:email]) {
        
        [self showErrorMessage:@"邮箱格式不正确!"];
        
        return NO;
    }
    return YES;
}

//校验身份证
- (BOOL)validateIdentityCard {
    
    NSString *identityCard = self.identityCardTextField.text;
    identityCard = [identityCard trimmingWhitespaceAndNewline];
    self.identityCardTextField.text = identityCard;
    
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        [self showErrorMessage:@"请输入身份证号码!"];
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    if ([identityCardPredicate evaluateWithObject:identityCard])
    {
        
        return YES;
    }
    else
    {
        
        [self showErrorMessage:@"身份证号码格式不正确!"];
        return NO;
    }
}

- (BOOL)validateSelectedImage {
    
    if (!self.idCardTmpId)
    {
        [self showErrorMessage:@"请选择身份证正反面!"];
        return NO;
    }
    else if (!self.idCardOtherTmpId)
    {
        [self showErrorMessage:@"请选择身份证正反面!"];
        return NO;
    }
    else if (!self.materialTmpId)
    {
        [self showErrorMessage:@"请选择相关证件照!"];
        return NO;
    }
    
    return YES;
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //机构全称
    if (indexPath.section==0&&indexPath.row==0)
    {
        if (self.heightForEntOrHos>=50)
        {
            return self.heightForEntOrHos;
        }
    }//详细地址
    else if (indexPath.section==0&&indexPath.row==2)
    {
        if (self.heightForDetailAddr>50)
        {
            return self.heightForDetailAddr;
        }
    }
    
    BOOL photoRow = (indexPath.section==1&&indexPath.row==1)||(indexPath.section==2&&indexPath.row==0);
    
    if (photoRow) return 105;
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section<2?0.5:140;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section<2) return nil;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 140)];
    
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //设置属性
    [button setTitle:@"提交" forState:UIControlStateNormal];
    button.backgroundColor = HEXRGB(0x47c1a8);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    //设置frame
    button.frame = CGRectMake(0, 0, self.view.width-20, 35);
    button.center = footView.center;
    
    //设置圆角
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    
    [footView addSubview:button];
    
    [button addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return footView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        //所在地址
        if (indexPath.row == 1)
        {
            [self.view endEditing:YES];
            [self selectAddressAction];
        }
    }
}

#pragma mark - TextField
- (void)textViewDidChange:(UITextView *)textView {
    
    [self hideOrShowPlaceHolder:textView];
    
    CGSize size = textView.contentSize;
    CGFloat topOffSet = size.height>33?0:9;

    if ([textView isEqual:self.entOrHosTextView])
    {
        self.entOrHosTextView.contentInset = UIEdgeInsetsMake(topOffSet, 0, 0, 0);
        
        if (self.entOrHosSizeHeigh != size.height)
        {
            self.heightForEntOrHos = size.height;
            [self.tableView reloadData];
            [self.entOrHosTextView becomeFirstResponder];
        }
        
        self.entOrHosSizeHeigh = size.height;
    }
    else if ([textView isEqual:self.detailAddressTextView])
    {
        self.detailAddressTextView.contentInset = UIEdgeInsetsMake(topOffSet, 0, 0, 0);
        
        if (self.detailAddrSizeHeigh != size.height)
        {
            self.heightForDetailAddr = size.height;
            [self.tableView reloadData];
            [self.detailAddressTextView becomeFirstResponder];
        }
        
        self.detailAddrSizeHeigh = size.height;
    }
    
}

- (void)hideOrShowPlaceHolder:(UITextView *)textView {
    
    if (textView.text.length==0)
    {
        if ([textView isEqual:self.entOrHosTextView])
        {
            self.entAndOrgPlaceHolder.hidden = NO;
        }
        else if ([textView isEqual:self.detailAddressTextView])
        {
            self.detailAddressPlaceHolder.hidden = NO;
        }
    }
    else
    {
        if ([textView isEqual:self.entOrHosTextView])
        {
            self.entAndOrgPlaceHolder.hidden = YES;
        }
        else if ([textView isEqual:self.detailAddressTextView])
        {
            self.detailAddressPlaceHolder.hidden = YES;
        }
        
    }
}

#pragma mark - KVO

#pragma mark - Getter&Setter
- (void)setSelectBtn:(UIButton *)selectBtn {
    _selectBtn = selectBtn;
    
    selectBtn.imageView.contentMode = UIViewContentModeScaleToFill;
}

@end
