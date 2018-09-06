//
//  TaskSelectVideoController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskSelectVideoController.h"
#import "CourseList.h"
#import "MJRefresh.h"
#import "SopList.h"
#import "UIImageView+WebCache.h"
#import "CustomTextField.h"
#import "NSString+Util.h"
#import "SelectClassController.h"

static NSString *const reuseID = @"TaskSelectVideoCell";

@interface TaskSelectVideoController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) int page;

@property (weak, nonatomic) IBOutlet CustomTextField *searchTextField;
@property (nonatomic,weak) UIImageView *searchIcon;

@property (nonatomic,strong) Course *selectCourse;
@property (nonatomic,strong) Sop *slectSOP;

@property (nonatomic,strong) TaskSelectVideoCell *selectCell;

@property (nonatomic,copy) NSString *keyword;

@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *vipIdStr;

@end

@implementation TaskSelectVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectAction:(UIButton *)sender {
    
    UIStoryboard *taskManageBoard = [UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil];
    SelectClassController *examDetailVC = [taskManageBoard instantiateViewControllerWithIdentifier:@"SelectClassController"];
    examDetailVC.selectId = self.idStr;
    examDetailVC.selectVipId = self.vipIdStr;
    
    __weak typeof(self) weakSelf = self;
    examDetailVC.completeBlock = ^(NSString *selectIdStr,NSString * vipIdStr) {
        
        weakSelf.idStr = selectIdStr;
        weakSelf.vipIdStr = vipIdStr;
        if (self.type == TaskSelectVideoTypeCommon)
        {
            [self.tableView addHeaderWithTarget:self action:@selector(loadNewCourseData)];
            [self.tableView headerBeginRefreshing];
        }
        else if (self.type == TaskSelectVideoTypeSOP)
        {
          
            [self.tableView addHeaderWithTarget:self action:@selector(loadNewSOPData)];
            [self.tableView headerBeginRefreshing];
        }

    };
    [self.navigationController pushViewController:examDetailVC animated:YES];
}


- (void)buildUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.keyword = @"";
    self.idStr = @"-1";
    self.vipIdStr = @"-1";
    
    [self.view layoutIfNeeded];
    
    if (self.type == TaskSelectVideoTypeCommon)
    {
        self.title = @"选择教程模板";
        [self.tableView addHeaderWithTarget:self action:@selector(loadNewCourseData)];
        [self.tableView addFooterWithTarget:self action:@selector(loadMoreCourseData)];
        [self.tableView headerBeginRefreshing];
    }
    else if (self.type == TaskSelectVideoTypeSOP)
    {
        self.title = @"选择SOP模板";
        [self.tableView addHeaderWithTarget:self action:@selector(loadNewSOPData)];
        [self.tableView addFooterWithTarget:self action:@selector(loadMoreSOPData)];
        [self.tableView headerBeginRefreshing];
    }
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 80;
    
    //设置search
    UIImageView *searchIcon = ({
        UIImageView *imageView = [UIImageView new];
        
        imageView.image = [UIImage imageNamed:@"search"];
        [imageView sizeToFit];
        
        [self.searchTextField addSubview:imageView];
        
        imageView;
    });
    
    self.searchIcon = searchIcon;
    
    searchIcon.y = (self.searchTextField.height-searchIcon.height)*0.5;
    searchIcon.x = (self.searchTextField.width*0.5-searchIcon.width)-5;
    
    self.searchTextField.marginLeft = self.searchTextField.width*0.5;
}

#pragma mark - Action
- (IBAction)completeAction:(id)sender {
    
    if (!self.selectCell) {
        [self showErrorMessage:@"请选择模板"];
        return;
    }
    
    if (self.completeBlock) {
        self.completeBlock(self.selectCell.courseModel,self.selectCell.sopModel);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskSelectVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    id model;
    model = self.dataSource[indexPath.row];
    
    if ([model isKindOfClass:[Course class]])
    {
        cell.courseModel = model;
    }
    else if ([model isKindOfClass:[Sop class]])
    {
        cell.sopModel = model;
    }
    
    BOOL selected;
    if (cell.courseModel&&cell.courseModel.isSeleted) {
        selected = YES;
    }
    else if (cell.sopModel&&cell.sopModel.isSeleted) {
        selected = YES;
    }
    else
    {
        selected = NO;
    }
    
    [cell setCellSelect:selected];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskSelectVideoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.courseModel)
    {
        self.selectCourse.isSeleted = NO;
        self.selectCourse = cell.courseModel;
        self.selectCourse.isSeleted = YES;
    }
    else if (cell.sopModel)
    {
        self.slectSOP.isSeleted = NO;
        self.slectSOP = cell.sopModel;
        self.slectSOP.isSeleted = YES;
    }
    
    [self.selectCell setCellSelect:NO];
    
    self.selectCell = cell;
    
    [cell setCellSelect:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.searchIcon.x = 10;
    
    self.searchTextField.marginLeft = CGRectGetMaxX(self.searchIcon.frame)+5;

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.keyword = [textField.text trimmingWhitespaceAndNewline];
    
    [self.tableView headerBeginRefreshing];
}

#pragma mark - Network
- (void)loadNewCourseData{
    
    self.page = 1;
    
    [CourseList courseListWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:@"courseList" keyword:self.keyword vipId:self.vipIdStr cateId:self.idStr pageSize:20 page:self.page fromCache:NO success:^(CourseList *courseList) {
        
        self.dataSource = [NSMutableArray arrayWithArray:courseList.list];
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        [self showError:error];
        [self.tableView headerEndRefreshing];
        
    }];
    
}

- (void)loadMoreCourseData{
    
    self.page ++;
    
    [CourseList courseListWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:@"courseList" keyword:self.keyword vipId:self.vipIdStr cateId:self.idStr pageSize:20 page:self.page fromCache:NO success:^(CourseList *courseList) {
        
        [self.dataSource addObjectsFromArray:courseList.list];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self.tableView footerEndRefreshing];
        
    }];
    
}

- (void)loadNewSOPData{
    
    self.page = 1;
    
    [SopList sopListWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:@"sopList" keyword:self.keyword vipId:self.vipIdStr cateId:self.idStr pageSize:20 page:self.page fromCache:NO success:^(SopList *sopList) {
        
        self.dataSource = [NSMutableArray arrayWithArray:sopList.list];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self.tableView headerEndRefreshing];
    }];
    
    
}

- (void)loadMoreSOPData{
    self.page ++;
    
    [SopList sopListWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:@"sopList" keyword:self.keyword vipId:self.vipIdStr cateId:self.idStr pageSize:20 page:self.page fromCache:NO success:^(SopList *sopList) {
        
        [self.dataSource addObjectsFromArray:sopList.list];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self.tableView footerEndRefreshing];
        
    }];
    
}

@end

@interface TaskSelectVideoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIcon;

@end

@implementation TaskSelectVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.numberOfLines = 2;
    self.selectedIcon.hidden = YES;
}

- (void)setCourseModel:(Course *)courseModel {
    _courseModel = courseModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:courseModel.image] placeholderImage:PlaceHolderImage];
    self.titleLabel.text = courseModel.name;
    self.descLabel.text = [NSString stringWithFormat:@"播放时长：%@",courseModel.duration];
    
}

- (void)setSopModel:(Sop *)sopModel {
    _sopModel = sopModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:sopModel.picUrl] placeholderImage:PlaceHolderImage];
    self.titleLabel.text = sopModel.name;
    self.descLabel.text = [NSString stringWithFormat:@"内包含%@个视频",sopModel.videoNum];
}

- (void)setCellSelect:(BOOL)select {
    
    self.selectedIcon.hidden = !select;
    
    self.contentView.backgroundColor = select?HEXRGB(0xeefff8):[UIColor whiteColor];

}

@end
