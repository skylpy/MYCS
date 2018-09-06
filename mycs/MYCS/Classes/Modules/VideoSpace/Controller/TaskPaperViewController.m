
//
//  TaskPaperViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/27.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskPaperViewController.h"
#import "LanscapeNaviController.h"
#import "NSString+Size.h"
#import "NSTimer+Addition.h"
#import "NSTimer+Blocks.h"
#import "NSDate+Util.h"
#import "PaperAlertView.h"
#import "MJExtension.h"

static NSString *const reuseID = @"TaskOptionCell";

@interface TaskPaperViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *paperTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NSArray *characterArr;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int completeTime;

@end

@implementation TaskPaperViewController

+ (instancetype)presentWith:(UIViewController *)vc paperModel:(PaperModel *)model {
    UIStoryboard *sb                 = [UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil];
    TaskPaperViewController *paperVC = [sb instantiateViewControllerWithIdentifier:@"TaskPaperViewController"];
    paperVC.paperModel               = model;

    LanscapeNaviController *lansNavi = [[LanscapeNaviController alloc] init];
    [lansNavi addChildViewController:paperVC];

    [vc presentViewController:lansNavi animated:YES completion:nil];
    return paperVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor whiteColor];

    [self buildUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self installNotification];
    [self.timer resumeTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)buildUI {
    self.paperTitleLabel.text = self.paperModel.title;

    NSString *time      = [NSDate dateWithTimeInterval:self.completeTime format:@"mm:ss"];
    self.timeLabel.text = [NSString stringWithFormat:@"倒计时 %@", time];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - Action
//计时时间到
- (void)timeOutAction {
    UserAnswer *answer = [self getUserAnswer];
    if (self.CompleteBlock)
    {
        [self invalidateTimer];
        self.CompleteBlock(answer);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)commitButtonAction:(UIButton *)button {
    if (![self hasAnswerAll])
    {
        //暂停定时器
        [self.timer pauseTimer];

        [PaperAlertView showInView:self.view message:@"还有未答题目是否提交？" With:AlertViewTypeSubmit usingBlock:^(PaperAlertView *alertView, NSInteger buttonIndex) {

            if (buttonIndex == 1)
            {
                [self didCommitAnser];
            }
            else
            { //重新开启定时器
                [self.timer resumeTimer];
            }

            [alertView removeFromSuperview];

        }];
    }
    else
    {
        [self didCommitAnser];
    }
}

- (void)didCommitAnser {
    UserAnswer *answer = [self getUserAnswer];
    if (self.CompleteBlock)
    {
        [self invalidateTimer];
        self.CompleteBlock(answer);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)hasAnswerAll {
    for (ItemModel *item in self.paperModel.items)
    {
        //判断用户选中的个数
        int count = 0;
        for (OptionModel *option in item.options)
        {
            if (option.userSelected)
            {
                count++;
            }
        }

        //如果用户一个也没选中
        if (count == 0)
        {
            return NO;
        }
    }

    return YES;
}

- (UserAnswer *)getUserAnswer {
    UserAnswer *answerModel = [UserAnswer new];
    answerModel.paperId     = self.paperModel.paperId;
    answerModel.finishTime  = self.paperModel.finishTime - self.completeTime;

    NSMutableArray *itemIdArr   = [NSMutableArray array];
    NSMutableArray *answerIdArr = [NSMutableArray array];

    for (ItemModel *item in self.paperModel.items)
    {
        [itemIdArr addObject:item.itemId];

        //每一道题，用户的答案
        NSMutableArray *optionArr = [NSMutableArray array];
        for (int i = 0; i < item.options.count; i++)
        {
            OptionModel *option = item.options[i];
            if (option.userSelected)
            {
                [optionArr addObject:self.characterArr[i]];
            }
        }

        if (optionArr.count == 0)
        {
            [optionArr addObject:@"0"];
        }

        NSString *optionSelect = [optionArr componentsJoinedByString:@""];

        [answerIdArr addObject:optionSelect];
    }

    NSString *itemString   = [itemIdArr componentsJoinedByString:@","];
    NSString *optionString = [answerIdArr componentsJoinedByString:@","];

    answerModel.itemId   = itemString;
    answerModel.answerId = optionString;

    [self resetModel];

    return answerModel;
}

- (void)resetModel {
    for (ItemModel *item in self.paperModel.items)
    {
        for (OptionModel *option in item.options)
        {
            option.userSelected = NO;
        }
    }
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.paperModel.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ItemModel *item = self.paperModel.items[section];

    return item.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];

    ItemModel *item     = self.paperModel.items[indexPath.section];
    OptionModel *option = item.options[indexPath.row];

    NSString *optionContent = [NSString stringWithFormat:@"%@、%@", self.characterArr[indexPath.row], option.content];

    cell.optionType  = item.type;
    cell.content     = optionContent;
    cell.optionModel = option;
    
    __weak typeof(self) weakSelf = self;

    cell.buttonAction = ^() {

        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf setUserSelectWith:item optionModel:option];

    };

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ItemModel *item = self.paperModel.items[section];

    NSString *titleString = [NSString stringWithFormat:@"%d.【%@】%@", (int)(section + 1), item.type, item.title];

    UIView *headerView         = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];

    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [headerView addSubview:label];

        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text                                      = titleString;
        label.font                                      = [UIFont systemFontOfSize:14];
        label.textColor                                 = HEXRGB(0x333333);
        label.numberOfLines                             = 0;

        label;
    });

    //添加约束
    NSString *hVFL = @"H:|-(20)-[titleLabel]-(20)-|";
    NSString *vVFL = @"V:|-(0)-[titleLabel]-(0)-|";

    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)];
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)];

    [headerView addConstraints:hConsts];
    [headerView addConstraints:vConsts];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ItemModel *item = self.paperModel.items[section];

    NSString *titleString = [NSString stringWithFormat:@"%d.【%@】%@",(int)section + 1, item.type, item.title];

    CGFloat h = [titleString heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:ScreenW - 40];

    return h + 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemModel *item     = self.paperModel.items[indexPath.section];
    OptionModel *option = item.options[indexPath.row];

    NSString *optionContent = [NSString stringWithFormat:@"%@、%@", self.characterArr[indexPath.row], option.content];

    CGFloat h = [optionContent heightWithFont:[UIFont systemFontOfSize:12] constrainedToWidth:(ScreenW - 50 - 45)];

    return h + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemModel *item     = self.paperModel.items[indexPath.section];
    OptionModel *option = item.options[indexPath.row];

    [self setUserSelectWith:item optionModel:option];
}

- (void)setUserSelectWith:(ItemModel *)item optionModel:(OptionModel *)option {
    if ([item.type isEqualToString:@"单选"] || [item.type isEqualToString:@"判断"])
    {
        for (OptionModel *model in item.options)
        {
            //取消之前的选择
            if (model.userSelected)
            {
                model.userSelected = NO;
            }
        }

        option.userSelected = YES;
    }
    else
    {
        option.userSelected = !option.userSelected;
    }

    [self.tableView reloadData];
}

#pragma mark - Private
//注册监听
- (void)installNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeForeign:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationEnterBackground:(NSNotification *)noti {
    [self.timer pauseTimer];
}

- (void)applicationBecomeForeign:(NSNotification *)noti {
    [self.timer resumeTimer];
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    [self invalidateTimer];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getter和Setter
- (NSArray *)characterArr {
    if (!_characterArr)
    {
        _characterArr = @[ @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z" ];
    }
    return _characterArr;
}

- (NSTimer *)timer {
    if (!_timer)
    {
        
        __unsafe_unretained typeof(self) weakSelf = self;
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 block:^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            strongSelf.completeTime--;
            
            if (strongSelf.completeTime == -1)
            {
                [strongSelf invalidateTimer];
                
                [strongSelf timeOutAction];
                
            }
            else
            {
                NSString *time      = [NSDate dateWithTimeInterval:strongSelf.completeTime format:@"mm:ss"];
                strongSelf.timeLabel.text = [NSString stringWithFormat:@"倒计时 %@", time];
            }

            
        } repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        _timer = timer;
    }
    
    return _timer;
}

- (void)setPaperModel:(PaperModel *)paperModel {
    _paperModel = paperModel;

    self.completeTime = paperModel.finishTime;
}

@end

@interface TaskOptionCell ()

@property (nonatomic, weak) IBOutlet TaskOptionButton *optionBtn;

@end

@implementation TaskOptionCell

- (void)setOptionModel:(OptionModel *)optionModel {
    _optionModel = optionModel;

    self.optionBtn.selected = optionModel.userSelected ? YES : NO;
}

- (void)setOptionType:(NSString *)optionType {
    _optionType               = optionType;
    self.optionBtn.optionType = self.optionType;
}

- (void)setContent:(NSString *)content {
    _content = content;
    [self.optionBtn setTitle:content forState:UIControlStateNormal];
}

- (IBAction)optionButtonAction:(TaskOptionButton *)sender {
    if (self.buttonAction)
    {
        self.buttonAction();
    }
}

@end

@implementation TaskOptionButton

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.titleLabel.numberOfLines = 0;
}

- (void)setOptionType:(NSString *)optionType {
    _optionType = optionType;

    NSString *imageNameN;
    NSString *imageNameS;

    if (![optionType isEqualToString:@"单选"] && ![optionType isEqualToString:@"判断"])
    {
        imageNameN = @"multiselect";
        imageNameS = @"multiselect_enter";
    }
    else
    {
        imageNameN = @"circle";
        imageNameS = @"circle_click";
    }

    [self setImage:[UIImage imageNamed:imageNameN] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:imageNameS] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.imageView.x      = 0;
    self.imageView.y      = (self.height - self.imageView.height) * 0.5;
    self.imageView.width  = 15;
    self.imageView.height = 15;

    self.titleLabel.x     = CGRectGetMaxX(self.imageView.frame) + 10;
    self.titleLabel.width = self.width - self.titleLabel.x - 20;

    [self.titleLabel sizeToFit];
    self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5;
}

@end

@implementation UserAnswer
MJCodingImplementation


    @end
