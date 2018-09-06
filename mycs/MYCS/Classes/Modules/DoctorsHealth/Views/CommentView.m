//
//  CommentView.m
//  MYCS
//
//  Created by GuiHua on 16/7/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "CommentView.h"
#import "UITableView+UITableView_Util.h"
#import "IQKeyboardManager.h"

@implementation CommentView

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.textView.delegate = self;
    self.textView.layer.cornerRadius = 4;
    self.textView.clipsToBounds = YES;
    self.textView.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.textView.layer.borderWidth = 1;
    
    self.tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    self.tapView.backgroundColor = [UIColor clearColor];
    self.tapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction)];
    
    [self.tapView addGestureRecognizer:tap];
}

-(void)tapViewAction
{
    [self.textView resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    self.plceHolderL.hidden = textView.text.length > 0 ? YES:NO;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.plceHolderL.hidden = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0 ? YES:NO;
    
    if (!self.plceHolderL.hidden) {
        [self resetEditParam];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    
    return YES;
}
#pragma mark - *** 键盘监听 ***
- (void)addKeyboardNotification
{
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;
    manager.enable = NO;
    manager.shouldShowTextFieldPlaceholder = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowInCaseView:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideInCaseView:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - *** 键盘将要显示 ***
- (void)keyboardWillShowInCaseView:(NSNotification *)notif {
  
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = rect.size.height;
    
    self.tapView.height = ScreenH - keyboardH;
    [self addSubview:self.tapView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [UIApplication sharedApplication].keyWindow.y = -keyboardH;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 animations:^{

            self.height = ScreenH - 0.56 *ScreenW;
            
        }];
    }];
}

#pragma mark - *** 键盘影藏 ***
- (void)keyboardHideInCaseView:(NSNotification *)notif {
    
    [self.tapView removeFromSuperview];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [UIApplication sharedApplication].keyWindow.y = 0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.y = 0.56 *ScreenW;
            self.height = ScreenH - 0.56 *ScreenW;
        }];
    }];
}


+ (instancetype)showInView:(UIView *)superView WithTargetId:(NSString *)targetId
{
    
    CommentView *commentView = [[[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:nil options:nil] lastObject];
    
    commentView.frame = superView.bounds;
    
    [commentView layoutIfNeeded];
    
    commentView.y = ScreenH;
    
    [superView addSubview:commentView];
    
    [commentView showAction];
    
    commentView.targetId = targetId;
    
    return commentView;
    
}

-(void)setTargetId:(NSString *)targetId
{
    [self addKeyboardNotification];
    _targetId = targetId;
    
    self.dataArrs = [NSMutableArray array];
    
    [self.tableView addHeaderWithCallback:^{
       
        [self loadNewData];
    }];
    
    [self.tableView addFooterWithCallback:^{
       
        [self loadMoreData];
    }];
    
    [self.tableView headerBeginRefreshing];
    
}

-(NSArray *)selectCommentId:(NSArray *)list
{
    if (self.commentId)
    {
        for (GeneralCommentModel *model in list)
        {
            if ([model.id isEqualToString:self.commentId])
            {
                model.expand = @"1";
            }
        }
    }
    
    self.commentId = nil;
    return list;
}

-(void)loadNewData
{
    self.page = 1;
    
    [GeneralCommentModel commentWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] action:@"list" pageSize:15 page:self.page targetType:7 targetId:self.targetId success:^(NSArray *list,NSString *total) {
        
        [self.dataArrs removeAllObjects];
        [self.dataArrs addObjectsFromArray:[self selectCommentId:list]];
        [self.tableView reloadData];
        self.numbL.text = [NSString stringWithFormat:@"%@条",total];
        [self.tableView headerEndRefreshing];
        
        if (list.count == 0)
        {
            [self.tableView setNoDataTipsView:0];
        }else
        {
            self.tableView.tableFooterView = nil;
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView headerEndRefreshing];
        [self showError:error];
    }];

}
-(void)loadMoreData
{
    self.page += 1;
    
    [GeneralCommentModel commentWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] action:@"list" pageSize:15 page:self.page targetType:7 targetId:self.targetId success:^(NSArray *list,NSString *total) {
        
        [self.dataArrs addObjectsFromArray:list];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];

        
    } failure:^(NSError *error) {
        
        [self.tableView footerEndRefreshing];
        [self showError:error];
    }];
}

#pragma mark - Action
- (void)showAction {
    
    [self layoutIfNeeded];
    
    self.transform = CGAffineTransformMakeTranslation(0, self.height);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.y = 0.56 *ScreenW;
        self.height = ScreenH - 0.56 *ScreenW;
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArrs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HealthCommentCellID = @"HealthCommentCell";
    UINib * nib = [UINib nibWithNibName:@"HealthCommentCell"
                                 bundle: [NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:HealthCommentCellID];
    
    HealthCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:HealthCommentCellID];
    
    GeneralCommentModel * model = self.dataArrs[indexPath.row];
    
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   self.cellHeight = [cell configWith:model];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (iS_IOS8LATER)
    {
        return self.cellHeight;
    }
    
    static NSString *HealthCommentCellID = @"HealthCommentCell";
    
    UINib * nib = [UINib nibWithNibName:@"HealthCommentCell"
                                 bundle: [NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:HealthCommentCellID];
    
    HealthCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:HealthCommentCellID];
    
    GeneralCommentModel * model = self.dataArrs[indexPath.row];
    
    return [cell configWith:model];
    
}

- (void)removeNotification
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;
    manager.enable = YES;
}
-(void)dismissAction
{
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, self.height);
        self.y = ScreenH;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (IBAction)colseBtnAction:(UIButton *)sender
{
    [self dismissAction];
}


- (IBAction)senCommentBtnAction:(UIButton *)sender
{
    if (![AppManager checkLogin]) return;
    
     NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (content.length <= 0)
    {
        [self.textView resignFirstResponder];
        [self showErrorMessage:@"请输入评论内容"];
        return;
    }
    
    sender.enabled = NO;
    
    [GeneralCommentModel addCmtWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] action:@"send" targetType:@"7" targetId:self.targetId content:self.textView.text replyId:self.toEid toUid:self.toUid toEid:self.toEid success:^(SCBModel *model) {
        
        [self.textView resignFirstResponder];
        
        [self showSuccessWithStatus:@"评论成功！"];
        
        [self resetEditParam];
        
        [self loadNewData];
        
        sender.enabled = YES;
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        sender.enabled = YES;
        
    }];
}
- (void)resetEditParam
{
    self.textView.text        = @"";
    self.plceHolderL.text = @"我来说两句...";
    self.plceHolderL.hidden = NO;
    self.toEid                     = nil;
    self.toUid                     = nil;
}

-(void)HealthCommentCell:(HealthCommentCell *)cell showAllButtonAction:(UIButton *)button
{
    [self.tableView reloadData];

}

-(void)HealthCommentCell:(HealthCommentCell *)cell replyButtonAction:(UIButton *)button commentModel:(GeneralCommentModel *)model
{
    if (![AppManager checkLogin]) return;
    
    [self resetEditParam];
    
    self.toEid = model.id;
    self.toUid = @"0";
    
    self.commentId = model.id;
    
     NSString *placeHolder          = [NSString stringWithFormat:@"回复:%@", model.name];
    self.plceHolderL.text = placeHolder;
    
    [self.textView becomeFirstResponder];
    
}
-(void)HealthCommentCell:(HealthCommentCell *)cell didTapReplyLabel:(ReplayContentControl *)control commentModel:(GeneralCommentModel *)model
{
    if (![AppManager checkLogin]) return;
    
     [self resetEditParam];
    
    NSString *placeHolder          = [NSString stringWithFormat:@"回复:%@", control.sunModel.name];
    
    self.plceHolderL.text = placeHolder;
    
    self.toEid = model.id;
    self.toUid = control.sunModel.uid;
    
    self.commentId = model.id;
    
    [self.textView becomeFirstResponder];
}

@end

















