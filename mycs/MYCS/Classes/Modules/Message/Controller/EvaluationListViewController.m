//
//  EvaluationListViewController.m
//  MYCS
//
//  Created by Yell on 16/1/21.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "EvaluationListViewController.h"
#import "UIImage+Color.h"
#import "ConstKeys.h"
#import "IQKeyboardManager.h"

@interface EvaluationListViewController ()<UIScrollViewDelegate,EvaluationTableViewCellDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet EvaluationListTableView *receiveTableView;
@property (weak, nonatomic) IBOutlet EvaluationListTableView *sendTableView;
@property (weak,nonatomic) UISegmentedControl * segmented;

@property (weak, nonatomic) IBOutlet UIView *sendView;

@property (weak, nonatomic) IBOutlet UITextField *ReplyTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footViewConstraintBottom;

@property (nonatomic,strong) EvaluationOtherModel * evaluationOtherModel;

@end

@implementation EvaluationListViewController

#pragma mark - *** 键盘监听 ***
- (void)addKeyboardNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowInComView:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideInComView:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - *** 键盘将要显示 ***
- (void)keyboardWillShowInComView:(NSNotification *)notif
{
    self.sendView.hidden = NO;
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = rect.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{

        
    } completion:^(BOOL finished) {
        
        self.footViewConstraintBottom.constant = keyboardH;
        
    }];
    
    
}
#pragma mark - *** 键盘影藏***
- (void)keyboardWillHideInComView:(NSNotification *)notif
{
    self.sendView.hidden = YES;
    self.ReplyTextField.text = @"";
    
    [UIView animateWithDuration:0.25 animations:^{
        
    } completion:^(BOOL finished) {
        
        self.footViewConstraintBottom.constant = -50;
        
    }];
}

-(void)selectReplyButton:(EvaluationListTableView *)tableView WithModel:(EvaluationOtherModel *)model
{
    _evaluationOtherModel = model;
    self.sendView.hidden = NO;
    self.ReplyTextField.placeholder = [NSString stringWithFormat:@"请输入回复%@的内容",model.from_realname];
    [self.ReplyTextField becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.ReplyTextField resignFirstResponder];
    return YES;
}
- (IBAction)ReplyButtonAction:(UIButton *)sender
{
    if ([self.ReplyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        return;
    
    sender.enabled = NO;
    
    [self showLoadingHUD];
    
    [EvaluationModel sendReplyCommentWithParentId:self.evaluationOtherModel.parent_id targetId:self.evaluationOtherModel.target_id targetType:self.evaluationOtherModel.target_type replyId:self.evaluationOtherModel.id reply_uid:self.evaluationOtherModel.from_uid toUid:self.evaluationOtherModel.to_uid contentStr:self.ReplyTextField.text Success:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ReplyCommentSuccess object:self];
        
        [self dismissLoadingHUD];
        
        self.evaluationOtherModel = nil;
        [self.ReplyTextField resignFirstResponder];
        self.ReplyTextField.text = nil;
        
        sender.enabled = YES;
        
        [self showSuccessWithStatusHUD:@"回复成功"];
        
    } Failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        [self.ReplyTextField resignFirstResponder];
        [self showErrorMessage:@"回复失败"];
        
        self.ReplyTextField.text = nil;
        
        sender.enabled = YES;
        
        self.evaluationOtherModel = nil;
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    
    self.footViewConstraintBottom.constant = -50;
    
#pragma mark 设置navbar样式
    NSArray * titleArr =@[@"收到",@"发出"];
    UISegmentedControl * Segmented =  [[UISegmentedControl alloc]initWithItems:titleArr];
    Segmented.frame =CGRectMake(0,0,100.0,30.0);
    Segmented.tintColor =HEXRGB(0x47c1a9);
    Segmented.selectedSegmentIndex = 0;
    [Segmented addTarget:self action:@selector(selectSegmented:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = Segmented;
    self.segmented = Segmented;
    
    UIImage *bgImage = [UIImage imageWithColor:HEXRGB(0xffffff)];
    
    [[AppDelegate sharedAppDelegate].rootNavi.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    [[AppDelegate sharedAppDelegate].rootNavi.navigationBar setTintColor:HEXRGB(0x47c1a9)];
    [[AppDelegate sharedAppDelegate].rootNavi.navigationBar setAlpha:1];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIImage *bgImage = [UIImage imageWithColor:HEXRGB(0x47c1a9)];
    [[AppDelegate sharedAppDelegate].rootNavi.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    [[AppDelegate sharedAppDelegate].rootNavi.navigationBar setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ReplyTextField.delegate = self;
    self.ReplyTextField.layer.borderColor = HEXRGB(0x999999).CGColor;
    self.ReplyTextField.layer.borderWidth = 0.8;
    self.ReplyTextField.layer.cornerRadius = 4;
    self.ReplyTextField.clipsToBounds = YES;
    
    self.sendView.layer.borderWidth = 0.8;
    self.sendView.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    
    [self addKeyboardNotification];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.baseScrollView.delegate = self;
    
    if (self.ViewType == EvalutaionTableViewTypeInsiders)
    {
        self.receiveTableView.StatusType = EvaluationStutasTypeAccept;
        self.receiveTableView.targetType = self.targetType;
        self.receiveTableView.ViewType =EvalutaionTableViewTypeInsiders;
        self.receiveTableView.delegateVS = self;
        
        self.sendTableView.StatusType = EvaluationStutasTypeSend;
        self.sendTableView.targetType = self.targetType;
        self.sendTableView.ViewType = EvalutaionTableViewTypeInsiders;
        self.sendTableView.delegateVS = self;
    }else
    {
        self.receiveTableView.StatusType = EvaluationStutasTypeAccept;
        self.receiveTableView.targetType = self.targetType;
        self.receiveTableView.ViewType =EvalutaionTableViewTypeOther;
        self.receiveTableView.delegateVS = self;
        
        self.sendTableView.StatusType = EvaluationStutasTypeSend;
        self.sendTableView.targetType = self.targetType;
        self.sendTableView.ViewType = EvalutaionTableViewTypeOther;
        self.receiveTableView.delegateVS = self;
    }
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(replyCommentSuccess:) name:ReplyCommentSuccess object:nil];
    
    self.segmented.selectedSegmentIndex = 0;
    [self selectSegmented:self.segmented];
}



#pragma mark segment点击方法
-(void)selectSegmented:(UISegmentedControl *)control
{
    
    switch (control.selectedSegmentIndex) {
        case 0:
            [self chooseTableViewAction:self.receiveTableView];
            if (self.receiveTableView.listDataSource.count == 0)
            {
                [self.receiveTableView RefreshList];
            }
            break;
        case 1:
            [self chooseTableViewAction:self.sendTableView];
            if (self.sendTableView.listDataSource.count == 0)
            {
                [self.sendTableView RefreshList];
            }
            break;
        default:
            break;
    }
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == self.receiveTableView.x) {
        
        self.segmented.selectedSegmentIndex = 0;
        
    }else if (scrollView.contentOffset.x == self.sendTableView.x)
    {
        self.segmented.selectedSegmentIndex = 1;
    }
}


- (void)chooseTableViewAction:(UITableView *)tableView
{
    
    [self.baseScrollView setContentOffset:CGPointMake(tableView.x,tableView.y) animated:YES];
}


-(void)replyCommentSuccess:(NSNotification *)notification
{
    [self.receiveTableView RefreshList];
    [self.sendTableView RefreshList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
