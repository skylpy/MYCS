//
//  MailBoxEditorViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MailBoxEditorViewController.h"

#import "sheetView.h"
#import "MessageEidtorViewCellFrame.h"

#import "BDDynamicTreeNode.h"

#import "ServiceModel.h"
#import "StaffModel.h"
#import "MessageModel.h"
#import "ReceiverModel.h"
#import "messageSendParam.h"

#import "MJExtension.h"
#import "APIClient.h"
#import "MessageNameButton.h"
#import "BtnFrameModel.h"
#import "MessageSend.h"

#import "ChoosePersonsViewController.h"
#import "ChooseDeptsViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface MailBoxEditorViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameViewHeight;

@property (strong, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonBottom;

@property (strong, nonatomic) IBOutlet UITextField *receiverField;

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;

@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@property (strong, nonatomic) IBOutlet UILabel *textViewPlaceHoder;

@property (weak, nonatomic) IBOutlet UIButton *hiddenButton;//隐藏按钮

@property (assign,nonatomic) BOOL isHidden;//隐藏按钮是否隐藏

@property (assign,nonatomic) CGFloat hiddenCellHeight;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UITextView *contentText;

@property (strong, nonatomic) IBOutlet UIView *nameTextView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UIView *titleTextView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollVIew;

@property (strong,nonatomic) MessageEidtorViewCellFrame *cellFrame;

@property (copy, nonatomic) NSString *userIDStr;//收件人UID
@property (copy, nonatomic) NSString *departmentIDIdStr;  //部门ID

@property (strong, nonatomic) NSArray *sheetTitleArray;  //弹出选择类型标题

@property (nonatomic,strong) NSMutableArray *selectedDep; //部门数组
@property (strong,nonatomic) NSMutableArray *selectStaff;//会员或员工数组
@property (strong,nonatomic) NSMutableArray *sendMem;//选中的会员数组
@property (strong,nonatomic) NSMutableArray * sendStaff;//选中的员工数组

@property (strong,nonatomic) MessageNameButton *selectNameBtn;

@end

@implementation MailBoxEditorViewController

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


-(NSMutableArray *)answerList
{
    if (_answerList == nil)
    {
        _answerList = [NSMutableArray array];
    }
    return _answerList;
}

-(NSMutableArray *)peopleList
{
    if (_peopleList == nil)
    {
        _peopleList = [NSMutableArray array];
    }
    return _peopleList;
}

-(NSMutableArray *)selectStaff
{
    if (_selectStaff == nil)
    {
        _selectStaff = [NSMutableArray array];
    }
    return _selectStaff;
}

-(NSMutableArray *)selectedDep
{
    if (_selectedDep == nil)
    {
        _selectedDep = [NSMutableArray array];
    }
    return _selectedDep;
}

-(NSMutableArray *)sendMem
{
    if (_sendMem == nil)
    {
        _sendMem = [NSMutableArray array];
    }
    return _sendMem;
    
}
-(NSMutableArray *)sendStaff
{
    if (_sendStaff == nil)
    {
        _sendStaff = [NSMutableArray array];
    }
    return _sendStaff;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkAnswerFirstTime];
    self.fd_prefersNavigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    if (self.sendType == 0)
        self.title = @"发消息";
    else if (self.sendType == 1)
        self.title = @"回复消息";
    else if (self.sendType == 2)
        self.title = @"再发一封";
    else if (self.sendType == 3)
        self.title = @"转发消息";
    else if (self.sendType == 4)
        self.title = @"任务消息提醒";
    
    if ([AppManager sharedManager].user.userType == UserType_organization && (self.sendType == 0 || self.sendType == 3))
    {
        self.sheetTitleArray = @[ @"按会员对象选择", @"按服务对象选择"];
        self.receiverField.placeholder = @"请选择";
        
    }else if (([AppManager sharedManager].user.userType == UserType_company ||([AppManager sharedManager].user.userType == UserType_employee && [AppManager sharedManager].user.isAdmin.intValue == 1)) && (self.sendType == 0 || self.sendType == 3))
    {
        self.sheetTitleArray = @[@"选择收件部门", @"选择收件人员"];
        self.receiverField.placeholder = @"请选择";
        
    }else
    {
        self.addButton.hidden = YES;
        if ((self.sendType > 0 &&self.sendType<3) || self.sendType == 4)
        {
            self.receiverField.enabled = NO;
        }else
        {
            self.receiverField.enabled = YES;
            self.receiverField.placeholder = @"请输入邮箱/手机号码";
        }
        
        self.sheetTitleArray = @[];
        
    }
    
    if (self.sendType == 3)
    {
        self.contentTextView.text = self.content;
        self.textViewPlaceHoder.hidden = YES;
    }
    
    if (self.peopleList.count>0)
    {
        self.receiverField.placeholder = @"";
    }
    
    self.titleTextField.delegate = self;
    self.contentTextView.delegate = self;
    
    if (self.IsHorizontal)
    {
        self.titleTextField.text = self.titleContent;
        self.contentTextView.text = self.content;
        self.textViewPlaceHoder.hidden = YES;
    }
}

#pragma mark -- 检查回复或者再发一封的时候收件人资料显示
-(void)checkAnswerFirstTime
{
    if (self.answerList.count == 0)
    {
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    [self.selectStaff addObjectsFromArray:self.answerList];
    
    for (ReceiverModel * model in self.answerList)
    {
        [arr addObject:model.userName];
    }
    
    UILabel * receiverL = ({
     
        UILabel * receiverL = [UILabel new];
        
        receiverL.frame = CGRectMake(76, 13, ScreenW - 76 - 15, 16);
        
        receiverL.numberOfLines = 0;
        
        receiverL.font = [UIFont systemFontOfSize:15];
        
        receiverL.textColor = HEXRGB(0xAAAAAA);
        
        receiverL.text = [arr componentsJoinedByString:@","];
        
        [receiverL sizeToFit];
        
        receiverL.height = receiverL.height;
        
        receiverL;
    });
    
    [self.nameTextView addSubview:receiverL];
    
    self.nameViewHeight.constant = receiverL.height + 25;
    
    if (self.nameViewHeight.constant < 51)
    {
        self.nameViewHeight.constant = 51;
        
    }
    
}

#pragma mark -- back Action
- (IBAction)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark -- 影藏按钮 Action
- (IBAction)hiddenAction:(UIButton *)sender
{
    self.isHidden = !self.isHidden;
    
    if (self.isHidden == YES)
    {
        [self.hiddenButton setTitle:@"" forState:UIControlStateNormal];
        [self.hiddenButton setImage:[UIImage imageNamed:@"unfold"] forState:UIControlStateNormal];
    }else
    {
        [self.hiddenButton setTitle:@"隐藏" forState:UIControlStateNormal];
        [self.hiddenButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    [self makeButtonUsingPeopleList];
    
}
#pragma mark -- 添加收件人 Action
- (IBAction)AddReceiversAction:(UIButton *)sender
{
    
    sheetView * sheet = [sheetView getSheetView];

    [sheet.firstBtn setTitle:self.sheetTitleArray[0] forState:UIControlStateNormal];
    [sheet.secondBtn setTitle:self.sheetTitleArray[1] forState:UIControlStateNormal];
    
    [sheet showView:self andY:52 SheetBlock:^(sheetView *sheet, NSInteger buttonIndex) {
        
        [self selectReceiversWithIndex:buttonIndex];
        
    }];
}

-(void)selectReceiversWithIndex:(NSInteger)index{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mailbox" bundle:nil];
    
    if ([AppManager sharedManager].user.userType == UserType_organization && self.sendType == 0)
    {
        switch (index)
        {
            case 0:
            {
                ChoosePersonsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChoosePersonsViewController"];
                
                controller.isMember = YES;
                controller.selectMem = self.sendMem;
                controller.title = @"选择会员";
                
                [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
                
                __weak typeof(self)VC = self;
                controller.sureBtnBlock = ^(NSArray *results,int type) {
                    
                    [VC dealWithBackWithResults:results type:type];
                };
                
            }
                break;
            case 1:
            {
                ChooseDeptsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChooseDeptsViewController"];
                
                controller.isMember = YES;
                controller.selectDep = self.selectedDep;
                controller.title = @"选择服务";
                
                [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
                
                __weak typeof(self)VC = self;
                controller.sureBtnBlock = ^(NSArray *results,int type) {
                    
                    [VC dealWithBackWithResults:results type:type];
                };
                
            }
                break;
            default:
                break;
                
        }
    }else
    {
        switch (index)
        {
            case 0:
            {
                ChooseDeptsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChooseDeptsViewController"];
                
                controller.selectDep = self.selectedDep;
                controller.title = @"选择部门";
                
                [self.navigationController pushViewController:controller animated:YES];
                
                __weak typeof(self)VC = self;
                controller.sureBtnBlock = ^(NSArray *results,int type) {
                    
                    [VC dealWithBackWithResults:results type:type];
                };
            }
                break;
            case 1:
            {
                ChoosePersonsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChoosePersonsViewController"];
                
                controller.selectStaff = self.sendStaff;
                controller.title = @"选择员工";
                
                [self.navigationController pushViewController:controller animated:YES];
                
                __weak typeof(self)VC = self;
                controller.sureBtnBlock = ^(NSArray *results,int type) {
                    
                    [VC dealWithBackWithResults:results type:type];
                };
            }
                break;
            default:
                break;
        }
    }
    
    
}
-(void)dealWithBackWithResults:(NSArray *)results type:(int)type
{
    
    [self.peopleList removeAllObjects];
    
    if (type == 0)
    {//服务或者部门
        [self.selectedDep removeAllObjects];
        for (BDDynamicTreeNode *node in results)
        {
            ReceiverModel *receiver = [[ReceiverModel alloc] init];
            [receiver userName:node.name userID:node.nodeId];
            
            [self.selectedDep addObject:receiver];
        }
    }else if (type == 1)
    {//员工
        [self.selectStaff removeAllObjects];
        [self.sendStaff removeAllObjects];
        
        for (StaffModel *staffModel in results)
        {
            ReceiverModel *receiver = [[ReceiverModel alloc] init];
            
            [receiver userName:staffModel.username userID:staffModel.uid];
            receiver.type = type;
            
            [self.sendStaff addObject:staffModel];
            [self.selectStaff addObject:receiver];
        }
    }else if (type == 2)
    {//会员
        [self.selectStaff removeAllObjects];
        [self.sendMem removeAllObjects];
        
        for (Mem *mem in results)
        {
            ReceiverModel *receiver = [[ReceiverModel alloc] init];
            
            [receiver userName:mem.name userID:mem.uid];
            receiver.type = type;
            
            [self.sendMem addObject:mem];
            [self.selectStaff addObject:receiver];
        }
    }
    
    if (self.selectedDep.count != 0 || self.selectStaff.count != 0)
    {
        self.receiverField.placeholder = @"";
    }else
    {
        self.receiverField.placeholder = @"请选择";
    }
    
    [self.peopleList addObjectsFromArray:self.selectedDep];
    [self.peopleList addObjectsFromArray:self.selectStaff];
    
    [self makeButtonUsingPeopleList];
}
#pragma mark -- 以按钮显示收件人姓名
-(void)makeButtonUsingPeopleList
{
    //移除以前的按钮
    for (UIView * view in self.nameTextView.subviews)
    {
        if ([view isKindOfClass:[MessageNameButton class]])
        {
            [view removeFromSuperview];
            
        }
    }
    
    //设置按钮位置
    if (self.peopleList.count > 0)
    {
        MessageEidtorViewCellFrame * cellFrame = [[MessageEidtorViewCellFrame alloc]init];
        
        cellFrame.btnBeginX = self.nameLabel.width+self.nameLabel.frame.origin.x;
        cellFrame.btnEndX = self.addButton.frame.origin.x;
        cellFrame.height = self.titleTextField.height;
        cellFrame.peopleList = self.peopleList;
        self.cellFrame = cellFrame;
        
        NSUInteger index = 0;
        for (BtnFrameModel * model in cellFrame.modelList)
        {
            
            if (!(self.isHidden == YES && model.inRow>2))
            {
                MessageNameButton * btn  = [MessageNameButton buttonWithType:UIButtonTypeCustom];
                
                [btn setTitle:model.userName forState:UIControlStateNormal];
                btn.frame = model.btnModelFrame;
                btn.type = model.type;
                btn.inRow = model.inRow;
                [btn addTarget:self action:@selector(nameBtnClick:)forControlEvents:UIControlEventTouchUpInside];
                btn.ID = model.userID;
                [self.nameTextView addSubview:btn];
                btn.index = index;
                btn.titleLabel.textColor = HEXRGB(0x5381C3);
                
                self.addButton.center = CGPointMake(self.addButton.center.x, btn.center.y);
            }
            
            index++;
            
        }
        
        [self setNameLabelViewHeight];
    }
}
#pragma mark -- 设置收件人View高度
-(void) setNameLabelViewHeight
{
    if (self.cellFrame.cellHeight >51)
    {
        if (self.cellFrame .rowNum >2)
        {
            self.hiddenButton.hidden = NO;
            
            if (self.isHidden)
            {
                self.nameViewHeight.constant = self.cellFrame .hiddenCellHeight;
                
            }else
            {
                self.nameViewHeight.constant = self.cellFrame .cellHeight;
            }
            
            self.addButtonBottom.constant = 33;
            
        }else
        {
            self.hiddenButton.hidden = YES;
            self.addButtonBottom.constant = 3;
            self.nameViewHeight.constant = self.cellFrame .cellHeight;
        }
        
    }else
    {
        self.nameViewHeight.constant = 51;
    }
    
    self.titleTextView.y = CGRectGetMaxY(self.nameTextView.frame);
    
    self.contentView.y = CGRectGetMaxY(self.titleTextView.frame);
    
    self.scrollVIew.contentSize = CGSizeMake(0, self.contentView.y+self.contentView.height+10);
}

#pragma mark -- 收件人按钮 Action
-(void)nameBtnClick:(MessageNameButton *)btn
{
    self.selectNameBtn = btn;
    UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定移除该联系人？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self removeNameBtn:self.selectNameBtn];
    }
}
#pragma mark -- 移除收件 Action
-(void)removeNameBtn:(MessageNameButton *)btn
{
    [self.peopleList removeObjectAtIndex:btn.index];
    [btn removeFromSuperview];
    
    if (btn.type == 0)
    {
        NSArray * arr = [NSArray arrayWithArray:self.selectedDep];
        
        for (ReceiverModel * model in arr)
        {
            if ([btn.ID isEqualToString:model.userID])
            {
                [self.selectedDep removeObject:model];
            }
        }
    } if (btn.type == 1)
    {
        NSArray * arr = [NSArray arrayWithArray:self.selectStaff];
        for (ReceiverModel * model in arr)
        {
            if ([btn.ID isEqualToString:model.userID])
            {
                [self.selectStaff removeObject:model];
            }
            
        }
        NSArray * arr1 = [NSArray arrayWithArray:self.sendStaff];
        for (StaffModel * staff in arr1)
        {
            if ([btn.ID isEqualToString:staff.uid])
            {
                [self.sendStaff removeObject:staff];
            }
        }
    }else if (btn.type == 2)
    {
        NSArray * arr = [NSArray arrayWithArray:self.selectStaff];
        for (ReceiverModel * model in arr)
        {
            if ([btn.ID isEqualToString:model.userID])
            {
                [self.selectStaff removeObject:model];
            }
            
            NSArray * arr1 = [NSArray arrayWithArray:self.sendMem];
            for (Mem * mem in arr1)
            {
                if ([btn.ID isEqualToString:mem.uid])
                {
                    [self.sendMem removeObject:mem];
                }
            }
        }
    }
    [self makeButtonUsingPeopleList];
}

#pragma mark -- 发送 Action
- (IBAction)sendMessageAction:(UIBarButtonItem *)sender {
    
    sender.enabled = NO;
    self.isHidden = NO;
    NSString *receiverStr = [self.receiverField.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *titleStr = [self.titleTextField.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *contentTextStr = [self.contentTextView.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (receiverStr.length == 0 && self.selectStaff.count == 0 && self.selectedDep.count == 0)
    {
        [self showErrorMessage:@"请选择收件人"];
        sender.enabled = YES;
        
        return;
        
    }else if (titleStr.length == 0)
    {
        [self showErrorMessage:@"请输入标题"];
        sender.enabled = YES;
        
        return;
    }else if(titleStr.length<2 ||titleStr.length>40)
    {
        [self showErrorMessage:@"标题长度介于2-40之间"];
        sender.enabled = YES;
        
        return;
    }else if (contentTextStr.length == 0)
    {
        [self showErrorMessage:@"请输入内容"];
        sender.enabled = YES;
        
        return;
        
    }else if(contentTextStr.length<5||contentTextStr.length>3000)
    {
        [self showErrorMessage:@"内容长度介于5-3000之间"];
        sender.enabled = YES;
        
        return;
    }
    
    [self showLoadingHUD];
    
    //发送前设置加载参数
    self.userIDStr = @"";
    self.departmentIDIdStr = @"";
    
    NSMutableArray *depArray = [NSMutableArray array];
    NSMutableArray *userArray = [NSMutableArray array];
    
    if (self.selectedDep.count > 0)
    {
        for (ReceiverModel *model in self.selectedDep)
        {
            [depArray addObject:model.userID];
        }
        
        self.departmentIDIdStr = [depArray componentsJoinedByString:@","];
    }
    
    if (self.selectStaff.count>0)
    {
        for (ReceiverModel * model in self.selectStaff) {
            
            [userArray addObject:model.userID];
        }
        
        self.userIDStr = [userArray componentsJoinedByString:@","];
        
        receiverStr = self.userIDStr;
    }
    
    //任务消息提醒
    if (self.sendType == 4)
    {
        //发送邮件提醒
        [self showLoadingWithStatusHUD:@"正在发送"];
        
        NSString *contStr = [NSString stringWithFormat:@"%@  截止时间：%@",contentTextStr,self.endTime];
        
        [MessageSend messageSendWith:titleStr content:contStr toUID:receiverStr Success:^{
            
            [self showSuccessWithStatusHUD:@"发送成功"];
            if(self.IsHorizontal)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            return;
            
        } failure:^(NSError *error) {
            
            [self showError:error];
            
            return;
            
        }];

    }
    
    
    if (self.sendType == 4)
    {
        return;
    }
    
    NSString * selfUserType = [NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType];
    
    if ([selfUserType isEqualToString:@"1"]|| ([selfUserType isEqualToString:@"3"] && [AppManager sharedManager].user.isAdmin.intValue != 1))
    {
        
        if(self.sendType != 1)
        {
            [MessageModel sendMessageWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] userIDs:receiverStr departmentIDs:nil title:titleStr content:contentTextStr sendType:self.sendType success:^{
                
                [self dismissLoadingHUD];
                
                [self showSuccessWithStatusHUD:@"发送成功"];
            
                //发送成功
                [self performSelector:@selector(delay) withObject:nil afterDelay:1.0];
                
                sender.enabled = YES;
                
            } failure:^(NSError *error) {
                
                [self showError:error];
                [self dismissLoadingHUD];
                sender.enabled = YES;
            }];
            
            sender.enabled = YES;
            
            return;
            
        }else{
            
            [MessageModel replyMessageWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] linkID:self.modelID toUid:self.from_uid title:titleStr content:contentTextStr success:^{
                
                [self dismissLoadingHUD];
                
                [self showSuccessWithStatusHUD:@"回复成功"];
                
                
                //发送成功
                [self performSelector:@selector(delay) withObject:nil afterDelay:1.0];
                
                sender.enabled = YES;
                
            } failure:^(NSError *error) {
                
                [self showError:error];
                
                [self dismissLoadingHUD];
                sender.enabled = YES;
            }];
            
            sender.enabled = YES;
            
            return;
        }
    }
    
    [MessageModel sendMessageWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] userIDs:self.userIDStr departmentIDs:self.departmentIDIdStr title:titleStr content:contentTextStr  sendType:self.sendType success:^{
        
        [self dismissLoadingHUD];
        
        if (self.sendType == 1)
        {
            [self showSuccessWithStatusHUD:@"回复成功"];
        }else
        {
            [self showSuccessWithStatusHUD:@"发送成功"];
        }
        
        //发送成功
        [self performSelector:@selector(delay) withObject:nil afterDelay:1.0];
        
        sender.enabled = YES;
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        
        [self showError:error];
        
        sender.enabled = YES;
    }];
    
    
}


- (void)delay
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"RefleshTheMailBoxOutData" object:nil userInfo:nil];
    
    if(self.IsHorizontal)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma UITextfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma UITextview delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textViewPlaceHoder.hidden = YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text.length == 0)
    {
        self.textViewPlaceHoder.hidden = NO;
    }
    
    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

@end
