//
//  MailBoxDetailViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MailBoxDetailViewController.h"

#import "MailBoxEditorViewController.h"
#import "TrainCourseDetailController.h"
#import "TrainSopDetailController.h"

#import "NSDate+Util.h"
#import "UILabel+autoResize.h"
#import "UIAlertView+Block.h"
#import "CustomActionSheet.h"
#import "ZHProgressView.h"

#import "MessageModel.h"
#import "ReceiverModel.h"

#import "TrainDetailCourseController.h"
#import "TrainDetailSopController.h"

@interface MailBoxDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *typeL;

@property (strong, nonatomic) IBOutlet UIButton *rightButton;

@property (strong, nonatomic) IBOutlet UILabel *receiverLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiverLabelTrailing;

@property (strong, nonatomic) IBOutlet UILabel *addTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *subjectLabel;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet UIView *taskView;

@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *taskEndTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *endL;

@property (weak, nonatomic) IBOutlet UIImageView *rightArrowView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taskViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taskViewTop;

@property (strong,nonatomic) ZHProgressView *progressView;

@property (strong, nonatomic) InboxDetailModel *InboxDetail;

@property (strong, nonatomic) OutboxDetailModel *OutboxDetail;

@property (assign, nonatomic) BOOL showAllReceiverLabel;

@end

@implementation MailBoxDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置按钮
    self.deleteButton.layer.borderColor = HEXRGB(0xececec).CGColor;
    self.deleteButton.layer.borderWidth = 1.0f;
    
    self.rightButton.layer.borderColor = HEXRGB(0xececec).CGColor;
    self.rightButton.layer.borderWidth = 1.0f;
    
    if (self.type == 0)
    {
        
        [self.rightButton setTitle:@"回复/转发" forState:UIControlStateNormal];
        
    }else
    {
        
        [self.rightButton setTitle:@"再发一封" forState:UIControlStateNormal];
    }
    
    if (self.outMessageID)
    {
        [self showLoadingView:64];
        [self getOutboxDataWithID:self.outMessageID];
        
    }else if(self.inMessageID)
    {
        [self showLoadingView:64];
        [self getInboxDataWithID:self.inMessageID];
    }
    
}
#pragma mark --  back action
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- setting and getting(收件箱ID)
- (void)setInMessageID:(NSString *)inMessageID
{
    _inMessageID = inMessageID;
    
}
#pragma mark -- setting and getting(发件箱ID)
-(void)setOutMessageID:(NSString *)outMessageID
{
    _outMessageID = outMessageID;
}
#pragma mark -- HTTP（收件箱）
- (void)getInboxDataWithID:(NSString *)idStr
{
    
    [MessageModel requestInboxDetailWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] linkID:idStr Success:^(InboxDetailModel *inboxDetail) {
        
        [self dismissLoadingView];
        
        self.InboxDetail = inboxDetail;
        
        [self buildViews];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingView];
        
        [self showError:error];
        
    }];
    
}
#pragma mark -- HTTP(发件箱)
-(void)getOutboxDataWithID:(NSString *)idStr
{
    [MessageModel requestOutboxDetailWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] msgID:idStr Success:^(OutboxDetailModel *outboxDetail) {
        
        [self dismissLoadingView];
        
        self.OutboxDetail = outboxDetail;
        
        [self buildViews];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingView];
        
        [self showError:error];
    }];
    
}
#pragma mark -- 数据的赋值
- (void)buildViews
{
    CGFloat height;
    
    if (self.InboxDetail)
    {
        //给各地方赋值
        self.receiverLabel.text = self.InboxDetail.from_uname;
        self.receiverLabelTrailing.constant = 20;
        self.receiverLabel.numberOfLines = 0;
        [self.receiverLabel sizeToFit];
        self.moreButton.hidden = YES;
        self.typeL.text = @"发件人：";
        [self.typeL sizeToFit];
        self.addTimeLabel.text = [NSString stringWithFormat:@"时间：%@",[NSDate dateWithTimeInterval:[self.InboxDetail.addTime floatValue] format:@"yyyy-MM-dd HH:mm"]];
        
        self.subjectLabel.numberOfLines = 0;
        self.subjectLabel.text = self.InboxDetail.title;
        [self.subjectLabel sizeToFit];
        
        self.contentLabel.numberOfLines = 0;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.InboxDetail.content];
        NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
        
        style2.headIndent = 0;
        
        style2.firstLineHeadIndent = 0;
        
        style2.lineSpacing = 5;
        
        [text addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(0, text.length)];
        self.contentLabel.attributedText = text;
        
        [self.contentLabel sizeToFit];
        
        height = CGRectGetMaxY(self.contentLabel.frame) + 270;
        
        CGFloat constHeight = CGRectGetMaxY(self.contentLabel.frame);
        
        if (self.InboxDetail.hasTask.intValue == 1)
        {
            //员工帐号个个人帐号有点击进去任务
            if ([AppManager sharedManager].user.userType == UserType_personal||[AppManager sharedManager].user.userType == UserType_employee) {
                
                self.taskView.hidden = NO;
            }else{
                
                self.taskView.hidden = YES;
            }
            self.taskTitleLabel.numberOfLines = 0;
            self.taskTitleLabel.text = self.InboxDetail.taskData.task_title;
            [self.taskTitleLabel sizeToFit];
            self.endL.hidden = self.InboxDetail.taskData.isEnd.intValue == 1?NO:YES;
            self.rightArrowView.hidden = self.InboxDetail.taskData.isEnd.intValue == 1?YES:NO;
            
            self.taskEndTimeLabel.text = [NSString stringWithFormat:@"截止时间：%@",[NSDate dateWithTimeInterval:[self.InboxDetail.taskData.endTime floatValue] format:@"yyyy-MM-dd"]];
            
            self.taskViewHeight.constant = self.taskTitleLabel.height + 45;
            self.taskView.height = self.taskTitleLabel.height + 45;
            
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0,ScreenW, self.taskView.height);
            [self.taskView addSubview:btn];
            [btn addTarget:self action:@selector(pushToTask) forControlEvents:UIControlEventTouchUpInside];
            
            if (constHeight + 2*self.taskView.height < ScreenH - 64 -45)
            {
                self.taskViewTop.constant = ScreenH - 45 - 2*self.taskView.height - 10 - constHeight - 64 + 10;
            }
            
            height = constHeight + 2*self.taskView.height + 20;
            
            [self displayRate:self.InboxDetail.taskData.progress.integerValue];
            [self.taskView addSubview:self.progressView];
            
        }else
        {
            self.taskView.hidden = YES;
            
        }
    } else if (self.OutboxDetail)
    {
        //给各地方赋值
        self.typeL.text = @"收件人：";
        [self.typeL sizeToFit];
        
        if (!self.showAllReceiverLabel)
        {
            self.receiverLabel.text = self.OutboxDetail.receiver;
        }
        self.receiverLabel.numberOfLines = 0;
        [self.receiverLabel sizeToFit];
        
        if (self.receiverLabel.height < 25)
        {
            self.moreButton.hidden = YES;
        }else
        {
            self.moreButton.hidden = NO;
        }
        
        if (self.showAllReceiverLabel)
        {
            self.receiverLabel.numberOfLines = 0;
            self.receiverLabelTrailing.constant = 20;
            self.moreButton.hidden = YES;
            [self.receiverLabel sizeToFit];
            
        }else
        {
            self.receiverLabel.numberOfLines = 1;
            self.receiverLabel.height = 23;
        }
        
        if (!self.showAllReceiverLabel)
        {
            
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.OutboxDetail.receiver];
            
            for (int i =1; i<self.OutboxDetail.receiver.length; i ++)
            {
                NSRange redRangeTwo = [self rangeOfString:@"、" inString:self.OutboxDetail.receiver atOccurrence:i];
                
                [noteStr addAttribute:NSForegroundColorAttributeName value:HEXRGB(0x999999) range:redRangeTwo];
                
                NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
                style2.headIndent = 0;
                style2.firstLineHeadIndent = 0;
                style2.lineSpacing = 5;
                [noteStr addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(0, noteStr.length)];
                
                [self.receiverLabel setAttributedText:noteStr];
            }
        }
        [self.receiverLabel sizeToFit];
        self.addTimeLabel.text = [NSString stringWithFormat:@"时间：%@",[NSDate dateWithTimeInterval:[self.OutboxDetail.addTime floatValue] format:@"yyyy-MM-dd HH:mm"]];
        
        self.subjectLabel.numberOfLines = 0;
        self.subjectLabel.text = self.OutboxDetail.title;
        [self.subjectLabel sizeToFit];
        
        self.contentLabel.numberOfLines = 0;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.OutboxDetail.content];
        NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
        style2.headIndent = 0;
        style2.firstLineHeadIndent = 0;
        style2.lineSpacing = 5;
        [text addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(0, text.length)];
        self.contentLabel.attributedText = text;
        [self.contentLabel sizeToFit];
        
        CGFloat constHeight = CGRectGetMaxY(self.receiverLabel.frame);
        height = constHeight + 2*self.taskView.height + 20 + self.contentLabel.height;
        
        self.taskView.hidden = YES;
        
    }
    
    //根据内容设置scrollView的contentSize
    [self.scrollView sizeToFit];
    self.scrollView.contentSize = CGSizeMake(ScreenW, height);
    self.scrollView.hidden = NO;
    self.bgView.hidden = NO;
    [self dismissLoadingView];
    
}
-(NSRange)rangeOfString:(NSString*)subString inString:(NSString*)string atOccurrence:(int)occurrence
{
    int currentOccurrence = 0;
    NSRange rangeToSearchWithin = NSMakeRange(0, [string length]);
    
    while (YES)
    {
        currentOccurrence++;
        NSRange searchResult = [string rangeOfString:subString options:NSCaseInsensitiveSearch range:rangeToSearchWithin];
        
        if (searchResult.location == NSNotFound)
        {
            return searchResult;
        }
        if (currentOccurrence == occurrence)
        {
            return searchResult;
        }
        
        NSUInteger newLocationToStartAt = searchResult.location + searchResult.length;
        rangeToSearchWithin = NSMakeRange(newLocationToStartAt, string.length - newLocationToStartAt);
    }
}

#pragma mark -- 任务进度
- (ZHProgressView *)progressView{
    if (!_progressView)
    {
        CGFloat leadingX = ScreenW-10-45-25;
        if (self.InboxDetail.taskData.isEnd.intValue == 1)
        {
            leadingX = ScreenW-10-45;
        }
        _progressView = [[ZHProgressView alloc] initWithFrame:CGRectMake(leadingX,(self.taskView.height - 45)/2, 45, 45)];
        _progressView.radiusColor = HEXRGB(0xFF9D5E);
    }
    return _progressView;
}

- (void)displayRate:(NSUInteger)rate
{
    self.progressView.currentProgress = rate;
}
- (IBAction)moreButtonAction:(UIButton *)sender
{
    self.showAllReceiverLabel = YES;
    [self showLoadingView:64];
    [self buildViews];
}
#pragma mark -- 删除 Action
- (IBAction)deleteAction:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除该消息?" cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
    [alertView showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == 1)
        {
            if (self.type == 0)
            {
                [self showLoadingHUD];
                [MessageModel deleteMessageWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] linkIDs:self.InboxDetail.modelID from:nil success:^{
                    
                    [self dismissLoadingHUD];
                    
                    [self showSuccessWithStatusHUD:@"删除成功"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefleshTheMailBoxInData" object:nil userInfo:nil];
                    
                    [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
                    
                } failure:^(NSError *error) {
                    
                    [self dismissLoadingHUD];
                    
                    [self showError:error];
                }];
            }else if (self.type == 1)
            {
                [self showLoadingHUD];
                
                [MessageModel deleteMessageWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] linkIDs:self.OutboxDetail.msgId from:@"send" success:^{
                    
                    [self dismissLoadingHUD];
                    
                    [self showSuccessWithStatusHUD:@"删除成功"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefleshTheMailBoxOutData" object:nil userInfo:nil];
                    
                    [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
                    
                } failure:^(NSError *error) {
                    
                    [self dismissLoadingHUD];
                    
                    [self showError:error];
                }];
                
            }
        }
        
        [alertView removeFromSuperview];
    }];
    
}
-(void)delay
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- self.type == 0：回复/转发 ;self.type == 1:再发一封
- (IBAction)rightAction:(id)sender
{
    
    if (self.type == 0)
    {
        CustomActionSheet *sheet = [[CustomActionSheet alloc]init];
        sheet.firstTitle = @"回复";
        sheet.secondTitle = @"转发";
        
        [sheet showInView:self andBlock:^(CustomActionSheet *sheet, NSInteger index) {
            [self sheet:sheet clickBtnInIndex:index];
        }];
        
    }else if (self.type == 1)
    {
        NSArray *arr;
        
        ReceiverModel *receiver = [[ReceiverModel alloc] init];
        [receiver userName:self.OutboxDetail.receiver userID:self.OutboxDetail.toUid];
        arr = [NSArray arrayWithObject:receiver];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mailbox" bundle:nil];
        MailBoxEditorViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MailBoxEditorViewController"];
        
        controller.answerList = [NSMutableArray arrayWithArray:arr];
        controller.sendType = 2;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
    }
}

-(void)sheet:(CustomActionSheet *)sheetView clickBtnInIndex:(NSInteger)index
{
    NSArray *arr;
    
    if (index == 2)
    {
        [sheetView removeFromSuperview];
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mailbox" bundle:nil];
    MailBoxEditorViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MailBoxEditorViewController"];
    
    if (index == 0)
    {
        ReceiverModel *receiver = [[ReceiverModel alloc] init];
        [receiver userName:self.InboxDetail.from_uname userID:self.InboxDetail.from_uid];
        arr = [NSArray arrayWithObject:receiver];
    }
    
    controller.answerList = [NSMutableArray arrayWithArray:arr];
    controller.sendType = 0;
    
    if (index == 0)
    {
        controller.sendType = 1;
        controller.from_uid = self.InboxDetail.from_uid;
        controller.modelID = self.InboxDetail.modelID;
        [sheetView hiddenSelf];
        
    } else
    {
        controller.content = self.contentLabel.text;
        controller.sendType = 3;
        [sheetView hiddenSelf];
    }
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushToTask
{
    //    "task_id": "3972",        --任务id（普通/SOP）
    //    "task_cid": "8099",        --任务资源id(course/sop)
    //    "task_cls": "course",       --任务类型，course--普通任务，sop--SOP任务
    if (self.InboxDetail == nil)return;
    
    if (self.InboxDetail.taskData.isEnd.intValue == 1)
    {
        [self showErrorMessage:@"该任务已经结束了"];
        return;
    }
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"TrainAssess" bundle:nil];
    
    if ([self.InboxDetail.taskData.task_cls isEqualToString:@"course"])
    {
//        TrainCourseDetailController *courseVC = [storyBoard instantiateViewControllerWithIdentifier:@"CourseTaskDetail"];
        TrainDetailCourseController *courseVC = [storyBoard instantiateViewControllerWithIdentifier:@"DetailCourse"];
        
        courseVC.courseId = self.InboxDetail.taskData.task_cid;
        courseVC.taskId = self.InboxDetail.taskData.task_id;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:courseVC animated:YES];
    }
    else if ([self.InboxDetail.taskData.task_cls isEqualToString:@"sop"])
    {
        TrainDetailSopController *sopVC = [storyBoard instantiateViewControllerWithIdentifier:@"DetailSop"];
        
        sopVC.SOPId = self.InboxDetail.taskData.task_cid;
        sopVC.taskId = self.InboxDetail.taskData.task_id;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:sopVC animated:YES];
    }
    
}

@end
