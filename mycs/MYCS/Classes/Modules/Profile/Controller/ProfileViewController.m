//
//  ProfileViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIScrollView+SpringHeadView.h"
#import "ProfileButton.h"
#import "UIView+LineView.h"
#import "UserCenterModel.h"
#import "UIImageView+WebCache.h"
#import "ConstKeys.h"
#import "VideoSpaceController.h"
#import "UserCenterImagePickerView.h"
#import "UIImage+FX.h"
#import "TaskManageViewController.h"
#import "NewMsgCountModel.h"
#import "UILabel+Count.h"
#import "SDImageCache.h"
#import "ZHCycleView.h"
#import "TrainAssessListController.h"
#import "PreviewStatusTool.h"
#import "ProfileView.h"
#import "NewMessagesTool.h"

static NSString *reuseID = @"ContentCell";

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *menuList;

@property (nonatomic, strong) NSArray *focusList;
@property (nonatomic, strong) NSArray *focusModelList;

//未读消息数
@property (nonatomic, assign) int msgCount;
//未读任务数
@property (nonatomic, assign) int taskCount;

//头部的背景图
@property (nonatomic, strong) UIImageView *headerView;

//信箱
@property (nonatomic, strong) ProfileButton *msgBtn;
//机构任务
@property (nonatomic, strong) ProfileButton *orgTaskBtn;
//课程学习
@property (nonatomic, strong) ProfileButton *coureStudyBtn;
//培训考核
@property (nonatomic, strong) ProfileButton *trainAssessBtn;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    //设置TableView的样式
    self.tableView.tableFooterView              = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;

    //初始化背景图片
    //    [self buildHeaderView];

    //加载表格数据
    [self reloadTableView];
    
    //检查统计分析
    [self checkStaticsCanShow];

    //请求广告数据
    [self requestAdData];

    //获取未读消息数,只请求获取一次，之后由通知刷新
    [self checkNewMessage];

    //注册登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:LoginSuccess object:nil];

    //未读消息数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkProfileItemCount:) name:PROFILENOTI object:nil];

    //背景修改通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildUI) name:ChangeUserTopHeadPic object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.headerView removeFromSuperview];

    [self buildHeaderView];

    if ([AppManager sharedManager].selectQuit)
    {//当重退出登录新登录过后检查统计分析
        [self checkStaticsCanShow];
        [AppManager sharedManager].selectQuit = NO;
    }
    
    if ([AppManager hasLogin])
    {
        //请求背景头像
        [self loadUserCenterInfo];
        
        //监听未读消息
        [[NewMessagesTool sharedNewMessagesTool] startCheck];
    }
}

- (void)buildHeaderView {
    //设置表头
    UIImageView *headerView = ({

        UIImageView *imageView = [UIImageView new];
        imageView.frame        = CGRectMake(0, 0, ScreenW, ScreenW * 0.5);

        imageView.userInteractionEnabled = YES;

        [imageView sd_setImageWithURL:[NSURL URLWithString:[AppManager sharedManager].userCenterModel.topPic] placeholderImage:[UIImage imageNamed:@"profile_bg"]];

        imageView.contentMode = UIViewContentModeScaleAspectFill;

        imageView;

    });

    self.headerView = headerView;

    //添加点击事件
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTagAction:)];
    tapGest.numberOfTapsRequired    = 1;
    [headerView addGestureRecognizer:tapGest];

    //将背景图添加到tableView中
    [self.tableView addSpringHeadView:headerView];
}

#pragma mark - Http
//请求获取广告图的数据
- (void)requestAdData {
    //获取广告列表
    [ProfileFocus profileFocusListWithSuccess:^(NSArray *focusList) {

        self.focusModelList = focusList;

        //刷新表格
        [self reloadTableView];

    }
        failure:^(NSError *error) {

            [self showError:error];

        }];
}

//更新未读消息
- (void)checkNewMessage {
    [NewMsgCountModel checkUpdateWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] Success:^(NewMsgCountModel *model) {

        self.msgCount  = model.msgCount ? model.msgCount.intValue : 0;
        self.taskCount = model.taskCount ? model.taskCount.intValue : 0;

        //更新按钮的未读消息数
        [self updateButtonBadge:self.msgCount andTaskValue:self.taskCount];

    }
        failure:^(NSError *error){

        }];
}

- (void)loadUserCenterInfo {
    User *user = [AppManager sharedManager].user;

    [UserCenterModel requestUserCenterInformationWithUserID:user.uid userType:[NSString stringWithFormat:@"%d", user.userType] success:^(UserCenterModel *centerModel) {

        AppManager *manager = [AppManager sharedManager];

        if ([centerModel.topPic isEqualToString:manager.userCenterModel.topPic]) return;

        manager.userCenterModel = centerModel;

        //更新用户的背景图片
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:centerModel.topPic] placeholderImage:self.headerView.image];

    }
        failure:^(NSError *error){

        }];
}

//检查统计分析是否开发
- (void)checkStaticsCanShow {
    [PreviewStatusTool fectchStaticsIsOpenView:^(BOOL isOpenView) {
        
        [self reloadTableView];

    }];
}

- (void)updateButtonBadge:(int)msgValue andTaskValue:(int)taskValue {
    if (self.msgBtn)
    {
        [self.msgBtn setBadgeValue:msgValue];
    }

    if (self.orgTaskBtn)
    {
        [self.orgTaskBtn setBadgeValue:taskValue];
    }

    if (self.coureStudyBtn)
    {
        [self.coureStudyBtn setBadgeValue:taskValue];
    }

    if (self.trainAssessBtn)
    {
        [self.trainAssessBtn setBadgeValue:taskValue];
    }
}

#pragma mark - 刷新数据

//重新刷新tableView
- (void)reloadTableView {
    UserType type = [AppManager sharedManager].user.userType;

    self.menuList = [ProfileBtnModel modelMenuesWith:type];

    [self.tableView reloadData];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        self.tableView.contentOffset = CGPointMake(0, -ScreenW * 0.5);

    });

    //更新未读消息
    [self updateButtonBadge:self.msgCount andTaskValue:self.taskCount];
}

#pragma mark - 通知
//用户登录成功
- (void)loginSuccess {
    //刷新背景
    [self loadUserCenterInfo];

    //刷新表格的内容
    [self reloadTableView];
}

- (void)checkProfileItemCount:(NSNotification *)noti {
    NewMsgCountModel *model = noti.object;

    self.msgCount  = model.msgCount ? model.msgCount.intValue : 0;
    self.taskCount = model.taskCount ? model.taskCount.intValue : 0;

    //更新按钮的未读消息数
    [self updateButtonBadge:self.msgCount andTaskValue:self.taskCount];
}


#pragma mark - system class delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.focusList.count == 0 ? 2 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0.5;

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        User *user = [AppManager sharedManager].user;

        if ((user.userType == UserType_employee && user.isAdmin.intValue == 1) || user.userType == UserType_company)
        {
            //培训基地
            if ([AppManager sharedManager].user.agroup_id.intValue == 10) {
                
                return 55;
            }
            return 70;
        }
        else
        {
            return 55;
        }
    }

    if (indexPath.section == 1)
    {
        CGFloat buttonW = ScreenW / 3;
        return (((self.menuList.count - 1) / 3) + 1) * buttonW;
    }

    if (indexPath.section == 2)
    {
        return (self.focusList && self.focusList.count != 0) ? (ScreenW * 0.24) : 0;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        User *user = [AppManager sharedManager].user;

        if ((user.userType == UserType_employee && user.isAdmin.intValue == 1) || user.userType == UserType_company)
        {
            cell.nameLabel.text = user.user_staff[@"enterprise_name"];
            
        }
        else
        {
            cell.nameLabel.text = user.realname;
            
        }

        if ((user.userType == UserType_employee && user.isAdmin.intValue != 1) || user.userType == UserType_personal || user.userType == UserType_organization)
        {
            cell.contentL.hidden = YES;
            
        }
        else
        {
            cell.contentL.hidden = [AppManager sharedManager].user.agroup_id.intValue == 10 ? YES : NO;
        }

        [cell setLineType:LineViewTypeBottom];

        
        if (![AppManager hasLogin])
        {
            cell.nameLabel.text = @"未登录";
            cell.contentL.hidden = YES;
        }
        
        return cell;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 1)
    {
        [self setMenuContent:cell];
    }
    else if (indexPath.section == 2)
    {
        [self setScrollContent:cell];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        if ([AppManager checkLogin])
        {
            UIStoryboard *sb     = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
            UIViewController *vc = [sb instantiateInitialViewController];
            [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
        }
        
    }

    return;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1)
    {
        UIView *headerView = ({
            UIView *view         = [UIView new];
            view.backgroundColor = self.tableView.backgroundColor;
            view.frame           = CGRectMake(0, 0, ScreenW, 10);
            view;
        });
        return headerView;
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0)
    {
        UIView *footerView = ({
            UIView *view         = [UIView new];
            view.backgroundColor = self.tableView.backgroundColor;
            view.frame           = CGRectMake(0, 0, ScreenW, 10);
            view;
        });

        return footerView;
    }

    return nil;
}

- (void)menuBtnClick:(ProfileButton *)button {
    ProfileBtnModel *model = self.menuList[button.tag];

    if ([model.storyBoardName isEqualToString:@"Setting"] || [model.storyBoardName isEqualToString:@"PlayRecord"] || [model.storyBoardName isEqualToString:@"VideoCache"]) {
        
    }else
    {
        if (![AppManager checkLogin])return;
    }
    
    //只有StoryBoardName,没有ControllerId
    if (model.storyBoardName && model.controllerId == nil)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:model.storyBoardName bundle:nil];

        UIViewController *vc = [sb instantiateInitialViewController];

        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];

        return;
    } //只有ControllerId,没有StoryBoardName
    else if (!model.storyBoardName && model.controllerId)
    {
        Class class = NSClassFromString(model.controllerId);
        //创建实例
        id instance = [[class alloc] init];

        if ([instance isKindOfClass:[UIViewController class]])
        {
            UIViewController *vc = (UIViewController *)instance;

            [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
        }
    }

    //同时有ControllerId和StoryBoardName
    if ([model.storyBoardName isEqualToString:@"VideoSpace"])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:model.storyBoardName bundle:nil];

        VideoSpaceController *vc = [sb instantiateInitialViewController];

        if ([model.controllerId isEqualToString:@"Video"])
        {
            vc.type = VideoSpaceTypeVideo;
        }
        else if ([model.controllerId isEqualToString:@"Course"])
        {
            vc.type = VideoSpaceTypeCourse;
        }
        else if ([model.controllerId isEqualToString:@"SOP"])
        {
            vc.type = VideoSpaceTypeSOP;
        }

        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
        return;
    }

    if ([model.controllerId isEqualToString:@"OrgTask"])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:model.storyBoardName bundle:nil];

        TaskManageViewController *vc = [sb instantiateInitialViewController];

        vc.isOrgTask = YES;

        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
        return;
    }

    if ([model.controllerId isEqualToString:@"TrainAssess"])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:model.storyBoardName bundle:nil];

        TrainAssessListController *vc = [sb instantiateInitialViewController];

        vc.title = @"课程学习";

        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];

        return;
    }
    
    if ([model.storyBoardName isEqualToString:@"Statics"])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:model.storyBoardName bundle:nil];
        
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:model.controllerId];
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
        
        return;
    }
    
    if ([model.storyBoardName isEqualToString:@"Live"])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:model.storyBoardName bundle:nil];
        
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:model.controllerId];
        vc.title = @"我的直播";
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
        
        return;
    }

}

- (void)bgViewTagAction:(UIGestureRecognizer *)gestRec {
    
    if ([AppManager sharedManager].user.userType == UserType_employee || ![AppManager hasLogin])
    {
        return;
    }

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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];

    [self showLoadingHUD];

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    UIImage *newImage = [self renderImage:image];

    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.8);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    NSString *imageStr = [imageData base64Encoding];

#pragma clang diagnostic pop

    [UserCenterModel uploadTopPhotoDataWithuploadPhotoData:imageStr success:^(NSString *str) {

        [self dismissLoadingHUD];

        [self showSuccessWithStatusHUD:@"封面上传成功"];

        NSString *key = [NSString stringWithFormat:@"%@?imageView2/0/w/%d/h/%d/format/jpg/q/100", [AppManager sharedManager].userCenterModel.topPic, (int)ScreenW * 2, (int)ScreenW / 2 * 2];

        [[SDImageCache sharedImageCache] storeImage:newImage forKey:key];

        self.headerView.image = newImage;

    }
        failure:^(NSError *error) {

            [self dismissLoadingHUD];

            [self showErrorMessage:@"封面上传失败"];

        }];
}

- (UIImage *)renderImage:(UIImage *)image {
    UIImage *newImage = [image imageCroppedAndScaledToSize:CGSizeMake(ScreenW, (int)ScreenW / 2 * 2) contentMode:UIViewContentModeScaleAspectFill padToFit:NO];

    return newImage;
}

#pragma mark - private method
///  添加菜单按钮
- (void)setMenuContent:(UITableViewCell *)cell {
    if (cell.contentView.subviews.count > 0)
    {
        [self removeAllSubViewsInView:cell.contentView];
    }

    for (int i = 0; i < self.menuList.count; i++)
    {
        ProfileBtnModel *model = self.menuList[i];

        ProfileButton *button = [ProfileButton buttonWithType:UIButtonTypeCustom];

        [button setTitle:model.title forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:model.iconName] forState:UIControlStateNormal];

        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:HEXRGB(0x666666) forState:UIControlStateNormal];

        CGFloat buttonW = ScreenW / 3;
        CGFloat row     = i % 3;
        CGFloat col     = i / 3;

        button.frame = CGRectMake(buttonW * row, col * buttonW, buttonW, buttonW);

        [button addLineWithLineType:LineViewTypeBottom | LineViewTypeRight | LineViewTypeTop];

        button.tag = i;

        //添加事件
        [button addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        //关联属性
        if ([button.titleLabel.text isEqualToString:@"信箱"])
        {
            self.msgBtn = button;
        }
        else if ([button.titleLabel.text isEqualToString:@"机构任务"])
        {
            self.orgTaskBtn = button;
        }
        else if ([button.titleLabel.text isEqualToString:@"课程学习"])
        {
            self.coureStudyBtn = button;
        }
        else if ([button.titleLabel.text isEqualToString:@"培训考核"])
        {
            self.trainAssessBtn = button;
        }

        //更新按钮的未读消息数
        [self updateButtonBadge:self.msgCount andTaskValue:self.taskCount];

        [cell.contentView addSubview:button];
    }
}

///  添加轮播图广告
- (void)setScrollContent:(UITableViewCell *)cell {
    if (!self.focusList || self.focusList.count == 0) return;

    if (cell.contentView.subviews.count > 0)
    {
        [self removeAllSubViewsInView:cell.contentView];
    }
    
    ZHCycleView *loopView = [ZHCycleView cycleViewWithFrame:CGRectMake(0, 0, ScreenW, 0.24 * ScreenW) imageUrlGroups:self.focusList placeHolderImage:[UIImage imageNamed:@"loop"] selectAction:^(NSInteger index) {

        [UMAnalyticsHelper eventLogClick:@"event_final_page_banner"];
        Focus *focusModel = self.focusModelList[index];

        [ProfileView profileWtihParam:focusModel.param];
       
    }];

    loopView.currentPageTintColor = HEXRGB(0x47c1a8);
    loopView.pageTintColor        = HEXRGB(0xeeeeee);

    [cell.contentView addSubview:loopView];
}

- (void)removeAllSubViewsInView:(UIView *)view {
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - getter and setter

- (void)setFocusModelList:(NSArray *)focusModelList {
    _focusModelList = focusModelList;

    NSMutableArray *arr = [NSMutableArray array];

    for (Focus *model in focusModelList)
    {
        [arr addObject:model.imageSrc];
    }

    if (arr.count == 0) return;

    self.focusList = arr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation InfoCell



@end
