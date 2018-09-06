//
//  TrainAssessTableController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TrainAssessTableController.h"
#import "WaitToDoTaskTool.h"
#import "NSDate+Util.h"
#import "UIImageView+WebCache.h"
#import "UITableView+UITableView_Util.h"

static NSString *const reuseID = @"TrainAssessListCell";

@interface TrainAssessTableController ()<UITableViewDelegate,UITableViewDataSource>

@property (assign,nonatomic)NSInteger sopIndex;
@property (assign,nonatomic)NSInteger commonIndex;

@end

@implementation TrainAssessTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commonIndex = 1;
    self.sopIndex = 1;
    
    [self buildUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)buildUI {
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
//    [self.tableView headerBeginRefreshing];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.rowHeight = 80;
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataBase.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrainAssessListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    WaitToDoTask *model = self.dataBase[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellAction) {
        WaitToDoTask *model = self.dataBase[indexPath.row];
        self.cellAction(model);
    }
}

-(void)setType:(AssessTaskType)type
{
    _type = type;
    
  [self.tableView headerBeginRefreshing];
}

#pragma mark - Network
- (void)loadNewData {
    
    self.page = 1;
    [self.tableView removeNoDataTipsView];
    NSString * action;
    if (self.type == AssessTypeTaskCourse)
    {
        action = @"getCommonTask";
        
        
    }
    else if(self.type == AssessTaskTypeSOP)
    {
        action = @"getSOPTask";
        
    }
    [WaitToDoTaskTool requestWaitDoTaskWithAction:action taskStatus:self.taskStatus  page:self.page success:^(NSArray *list) {
        
        
        [self.dataBase removeAllObjects];
        
        if (list.count != 0) {
            
            self.dataBase = [NSMutableArray arrayWithArray:list];
            
        }
        else{
            
            [self.tableView setNoDataTipsView:0];
        }

        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];

        
        //改为只有当普通任务以及SOP任务都没有任务时才提示
        if (self.type == AssessTypeTaskCourse)
        {
            self.commonIndex = list.count;
        }
        else if(self.type == AssessTaskTypeSOP)
        {
            self.sopIndex = list.count;
            
        }
        
        if (self.sopIndex == 0 && self.commonIndex == 0)
        {
            [self showSuccessWithStatusHUD:@"没有任务"];
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView headerEndRefreshing];
        
//        [self showError:error];
    }];
}

- (void)loadMoreData {
    
    self.page++;
    NSString * action;
    if (self.type == AssessTypeTaskCourse)
    {
        action = @"getCommonTask";
    }
    else if(self.type == AssessTaskTypeSOP)
    {
        action = @"getSOPTask";
    }
    
    [WaitToDoTaskTool requestWaitDoTaskWithAction:action taskStatus:self.taskStatus  page:self.page success:^(NSArray *list) {
        
        [self.dataBase addObjectsFromArray:list];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView footerEndRefreshing];
        
//       [self showError:error];
    }];
}

#pragma mark - Getter和Setter
- (void)setTaskStatus:(NSString *)taskStatus {
    _taskStatus = taskStatus;
    
    [self.tableView headerBeginRefreshing];
}

@end

@interface TrainAssessListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapterCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end

@implementation TrainAssessListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.stateLabel.transform = CGAffineTransformMakeRotation(-20*M_PI/180);
    self.stateLabel.layer.borderWidth = 2;
    self.stateLabel.layer.cornerRadius = 2;
    self.stateLabel.layer.masksToBounds = YES;
    
}

-(void)setModel:(WaitToDoTask *)model
{
    _model = model;
    self.titleLabel.text = _model.taskName;
    self.chapterCountLabel.text = [NSString stringWithFormat:@"共%@章节",_model.chaptersNum];
    self.endTimeLabel.text = [NSString stringWithFormat:@"截止时间:%@", [NSDate dateWithTimeInterval:[_model.endTime floatValue] format:@"yyyy-MM-dd"]];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:PlaceHolderImage];
    NSString * stateStr;
    UIColor * Textcolor;
    self.userInteractionEnabled = YES;
    
    switch (model.taskStatus.integerValue) {
        case 0:
            stateStr = @"未达标";
            Textcolor = HEXRGB(0xf66060);
            
            break;
        case 1:
            stateStr = @"已达标";
            Textcolor = HEXRGB(0x47c1a9);
            
            break;
        case 2:
            stateStr = @"未参加";
            Textcolor = HEXRGB(0xff9b60);
            break;
            
        default:
            break;
    }
    
    if (model.isEnd.integerValue == 1)
    {
        Textcolor = HEXRGB(0xcccccc);
        self.userInteractionEnabled = NO;
        self.titleLabel.textColor = Textcolor;
        self.chapterCountLabel.textColor = Textcolor;
        self.endTimeLabel.textColor = Textcolor;
    }else
    {
        self.userInteractionEnabled = YES;
        self.titleLabel.textColor = HEXRGB(0x333333);
        self.chapterCountLabel.textColor = HEXRGB(0x999999);
        self.endTimeLabel.textColor = HEXRGB(0x999999);
    }
    
    self.stateLabel.layer.borderWidth = 1;
    self.stateLabel.textColor = Textcolor;
    self.stateLabel.layer.borderColor = Textcolor.CGColor;
    self.stateLabel.text =stateStr;
}


@end
