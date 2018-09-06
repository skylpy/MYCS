//
//  StatisticsHomeViewController.m
//  MYCS
//  统计页面
//  Created by Yell on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "StatisticsHomeViewController.h"
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "MonthSelectView.h"
#import "NSDate+Util.h"
#import "StatisticsModel.h"

@interface StatisticsHomeViewController ()<MonthSelectViewDelegate,PNChartDelegate>

@property (weak, nonatomic) IBOutlet UIView *chartBGView;
@property (weak, nonatomic) IBOutlet UIButton *DetailButton;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *centerBtnBGView;
@property (weak, nonatomic) IBOutlet UIView *dateView;


@property (strong, nonatomic) PNPieChart *pieChart;

@property (strong, nonatomic) NSString *currentMonth; //当前选择月份
@property (assign, nonatomic) NSInteger currentForm; //当前选择的列表下标值

@property (strong, nonatomic) NSArray *actionArray; //列表类型名队列
@property (strong, nonatomic) NSArray *titleArray; //名称队列
@property (strong, nonatomic) NSArray *colorArray; //扇形图颜色队列

//@property (nonatomic) PNLineChart * lineChart;

@end

@implementation StatisticsHomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"统计";
//    [self displayChart];
    //修改中心按钮
    self.centerBtnBGView.layer.cornerRadius = self.centerBtnBGView.height/2;
    
    [self setData];
    MonthSelectView * month = [MonthSelectView MonthSelectView];
    month.frame = self.dateView.bounds;
    month.delegate = self;
    [self.dateView addSubview:month];
    
    self.nameLabel.text = [NSString stringWithFormat:@"总%@",self.titleArray[0]];
    //    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)[statistics.total integerValue]];
    self.countLabel.text = @"0";
    [self.DetailButton setTitle:[NSString stringWithFormat:@"%@详情", self.titleArray[0]] forState:UIControlStateNormal];
    
    [self getStatisticalWithMonth:self.currentMonth action:[self.actionArray objectAtIndex:self.currentForm]];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)creatChart
//{
//        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:100 color:HEXRGB(0x47c1a9)]];
//
//        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(([self.chartBGView width]-250)/2, ([self.chartBGView height]-250)/2, 250, 250) items:items];
//        self.pieChart.descriptionTextColor = [UIColor clearColor];
//        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
//        self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
//        [self.chartBGView addSubview:self.pieChart];
//}

-(void)setData
{
    self.currentForm = 0;
    switch ([AppManager sharedManager].user.userType) {
        case UserType_personal:
        {
            //个人
            self.actionArray = @[ @"staffCourseCount", @"click"];
            self.titleArray = @[@"学习课程数", @"点播量"];
        }
            break;
        case UserType_employee:
        {
            //员工
            self.actionArray = @[@"staffCourseCount", @"staffClick"];
            self.titleArray = @[@"学习课程数", @"点播量"];
        }
            break;
        case UserType_organization:
        {
            //机构
            self.actionArray = @[@"member", @"server", @"click", @"studyHours"];
            self.titleArray = @[@"会员人数", @"服务数", @"点播量", @"学习时长"];
        }
            break;
        case UserType_company:
        {
            //企业
            self.actionArray = @[ @"click", @"studyTask", @"studyHours"];
            self.titleArray = @[@"点播量", @"内训学习数量", @"学习时长"];
            self.colorArray = @[[UIColor redColor], HEXRGB(0xff9c00), HEXRGB(0x79a5fe), HEXRGB(0x3bc999), HEXRGB(0x92cf67), HEXRGB(0x5bb0ec)];
        }
            break;
        default:
        {
            self.actionArray = @[@""];
            self.titleArray = @[@""];
            self.colorArray = @[[UIColor clearColor]];
        }
            break;
    }
    
}


- (void)displayChart
{
//    [self.lineChart removeFromSuperview];
    [self.pieChart removeFromSuperview];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:100 color:HEXRGB(0x47c1a9)],[PNPieChartDataItem dataItemWithValue:0 color:[UIColor redColor]],[PNPieChartDataItem dataItemWithValue:0 color:[UIColor whiteColor]]];
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(([self.chartBGView width]-250)/2, ([self.chartBGView height]-250)/2, 250, 250) items:items];
    self.pieChart.descriptionTextColor = [UIColor clearColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    [self.chartBGView insertSubview:self.pieChart belowSubview:self.centerBtnBGView];
    [self.pieChart strokeChart];
    
    
    
    
    
    
    
    
    
    
    //    self.titleLabel.text = @"Line Chart";
    
//    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
//    self.lineChart.yLabelFormat = @"%1.1f";
//    self.lineChart.backgroundColor = [UIColor clearColor];
//    [self.lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
//    self.lineChart.showCoordinateAxis = YES;
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
//    self.lineChart.yFixedValueMax = 300.0;
//    self.lineChart.yFixedValueMin = 0.0;
//    
//    [self.lineChart setYLabels:@[
//                                 @"0 min",
//                                 @"50 min",
//                                 @"100 min",
//                                 @"150 min",
//                                 @"200 min",
//                                 @"250 min",
//                                 @"300 min",
//                                 ]
//     ];
    
    // Line Chart #1
    NSArray * data01Array = @[@60.1, @160.1, @126.4, @0.0, @186.2, @127.2, @176.2];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = @"Alpha";
    data01.color = PNFreshGreen;
    data01.alpha = 0.3f;
    data01.itemCount = data01Array.count;
    data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Line Chart #2
    NSArray * data02Array = @[@0.0, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.dataTitle = @"Beta";
    data02.color = PNTwitterColor;
    data02.alpha = 0.5f;
    data02.itemCount = data02Array.count;
    data02.inflexionPointStyle = PNLineChartPointStyleCircle;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
//    self.lineChart.chartData = @[data01, data02];
//    [self.lineChart strokeChart];
//    self.lineChart.delegate = self;
//    
//    
//    [self.view addSubview:self.lineChart];
//    
//    self.lineChart.legendStyle = PNLegendItemStyleStacked;
//    self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
//    self.lineChart.legendFontColor = [UIColor redColor];
//    
//    UIView * oldLegend = [self.view viewWithTag:9999];
//    [oldLegend removeFromSuperview];
//    
//    UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
//    [legend setFrame:CGRectMake(30, 340, legend.frame.size.width, legend.frame.size.width)];
//    legend.tag = 9999;
//    [self.view addSubview:legend];
    
    
}

#pragma mark - http request
- (void)getStatisticalWithMonth:(NSString *)month action:(NSString *)action
{
    [StatisticsModel requestStatisticsWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] month:month action:action success:^(StatisticsModel *statistics) {
        [self displayChart];
        self.nameLabel.text = [NSString stringWithFormat:@"总%@", [self.titleArray objectAtIndex:self.currentForm]];
        self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)[statistics.total integerValue]];
        [self.DetailButton setTitle:[NSString stringWithFormat:@"%@详情", [self.titleArray objectAtIndex:self.currentForm]] forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - callback action
- (IBAction)changeStatisticalObjectAction:(UIButton *)sender {
    if ((self.actionArray.count-1) == self.currentForm) {
        self.currentForm = 0;
    } else {
        self.currentForm++;
    }
    [self getStatisticalWithMonth:self.currentMonth action:[self.actionArray objectAtIndex:self.currentForm]];
}

- (IBAction)lookForStatisticalDetail:(UIButton *)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Statistics" bundle:nil];
    //    if ([[self.actionArray objectAtIndex:self.currentForm] isEqualToString:@"income"]) {
    //
    //        IncomeDetailListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"IncomeDetailListViewController"];
    //        controller.monthString = self.currentMonth;
    //        [self.navigationController pushViewController:controller animated:YES];
    //
    //    } else if ([[self.actionArray objectAtIndex:self.currentForm] isEqualToString:@"payOut"]) {
    //
    //        OutPayDetailListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OutPayDetailListViewController"];
    //        controller.monthString = self.currentMonth;
    //        [self.navigationController pushViewController:controller animated:YES];
    //
    //    } else if ([[self.actionArray objectAtIndex:self.currentForm] isEqualToString:@"click"]) {
    //
    //        PlayCountViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PlayCountViewController"];
    //        controller.monthString = self.currentMonth;
    //        [self.navigationController pushViewController:controller animated:YES];
    //
    //    } else if ([[self.actionArray objectAtIndex:self.currentForm] isEqualToString:@"sell"]) {
    //
    //        SalesVolumeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SalesVolumeViewController"];
    //        controller.monthString = self.currentMonth;
    //        [self.navigationController pushViewController:controller animated:YES];
    //
    //    } else if ([[self.actionArray objectAtIndex:self.currentForm] isEqualToString:@"studyTask"]) {
    //
    //        StudyTaskDetailListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"StudyTaskDetailListViewController"];
    //        controller.monthString = self.currentMonth;
    //        [self.navigationController pushViewController:controller animated:YES];
    //
    //    } else if ([[self.actionArray objectAtIndex:self.currentForm] isEqualToString:@"studyHours"]) {
    //
    //        StudyHoursDetailListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"StudyHoursDetailListViewController"];
    //        controller.monthString = self.currentMonth;
    //        [self.navigationController pushViewController:controller animated:YES];
    //
    //    } else if ([[self.actionArray objectAtIndex:self.currentForm] isEqualToString:@"member"]) {
    //
    //        MemberCountDetailListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MemberCountDetailListViewController"];
    //        controller.monthString = self.currentMonth;
    //        [self.navigationController pushViewController:controller animated:YES];
    //
    //    } else if ([[self.actionArray objectAtIndex:self.currentForm] isEqualToString:@"server"]) {
    //
    //        ServiceNumberDetailListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ServiceNumberDetailListViewController"];
    //        controller.monthString = self.currentMonth;
    //        [self.navigationController pushViewController:controller animated:YES];
    //
    //    } else if ([[self.actionArray objectAtIndex:self.currentForm] isEqualToString:@"staffCourseCount"]) {
    //
    //        StaffCourseDetailListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"StaffCourseDetailListViewController"];
    //        controller.monthString = self.currentMonth;
    //        [self.navigationController pushViewController:controller animated:YES];
    //
    //    } else if ([[self.actionArray objectAtIndex:self.currentForm] isEqualToString:@"staffClick"]) {
    //
    //        StaffPlayCountDetailListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"StaffPlayCountDetailListViewController"];
    //        controller.monthString = self.currentMonth;
    //        [self.navigationController pushViewController:controller animated:YES];
    //
    //    }
}

#pragma mark - HeadViewDelegate
- (void)responseRightButton
{
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Statistics" bundle:nil];
    //    BillListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"BillListViewController"];
    //    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - MonthSelectViewDelegate
- (void)selectedMonth:(NSDate *)currentSelectMonth
{
    self.currentMonth = [NSDate dateToString:currentSelectMonth format:MONTHFORMAT];
    [self getStatisticalWithMonth:self.currentMonth action:[self.actionArray objectAtIndex:self.currentForm]];
}


@end
