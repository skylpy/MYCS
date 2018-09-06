//
//  ReleaseLiveViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/4/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ReleaseLiveViewController.h"
#import "LiveEditIntroViewController.h"
#import "ComfirmView.h"
#import "DatePickView.h"
#import "NSDate+Util.h"
#import "SelectOfficeController.h"
#import "LiveListModel.h"
#import "NSString+Util.h"
#import "User.h"
#import "UIButton+WebCache.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <AVFoundation/AVFoundation.h>

@interface ReleaseLiveViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (weak, nonatomic) IBOutlet UITextField *unitTextField;

@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

@property (weak, nonatomic) IBOutlet UITextField *officeTextField;

//封面按钮
@property (weak, nonatomic) IBOutlet UIButton *coverButton;

@property (weak, nonatomic) IBOutlet UITextField *oneCodeTextField;

@property (weak, nonatomic) IBOutlet UITextField *twoCodeTextField;

@property (weak, nonatomic) IBOutlet UITextField *threeCodeTextField;

@property (weak, nonatomic) IBOutlet UITextField *fourCodeTextField;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *releaseButtonArr;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic,strong) NSArray * dataSourse;

@property (nonatomic, strong) NSString * codeStr;

@property (nonatomic, assign) BOOL showCodeTextField;

@property (nonatomic ,strong) LiveReleaseParamModel * releaseModel;

@property (nonatomic, strong) LiveDetail * liveDetail;

@property (nonatomic,copy)NSString *selectOfficeId;
@end

@implementation ReleaseLiveViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView removeFromSuperview];
}

- (void)configBackBarItem {
    
//    UIImage* backItemImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    UIImage* backItemHlImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIButton* backButton = [[UIButton alloc] init];
    
    [backButton setTitle:@"关闭" forState:UIControlStateNormal];
    
    [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    
    [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    
    [backButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    
//    [backButton setImage:backItemImage forState:UIControlStateNormal];
//    
//    [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = item;
    
}
-(void)backButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if(self.IsHorizontal)
    {
        [self configBackBarItem];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.releaseModel = [[LiveReleaseParamModel alloc] init];
    self.coverButton.imageView.clipsToBounds = YES;
    self.coverButton.imageView.contentMode   = UIViewContentModeScaleAspectFill;
    
    self.oneCodeTextField.layer.borderColor = HEXRGB(0x999999).CGColor;
    self.oneCodeTextField.layer.borderWidth = 0.5f;
    
    self.twoCodeTextField.layer.borderColor = HEXRGB(0x999999).CGColor;
    self.twoCodeTextField.layer.borderWidth = 0.5f;
    
    self.threeCodeTextField.layer.borderColor = HEXRGB(0x999999).CGColor;
    self.threeCodeTextField.layer.borderWidth = 0.5f;
    
    self.fourCodeTextField.layer.borderColor = HEXRGB(0x999999).CGColor;
    self.fourCodeTextField.layer.borderWidth = 0.5f;
    
    self.commitButton.layer.cornerRadius = 6;
    self.commitButton.clipsToBounds = YES;
    
    self.showCodeTextField = NO;

    self.titleTextField.delegate = self;
    self.nameTextField.delegate = self;
    self.unitTextField.delegate = self;
    
    if (!self.roomId)
    {
        [self chooseSelectButton];
    }else
    {
        [self loadLiveDetail];
    }
}

-(void)chooseSelectButton
{
    self.selectButton = [self.releaseButtonArr firstObject];
    [self releaseButtonAction:self.selectButton];
}
-(void)setRoomId:(NSString *)roomId
{
    _roomId = roomId;
}
-(void)loadLiveDetail
{
    [self showLoadingView:0];
    [LiveListModel requestLiveDetailWithRoomId:self.roomId action:@"detail" Success:^(LiveDetail *model) {
        
        [self dismissLoadingView];
        self.liveDetail = model;
        
    } Failure:^(NSError *error) {
        [self dismissLoadingView];
        [self showError:error];
    }];
}
-(void)setLiveDetail:(LiveDetail *)liveDetail
{
    _liveDetail = liveDetail;
    self.titleTextField.text = liveDetail.title;
    self.nameTextField.text = liveDetail.anchor;
    self.officeTextField.text = liveDetail.cate_name;
    self.unitTextField.text = liveDetail.anchor_intro;
    self.timeTextField.text = liveDetail.live_time;
    self.introLabel.text = liveDetail.detail;
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/0/w/%d/h/%d/format/jpg/q/100",liveDetail.img,160,160]];
    [self.coverButton sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Live_add"]];
    
    if (liveDetail.ext_permission == 3)
    {
        self.codeStr = liveDetail.check_word;
    }
    self.selectButton = self.releaseButtonArr[liveDetail.ext_permission-1];
    [self releaseButtonAction:self.selectButton];
    
    self.releaseModel.title = liveDetail.title;
    self.releaseModel.anchor = liveDetail.anchor;
    self.releaseModel.cateId = liveDetail.cate_id;
    self.releaseModel.anchorIntro = liveDetail.anchor_intro;
    self.releaseModel.liveTime = liveDetail.live_time;
    self.releaseModel.detail = liveDetail.detail;
    self.releaseModel.roomId = liveDetail.pk;
    self.releaseModel.coverId = liveDetail.cover_id;
    self.releaseModel.extPermission = [NSString stringWithFormat:@"%d",liveDetail.ext_permission];
    self.releaseModel.checkWord = liveDetail.check_word;

    [self tapGestAction];
}
#pragma mark - Action
- (IBAction)editAction:(id)sender
{
    [self.textField becomeFirstResponder];
    [self addTagView];
    [self getTextFiledValue:self.codeStr];
}
- (BOOL)validateReleaseModel
{
    if (!self.releaseModel.title)
    {
        [self showErrorMessage:@"请输入直播标题!"];
        return NO;
    }
    else if (!self.releaseModel.anchor)
    {
        [self showErrorMessage:@"请输入主讲人!"];
        return NO;
    }
    else if (!self.releaseModel.cateId)
    {
        [self showErrorMessage:@"请选择对应科室!"];
        return NO;
    }
    else if (!self.releaseModel.anchorIntro)
    {
        [self showErrorMessage:@"请输入所属单位!"];
        return NO;
    }
    else if (!self.releaseModel.liveTime)
    {
        [self showErrorMessage:@"请选择直播时间!"];
        return NO;
    }
    else if (!self.releaseModel.detail)
    {
        [self showErrorMessage:@"请输入直播简介!"];
        return NO;
    }
    else if (!self.releaseModel.coverId)
    {
        [self showErrorMessage:@"请选择直播封面!"];
        return NO;
    }
    
    if (self.releaseModel.extPermission.integerValue == 3)
    {
        if (self.releaseModel.checkWord.length < 4)
        {
            [self showErrorMessage:@"请输入对应验证码!"];
            return NO;
        }
    }
    
    return YES;
}

- (IBAction)commitAction:(UIButton *)sender
{
     if (![self validateReleaseModel]) return;
    sender.userInteractionEnabled = NO;
    
    [self showLoadingHUD];
    [LiveListModel releaseLiveWithRoomId:self.releaseModel.roomId CateId:self.releaseModel.cateId AnchorIntro:self.releaseModel.anchorIntro anchor:self.releaseModel.anchor liveTime:self.releaseModel.liveTime tilte:self.releaseModel.title coverId:self.releaseModel.coverId checkWord:self.releaseModel.checkWord detail:self.releaseModel.detail extPermission:self.releaseModel.extPermission action:@"save" Success:^(SCBModel *model) {
        
        [self dismissLoadingHUD];
        [self showSuccessWithStatusHUD:@"发布成功！"];
        self.commitButton.userInteractionEnabled = YES;
        if (self.releaseButtonBlock)
        {
            self.releaseButtonBlock();
        }
        if(self.IsHorizontal)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } Failure:^(NSError *error) {
        [self dismissLoadingHUD];
        [self showError:error];
        self.commitButton.userInteractionEnabled = YES;
    }];
   
}
- (IBAction)releaseButtonAction:(UIButton *)sender
{
    self.selectButton.selected = NO;
    self.selectButton = sender;
    self.selectButton.selected = YES;

    self.textField.text = nil;
    [self hideCodeAction];
    self.showCodeTextField = NO;
    self.releaseModel.extPermission = nil;
    self.releaseModel.extPermission = [NSString stringWithFormat:@"%d",(int)sender.tag + 1];
    if (sender.tag == 2)
    {
        self.showCodeTextField = YES;
        [self getTextFiledValue:self.codeStr];
    }else
    {
        self.codeStr = nil;
    }
    
    [self.tableView reloadData];
}


- (IBAction)imageSelectAction:(UIButton *)sender
{
    ModelComfirm *model1 = [ModelComfirm comfirmModelWith:@"拍照" titleColor:HEXRGB(0x333333) fontSize:16];

    ModelComfirm *model2 = [ModelComfirm comfirmModelWith:@"从手机相册选择" titleColor:HEXRGB(0x333333) fontSize:16];

    NSArray *sourceArray = @[ model1, model2 ];

    [ComfirmView showInView:self.navigationController.view cancelItemWith:nil dataSource:sourceArray actionBlock:^(ComfirmView *view, NSInteger index) {

        if (0 == index)
        {
            [self takePhotoAction];
        }
        else if (1 == index)
        {
            [self pickImageAction];
        }

    }];
}

#pragma mark - Action
- (void)showCodeAction {
   
    self.dataSourse = [NSArray arrayWithObjects:self.oneCodeTextField,self.twoCodeTextField,self.threeCodeTextField,self.fourCodeTextField, nil];
    
    [self.textField addTarget:self action:@selector(textFieldchange:) forControlEvents:UIControlEventEditingChanged];
    [self.textField becomeFirstResponder];
    [self getTextFiledValue:self.codeStr];
    [self addTagView];
}

-(void)hideCodeAction
{
    self.oneCodeTextField.text = nil;
    self.twoCodeTextField.text = nil;
    self.threeCodeTextField.text = nil;
    self.fourCodeTextField.text = nil;
}

#pragma mark 文本框内容改变
- (void)textFieldchange:(UITextField *)textField
{
    NSString *password = textField.text;
    
    self.codeStr = nil;
    
    if (password.length >= 5)
    {
        password = [password substringWithRange:NSMakeRange(0, 4)];
        self.codeStr = password;
        self.releaseModel.checkWord = self.codeStr;
    }
    else
    {
        self.codeStr = password;
        self.releaseModel.checkWord = self.codeStr;
    }
    
    if (password.length == 4)
    {
        [textField resignFirstResponder];//隐藏键盘
        [self removeTagView];
    }
    
    [self hideCodeAction];
    
    [self getTextFiledValue:password];
    
}
-(void)getTextFiledValue:(NSString *)password
{
    for (int i = 0; i < password.length; i ++)
    {
        UITextField * padText = self.dataSourse[i];
        padText.text = [password substringWithRange:NSMakeRange(i, 1)];
    }
    self.textField.text = self.codeStr;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSString *text = [textField.text trimmingWhitespaceAndNewline];
    //任务标题
    if ([textField isEqual:self.titleTextField])
    {
        self.releaseModel.title = text;
    }
    //主播
    else if ([textField isEqual:self.nameTextField])
    {
        self.releaseModel.anchor = text;
    }
    //所属单位
    else if ([textField isEqual:self.unitTextField])
    {
        self.releaseModel.anchorIntro = text;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 7)
    {
        if (self.showCodeTextField)
        {
            
            [self showCodeAction];
            
            return 2;
        }
    }
    return 1;
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 6)
    {
        return 105;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0)return 10;
    
    if (section == 2 || section == 3 || section == 5) return 0.5;
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        SelectOfficeController *destVC = [[UIStoryboard storyboardWithName:@"Live" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectOfficeController"];
        destVC.title = @"选择科室";
        destVC.selectID = self.selectOfficeId;
        
        destVC.selectBackBlock = ^(NSString *selectName,NSString * selectIdStr)
        {
            self.releaseModel.cateId = selectIdStr;
            self.officeTextField.text = selectName;
            self.selectOfficeId = selectIdStr;
            
        };
        
        [self.navigationController pushViewController:destVC animated:YES];
    }
    else if (indexPath.section == 4)
    {
        [DatePickView showWith:UIDatePickerModeDateAndTime selectComplete:^(NSDate *selectDate) {
            NSString *dateString       = [NSDate dateToString:selectDate format:@"yyyy-MM-dd  HH:mm"];
            self.timeTextField.text = dateString;
            
            self.releaseModel.liveTime = [NSString stringWithFormat:@"%ld", (long)[selectDate timeIntervalSince1970]];
        }];
    }else if (indexPath.section == 5)
    {
        LiveEditIntroViewController  *liveEditIntroView = [[UIStoryboard storyboardWithName:@"Live" bundle:nil] instantiateViewControllerWithIdentifier:@"LiveEditIntroViewController"];
        liveEditIntroView.content = self.introLabel.text;
        
        liveEditIntroView.saveBlock = ^(NSString *str)
        {
            self.introLabel.text = str;
            self.releaseModel.detail = str;
        };
        
        [self.navigationController pushViewController:liveEditIntroView animated:YES];
    }
    
    
}
- (BOOL)hasPermissionOfCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus != AVAuthorizationStatusAuthorized)
    {
        [self showErrorMessage:@"请设置相机权限：设置->名医传世->相机"];
        return NO;
    }
    return YES;
}
#pragma mark - 拍照和从手机相册中选择
///拍照
- (void)takePhotoAction
{
    if (![self hasPermissionOfCamera]) {
        return;
    }
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    NSString *imageStr = [imageData base64Encoding];
    
#pragma clang diagnostic pop
    
    [self showLoadingView:0];
    LoadingView *loadingView = (LoadingView *)[self.view viewWithTag:999999];
    loadingView.titleL.text = @"上存中...";
    loadingView.titleL.textColor = HEXRGB(0x47c1a8);
    [User uploadIdentityCardAndMaterial:imageStr success:^(NSString *tmpId) {
        
        self.releaseModel.coverId = tmpId;
        [self.coverButton setImage:image forState:UIControlStateNormal];
        [self dismissLoadingView];
        [self showSuccessWithStatusHUD:@"封面上传成功"];
        
    } failure:^(NSError *error) {
        
          [self dismissLoadingView];
        [self showErrorMessageHUD:@"封面上传失败"];
        [self.coverButton setImage:[UIImage imageNamed:@"register_add"] forState:UIControlStateNormal];
        
    }];
}
-(void)addTagView
{
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 500)];
    tapView.backgroundColor = [UIColor clearColor];
    tapView.tag = 898989;
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestAction)];
    
    tapView.userInteractionEnabled = YES;
    
    [tapView addGestureRecognizer:tapGest];
    
    [self.view addSubview:tapView];
}
-(void)removeTagView
{
    UIView *tapView = [self.view viewWithTag:898989];
    [tapView removeFromSuperview];
}
-(void)tapGestAction
{
    [self.textField resignFirstResponder];
    [self removeTagView];
}
-(void)dealloc
{
    [self hideCodeAction];
}
@end

@implementation LiveReleaseParamModel


@end




