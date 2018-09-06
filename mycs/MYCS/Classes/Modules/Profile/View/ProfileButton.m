//
//  ProfileButton.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ProfileButton.h"

@interface ProfileButton ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ProfileButton

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame])
    {
        self.imageView.contentMode    = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    CGFloat imageCenterX = (self.width - self.imageView.width) * 0.5;
    CGFloat imageY       = (self.height - self.imageView.height - self.titleLabel.height - 10) * 0.5;
    
    self.imageView.frame = CGRectMake(imageCenterX, imageY, self.imageView.width, self.imageView.height);
    
    CGFloat titleX = (self.width - self.titleLabel.width) * 0.5;
    CGFloat titleY = CGRectGetMaxY(self.imageView.frame) + 10;
    
    self.titleLabel.frame = CGRectMake(titleX, titleY, self.titleLabel.width, self.titleLabel.height);
}

- (void)setBadgeValue:(int)value {
    if (value == 0)
    {
        [self.label removeFromSuperview];
        return;
    }
    
    NSString *titleText;
    if (value > 99)
    {
        titleText = @"99+";
    }
    else
    {
        titleText = [NSString stringWithFormat:@"%d", value];
    }
    
    self.label.text = titleText;
    
    [self addSubview:self.label];
}

- (UILabel *)label {
    if (!_label)
    {
        UILabel *label = [[UILabel alloc] init];
        _label         = label;
        
        [self addSubview:label];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font          = [UIFont systemFontOfSize:11];
        
        label.textColor       = [UIColor whiteColor];
        label.backgroundColor = HEXRGB(0xFF463A);
        
        label.layer.borderColor = [UIColor whiteColor].CGColor;
        label.layer.borderWidth = 1;
        
        int marginX = 7;
        int marginY = 12;
        
        if (ScreenW <= 330)
        {
            marginX = 10;
            marginY = 15;
        }
        else if (ScreenW > 400)
        {
            marginX = 5;
            marginY = 10;
        }
        
        CGFloat x = self.width * 0.5;
        CGFloat y = self.height * 0.5;
        
        label.frame = CGRectMake(x + marginX, y / 2 - marginY + 3, 25, 18);
        
        label.layer.cornerRadius = label.width / 2 - 4;
        label.clipsToBounds      = YES;
    }
    
    return _label;
}

@end

@implementation ProfileBtnModel

+ (instancetype)modelWithTitle:(NSString *)title iconName:(NSString *)iconName storyBoardName:(NSString *)storyBoardName controllerId:(NSString *)controllerId {
    ProfileBtnModel *model = [ProfileBtnModel new];
    model.title            = title;
    model.iconName         = iconName;
    model.storyBoardName   = storyBoardName;
    model.controllerId     = controllerId;
    
    return model;
}

#pragma mark - Public
+ (NSArray *)modelMenuesWith:(UserType)userType {
    if (userType == UserType_personal)
    {
        return [self buildPersonMenu];
    }
    else if (userType == UserType_employee)
    {
        if ([AppManager sharedManager].user.isAdmin.intValue == 1)
        {
            return [self buildOfficeManagerMenu];
        }
        else
        {
            return [self buildEmployeeMenu];
        }
    }
    else if (userType == UserType_organization)
    {
        return [self buildOrganizeMenu];
    }
    else if (userType == UserType_company)
    {
        //agroup_id 等于9的时候是卫计委  agroup_id 等于10的时候是培训基地
        if ([AppManager sharedManager].user.agroup_id.intValue == 9 || [AppManager sharedManager].user.agroup_id.intValue == 10) {
            
            return [self buildCommissionMenu];
        }
        else{
            
            return [self buildHosOffEntLabMenu];
        }
        
    }
    
    return [self buildNoLogin];
}
+(NSArray *)buildNoLogin
{
    NSMutableArray *arr = [NSMutableArray array];
    
    ProfileBtnModel *model1  = [ProfileBtnModel modelWithTitle:@"任务管理" iconName:@"profile_task" storyBoardName:@"TaskManage" controllerId:nil];
    ProfileBtnModel *model2  = [ProfileBtnModel modelWithTitle:@"机构任务" iconName:@"profile_orgtask" storyBoardName:@"TaskManage" controllerId:@"OrgTask"];
    ProfileBtnModel *model3  = [ProfileBtnModel modelWithTitle:@"视频空间" iconName:@"profile_video" storyBoardName:@"VideoSpace" controllerId:@"Video"];
    ProfileBtnModel *model4  = [ProfileBtnModel modelWithTitle:@"教程管理" iconName:@"profile_course" storyBoardName:@"VideoSpace" controllerId:@"Course"];
    ProfileBtnModel *model5  = [ProfileBtnModel modelWithTitle:@"SOP管理" iconName:@"profile_sop" storyBoardName:@"VideoSpace" controllerId:@"SOP"];
    ProfileBtnModel *model6  = [ProfileBtnModel modelWithTitle:@"岗位体系" iconName:@"profile_position" storyBoardName:@"PostSystem" controllerId:nil];
    ProfileBtnModel *model7  = [ProfileBtnModel modelWithTitle:@"统计分析" iconName:@"profile_statistics" storyBoardName:@"Statics" controllerId:@"StaticsViewController"];
    ProfileBtnModel *model8  = [ProfileBtnModel modelWithTitle:@"信箱" iconName:@"profile_mailbox" storyBoardName:@"Mailbox" controllerId:nil];
    ProfileBtnModel *model9  = [ProfileBtnModel modelWithTitle:@"安全中心" iconName:@"profile_safety" storyBoardName:@"SafeCenter" controllerId:nil];
    ProfileBtnModel *model10 = [ProfileBtnModel modelWithTitle:@"收藏夹" iconName:@"profile_collect" storyBoardName:@"CollectionPlace" controllerId:nil];
    ProfileBtnModel *model11 = [ProfileBtnModel modelWithTitle:@"离线观看" iconName:@"profile_offline" storyBoardName:@"VideoCache" controllerId:nil];
    ProfileBtnModel *model12 = [ProfileBtnModel modelWithTitle:@"播放记录" iconName:@"profile_record" storyBoardName:@"PlayRecord" controllerId:nil];
    
    ProfileBtnModel *model13 = [ProfileBtnModel modelWithTitle:@"设置" iconName:@"setting" storyBoardName:@"Setting" controllerId:nil];
     ProfileBtnModel *model14  = [ProfileBtnModel modelWithTitle:@"我的直播" iconName:@"profile_live" storyBoardName:@"Live" controllerId:@"MyLiveViewController"];
    
    [arr addObjectsFromArray:@[ model1, model2, model3, model4, model5, model14, model6, model7, model8, model9, model10, model11, model12, model13 ]];
    
    return arr;
    
}
#pragma mark - Private
//卫计委管理员平台中心
+ (NSArray *)buildCommissionMenu {
    
    NSMutableArray *arr = [NSMutableArray array];
    ProfileBtnModel *model1  = [ProfileBtnModel modelWithTitle:@"统计分析" iconName:@"profile_statistics" storyBoardName:@"Statics" controllerId:@"StaticsViewController"];
    ProfileBtnModel *model2  = [ProfileBtnModel modelWithTitle:@"任务管理" iconName:@"profile_task" storyBoardName:@"TaskManage" controllerId:nil];
    ProfileBtnModel *model3 = [ProfileBtnModel modelWithTitle:@"视频空间" iconName:@"profile_video" storyBoardName:@"VideoSpace" controllerId:@"Video"];
    ProfileBtnModel *model4  = [ProfileBtnModel modelWithTitle:@"教程管理" iconName:@"profile_course" storyBoardName:@"VideoSpace" controllerId:@"Course"];
    ProfileBtnModel *model5  = [ProfileBtnModel modelWithTitle:@"SOP管理" iconName:@"profile_sop" storyBoardName:@"VideoSpace" controllerId:@"SOP"];
    ProfileBtnModel *model6  = [ProfileBtnModel modelWithTitle:@"岗位体系" iconName:@"profile_position" storyBoardName:@"PostSystem" controllerId:nil];
    ProfileBtnModel *model7 = [ProfileBtnModel modelWithTitle:@"信箱" iconName:@"profile_mailbox" storyBoardName:@"Mailbox" controllerId:nil];
    ProfileBtnModel *model8 = [ProfileBtnModel modelWithTitle:@"安全中心" iconName:@"profile_safety" storyBoardName:@"SafeCenter" controllerId:nil];
    ProfileBtnModel *model9 = [ProfileBtnModel modelWithTitle:@"收藏夹" iconName:@"profile_collect" storyBoardName:@"CollectionPlace" controllerId:nil];
    ProfileBtnModel *model10  = [ProfileBtnModel modelWithTitle:@"离线观看" iconName:@"profile_offline" storyBoardName:@"VideoCache" controllerId:nil];
    ProfileBtnModel *model11 = [ProfileBtnModel modelWithTitle:@"播放记录" iconName:@"profile_record" storyBoardName:@"PlayRecord" controllerId:nil];
    ProfileBtnModel *model12 = [ProfileBtnModel modelWithTitle:@"设置" iconName:@"setting" storyBoardName:@"Setting" controllerId:nil];
    
    //统计分析开发
    BOOL opernPreview = [[NSUserDefaults standardUserDefaults] boolForKey:STATICSOPENVIEW];
    
    if (opernPreview)
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model5, model6, model7, model8, model9,model10,model11,model12 ]];
    }
    else
    {
        [arr addObjectsFromArray:@[ model2, model3, model4, model5, model6, model7, model9,model10,model11,model12 ]];
    }
    
    return arr;
    
}

//卫计委管理员账号中心
+ (NSArray *)buildCommissionManagerMenu {
    NSMutableArray *arr = [NSMutableArray array];
    
    ProfileBtnModel *model1  = [ProfileBtnModel modelWithTitle:@"任务管理" iconName:@"profile_task" storyBoardName:@"TaskManage" controllerId:nil];
    ProfileBtnModel *model2  = [ProfileBtnModel modelWithTitle:@"培训考核" iconName:@"profile_staff" storyBoardName:@"TrainAssess" controllerId:nil];
    ProfileBtnModel *model3 = [ProfileBtnModel modelWithTitle:@"视频空间" iconName:@"profile_video" storyBoardName:@"VideoSpace" controllerId:@"Video"];
    ProfileBtnModel *model4  = [ProfileBtnModel modelWithTitle:@"教程管理" iconName:@"profile_course" storyBoardName:@"VideoSpace" controllerId:@"Course"];
    ProfileBtnModel *model5  = [ProfileBtnModel modelWithTitle:@"SOP管理" iconName:@"profile_sop" storyBoardName:@"VideoSpace" controllerId:@"SOP"];
    ProfileBtnModel *model6  = [ProfileBtnModel modelWithTitle:@"岗位体系" iconName:@"profile_position" storyBoardName:@"PostSystem" controllerId:nil];
    ProfileBtnModel *model7 = [ProfileBtnModel modelWithTitle:@"信箱" iconName:@"profile_mailbox" storyBoardName:@"Mailbox" controllerId:nil];
    ProfileBtnModel *model8  = [ProfileBtnModel modelWithTitle:@"统计分析" iconName:@"profile_statistics" storyBoardName:@"Statics" controllerId:@"StaticsViewController"];
    ProfileBtnModel *model9 = [ProfileBtnModel modelWithTitle:@"安全中心" iconName:@"profile_safety" storyBoardName:@"SafeCenter" controllerId:nil];
    ProfileBtnModel *model10 = [ProfileBtnModel modelWithTitle:@"收藏夹" iconName:@"profile_collect" storyBoardName:@"CollectionPlace" controllerId:nil];
    ProfileBtnModel *model11  = [ProfileBtnModel modelWithTitle:@"离线观看" iconName:@"profile_offline" storyBoardName:@"VideoCache" controllerId:nil];
    ProfileBtnModel *model12 = [ProfileBtnModel modelWithTitle:@"播放记录" iconName:@"profile_record" storyBoardName:@"PlayRecord" controllerId:nil];
    ProfileBtnModel *model13 = [ProfileBtnModel modelWithTitle:@"设置" iconName:@"setting" storyBoardName:@"Setting" controllerId:nil];
    
    //统计分析开发
    BOOL opernPreview = [[NSUserDefaults standardUserDefaults] boolForKey:STATICSOPENVIEW];
    
    if (opernPreview)
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model5, model6, model7, model8, model9,model10,model11,model12,model13 ]];
    }
    else
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model5, model6, model7, model9,model10,model11,model12,model13 ]];
    }
    
    return arr;
    
}
//卫计委员工账号中心
+ (NSArray *)buildCommissionEmployeeMenu{
    NSMutableArray *arr = [NSMutableArray array];
    ProfileBtnModel *model1 = [ProfileBtnModel modelWithTitle:@"视频空间" iconName:@"profile_video" storyBoardName:@"VideoSpace" controllerId:@"Video"];
    ProfileBtnModel *model2  = [ProfileBtnModel modelWithTitle:@"培训考核" iconName:@"profile_staff" storyBoardName:@"TrainAssess" controllerId:nil];
    ProfileBtnModel *model3 = [ProfileBtnModel modelWithTitle:@"信箱" iconName:@"profile_mailbox" storyBoardName:@"Mailbox" controllerId:nil];
    ProfileBtnModel *model4 = [ProfileBtnModel modelWithTitle:@"收藏夹" iconName:@"profile_collect" storyBoardName:@"CollectionPlace" controllerId:nil];
    ProfileBtnModel *model5 = [ProfileBtnModel modelWithTitle:@"学习统计" iconName:@"profile_statistics" storyBoardName:@"Statics" controllerId:@"StudyStatisticsViewController"];
    ProfileBtnModel *model6 = [ProfileBtnModel modelWithTitle:@"安全中心" iconName:@"profile_safety" storyBoardName:@"SafeCenter" controllerId:nil];
    ProfileBtnModel *model7  = [ProfileBtnModel modelWithTitle:@"离线观看" iconName:@"profile_offline" storyBoardName:@"VideoCache" controllerId:nil];
    ProfileBtnModel *model8 = [ProfileBtnModel modelWithTitle:@"播放记录" iconName:@"profile_record" storyBoardName:@"PlayRecord" controllerId:nil];
    ProfileBtnModel *model9 = [ProfileBtnModel modelWithTitle:@"设置" iconName:@"setting" storyBoardName:@"Setting" controllerId:nil];
    
    
    //统计分析开发
    BOOL opernPreview = [[NSUserDefaults standardUserDefaults] boolForKey:STATICSOPENVIEW];
    
    if (opernPreview)
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model5, model6, model7, model8,model9 ]];
    }
    else
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model6, model7, model8,model9 ]];
    }
    
    return arr;
    
}


/*!
 @author Sky, 16-05-23 14:05:22
 
 @brief 个人账号
 
 @return
 
 @since
 */
+ (NSArray *)buildPersonMenu {
    NSMutableArray *arr = [NSMutableArray array];
    
    ProfileBtnModel *model1 = [ProfileBtnModel modelWithTitle:@"视频空间" iconName:@"profile_video" storyBoardName:@"VideoSpace" controllerId:@"Video"];
    ProfileBtnModel *model2 = [ProfileBtnModel modelWithTitle:@"课程学习" iconName:@"profile_study" storyBoardName:@"TrainAssess" controllerId:@"TrainAssess"];
    ProfileBtnModel *model3 = [ProfileBtnModel modelWithTitle:@"信箱" iconName:@"profile_mailbox" storyBoardName:@"Mailbox" controllerId:nil];
    
    ProfileBtnModel *model9 = [ProfileBtnModel modelWithTitle:@"学习统计" iconName:@"profile_statistics" storyBoardName:@"Statics" controllerId:@"StudyStatisticsViewController"];
    
    ProfileBtnModel *model4 = [ProfileBtnModel modelWithTitle:@"离线观看" iconName:@"profile_offline" storyBoardName:@"VideoCache" controllerId:nil];
    ProfileBtnModel *model5 = [ProfileBtnModel modelWithTitle:@"播放记录" iconName:@"profile_record" storyBoardName:@"PlayRecord" controllerId:nil];
    ProfileBtnModel *model6 = [ProfileBtnModel modelWithTitle:@"收藏夹" iconName:@"profile_collect" storyBoardName:@"CollectionPlace" controllerId:nil];
    ProfileBtnModel *model7 = [ProfileBtnModel modelWithTitle:@"安全中心" iconName:@"profile_safety" storyBoardName:@"SafeCenter" controllerId:nil];
    
    ProfileBtnModel *model8 = [ProfileBtnModel modelWithTitle:@"设置" iconName:@"setting" storyBoardName:@"Setting" controllerId:nil];
    
    //统计分析开发
    BOOL opernPreview = [[NSUserDefaults standardUserDefaults] boolForKey:STATICSOPENVIEW];
    
    if (opernPreview)
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model9, model4, model5, model6, model7, model8 ]];
    }
    else
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model5, model6, model7, model8 ]];
    }
    
    return arr;
}

//组织账号资料
+ (NSArray *)buildOrganizeMenu {
    NSMutableArray *arr = [NSMutableArray array];
    
    ProfileBtnModel *model1  = [ProfileBtnModel modelWithTitle:@"任务管理" iconName:@"profile_task" storyBoardName:@"TaskManage" controllerId:nil];
    ProfileBtnModel *model2  = [ProfileBtnModel modelWithTitle:@"视频空间" iconName:@"profile_video" storyBoardName:@"VideoSpace" controllerId:@"Video"];
    ProfileBtnModel *model3  = [ProfileBtnModel modelWithTitle:@"教程管理" iconName:@"profile_course" storyBoardName:@"VideoSpace" controllerId:@"Course"];
    ProfileBtnModel *model4  = [ProfileBtnModel modelWithTitle:@"SOP管理" iconName:@"profile_sop" storyBoardName:@"VideoSpace" controllerId:@"SOP"];
    ProfileBtnModel *model5  = [ProfileBtnModel modelWithTitle:@"统计分析" iconName:@"profile_statistics" storyBoardName:@"Statics" controllerId:@"StaticsViewController"];
    ProfileBtnModel *model6  = [ProfileBtnModel modelWithTitle:@"用户管理" iconName:@"profile_management" storyBoardName:@"UserManager" controllerId:nil];
    ProfileBtnModel *model7  = [ProfileBtnModel modelWithTitle:@"信箱" iconName:@"profile_mailbox" storyBoardName:@"Mailbox" controllerId:nil];
    ProfileBtnModel *model8  = [ProfileBtnModel modelWithTitle:@"离线观看" iconName:@"profile_offline" storyBoardName:@"VideoCache" controllerId:nil];
    ProfileBtnModel *model9  = [ProfileBtnModel modelWithTitle:@"播放记录" iconName:@"profile_record" storyBoardName:@"PlayRecord" controllerId:nil];
    ProfileBtnModel *model10 = [ProfileBtnModel modelWithTitle:@"安全中心" iconName:@"profile_safety" storyBoardName:@"SafeCenter" controllerId:nil];
    ProfileBtnModel *model11 = [ProfileBtnModel modelWithTitle:@"收藏夹" iconName:@"profile_collect" storyBoardName:@"CollectionPlace" controllerId:nil];
    ProfileBtnModel *model12 = [ProfileBtnModel modelWithTitle:@"设置" iconName:@"setting" storyBoardName:@"Setting" controllerId:nil];
    
    //统计分析开发
    BOOL opernPreview = [[NSUserDefaults standardUserDefaults] boolForKey:STATICSOPENVIEW];
    
    if (opernPreview)
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model5, model6, model7, model8, model9, model10, model11, model12 ]];
    }
    else
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model6, model7, model8, model9, model10, model11, model12 ]];
    }
    
    return arr;
}

//公司管理员账号
+ (NSArray *)buildOfficeManagerMenu {
    NSMutableArray *arr = [NSMutableArray array];
    
    ProfileBtnModel *model1  = [ProfileBtnModel modelWithTitle:@"任务管理" iconName:@"profile_task" storyBoardName:@"TaskManage" controllerId:nil];
    ProfileBtnModel *model2  = [ProfileBtnModel modelWithTitle:@"培训考核" iconName:@"profile_staff" storyBoardName:@"TrainAssess" controllerId:nil];
    ProfileBtnModel *model3  = [ProfileBtnModel modelWithTitle:@"视频空间" iconName:@"profile_video" storyBoardName:@"VideoSpace" controllerId:@"Video"];
    ProfileBtnModel *model4  = [ProfileBtnModel modelWithTitle:@"教程管理" iconName:@"profile_course" storyBoardName:@"VideoSpace" controllerId:@"Course"];
    ProfileBtnModel *model5  = [ProfileBtnModel modelWithTitle:@"SOP管理" iconName:@"profile_sop" storyBoardName:@"VideoSpace" controllerId:@"SOP"];
    ProfileBtnModel *model6  = [ProfileBtnModel modelWithTitle:@"岗位体系" iconName:@"profile_position" storyBoardName:@"PostSystem" controllerId:nil];
    ProfileBtnModel *model7  = [ProfileBtnModel modelWithTitle:@"信箱" iconName:@"profile_mailbox" storyBoardName:@"Mailbox" controllerId:nil];
    ProfileBtnModel *model8  = [ProfileBtnModel modelWithTitle:@"统计分析" iconName:@"profile_statistics" storyBoardName:@"Statics" controllerId:@"StaticsViewController"];
    ProfileBtnModel *model9  = [ProfileBtnModel modelWithTitle:@"安全中心" iconName:@"profile_safety" storyBoardName:@"SafeCenter" controllerId:nil];
    ProfileBtnModel *model10 = [ProfileBtnModel modelWithTitle:@"收藏夹" iconName:@"profile_collect" storyBoardName:@"CollectionPlace" controllerId:nil];
    ProfileBtnModel *model11 = [ProfileBtnModel modelWithTitle:@"离线观看" iconName:@"profile_offline" storyBoardName:@"VideoCache" controllerId:nil];
    ProfileBtnModel *model12 = [ProfileBtnModel modelWithTitle:@"播放记录" iconName:@"profile_record" storyBoardName:@"PlayRecord" controllerId:nil];
    
    ProfileBtnModel *model13 = [ProfileBtnModel modelWithTitle:@"设置" iconName:@"setting" storyBoardName:@"Setting" controllerId:nil];
    ProfileBtnModel *model14  = [ProfileBtnModel modelWithTitle:@"我的直播" iconName:@"profile_live" storyBoardName:@"Live" controllerId:@"MyLiveViewController"];

    //统计分析开发
    BOOL opernPreview = [[NSUserDefaults standardUserDefaults] boolForKey:STATICSOPENVIEW];
    
    if (opernPreview)
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model5,model14, model6, model7, model8, model9, model10, model11, model12, model13 ]];
    }
    else
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model5,model14, model6, model7, model9, model10, model11, model12, model13 ]];
    }
    
    return arr;
}

+ (NSArray *)buildHosOffEntLabMenu {
    NSMutableArray *arr = [NSMutableArray array];
    
    ProfileBtnModel *model1  = [ProfileBtnModel modelWithTitle:@"任务管理" iconName:@"profile_task" storyBoardName:@"TaskManage" controllerId:nil];
    ProfileBtnModel *model2  = [ProfileBtnModel modelWithTitle:@"机构任务" iconName:@"profile_orgtask" storyBoardName:@"TaskManage" controllerId:@"OrgTask"];
    ProfileBtnModel *model3  = [ProfileBtnModel modelWithTitle:@"视频空间" iconName:@"profile_video" storyBoardName:@"VideoSpace" controllerId:@"Video"];
    ProfileBtnModel *model4  = [ProfileBtnModel modelWithTitle:@"教程管理" iconName:@"profile_course" storyBoardName:@"VideoSpace" controllerId:@"Course"];
    ProfileBtnModel *model5  = [ProfileBtnModel modelWithTitle:@"SOP管理" iconName:@"profile_sop" storyBoardName:@"VideoSpace" controllerId:@"SOP"];
    ProfileBtnModel *model6  = [ProfileBtnModel modelWithTitle:@"岗位体系" iconName:@"profile_position" storyBoardName:@"PostSystem" controllerId:nil];
    ProfileBtnModel *model7  = [ProfileBtnModel modelWithTitle:@"统计分析" iconName:@"profile_statistics" storyBoardName:@"Statics" controllerId:@"StaticsViewController"];
    ProfileBtnModel *model8  = [ProfileBtnModel modelWithTitle:@"信箱" iconName:@"profile_mailbox" storyBoardName:@"Mailbox" controllerId:nil];
    ProfileBtnModel *model9  = [ProfileBtnModel modelWithTitle:@"安全中心" iconName:@"profile_safety" storyBoardName:@"SafeCenter" controllerId:nil];
    ProfileBtnModel *model10 = [ProfileBtnModel modelWithTitle:@"收藏夹" iconName:@"profile_collect" storyBoardName:@"CollectionPlace" controllerId:nil];
    ProfileBtnModel *model11 = [ProfileBtnModel modelWithTitle:@"离线观看" iconName:@"profile_offline" storyBoardName:@"VideoCache" controllerId:nil];
    ProfileBtnModel *model12 = [ProfileBtnModel modelWithTitle:@"播放记录" iconName:@"profile_record" storyBoardName:@"PlayRecord" controllerId:nil];
    
    ProfileBtnModel *model13 = [ProfileBtnModel modelWithTitle:@"设置" iconName:@"setting" storyBoardName:@"Setting" controllerId:nil];
    ProfileBtnModel *model14  = [ProfileBtnModel modelWithTitle:@"我的直播" iconName:@"profile_live" storyBoardName:@"Live" controllerId:@"MyLiveViewController"];
    
    //统计分析开发
    BOOL opernPreview = [[NSUserDefaults standardUserDefaults] boolForKey:STATICSOPENVIEW];
    
    if (opernPreview)
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model5,model14, model6, model7, model8, model9, model10, model11, model12, model13 ]];
    }
    else
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model5,model14, model6, model8, model9, model10, model11, model12, model13 ]];
    }
    
    return arr;
}

//雇员账号
+ (NSArray *)buildEmployeeMenu {
    NSMutableArray *arr = [NSMutableArray array];
    
    ProfileBtnModel *model1 = [ProfileBtnModel modelWithTitle:@"视频空间" iconName:@"profile_video" storyBoardName:@"VideoSpace" controllerId:@"Video"];
    ProfileBtnModel *model2 = [ProfileBtnModel modelWithTitle:@"培训考核" iconName:@"profile_staff" storyBoardName:@"TrainAssess" controllerId:nil];
    ProfileBtnModel *model3 = [ProfileBtnModel modelWithTitle:@"信箱" iconName:@"profile_mailbox" storyBoardName:@"Mailbox" controllerId:nil];
    ProfileBtnModel *model4 = [ProfileBtnModel modelWithTitle:@"收藏夹" iconName:@"profile_collect" storyBoardName:@"CollectionPlace" controllerId:nil];
    ProfileBtnModel *model5 = [ProfileBtnModel modelWithTitle:@"安全中心" iconName:@"profile_safety" storyBoardName:@"SafeCenter" controllerId:nil];
    ProfileBtnModel *model6 = [ProfileBtnModel modelWithTitle:@"离线观看" iconName:@"profile_offline" storyBoardName:@"VideoCache" controllerId:nil];
    ProfileBtnModel *model7 = [ProfileBtnModel modelWithTitle:@"播放记录" iconName:@"profile_record" storyBoardName:@"PlayRecord" controllerId:nil];
    ProfileBtnModel *model8 = [ProfileBtnModel modelWithTitle:@"设置" iconName:@"setting" storyBoardName:@"Setting" controllerId:nil];
    
    ProfileBtnModel *model9 = [ProfileBtnModel modelWithTitle:@"学习统计" iconName:@"profile_statistics" storyBoardName:@"Statics" controllerId:@"StudyStatisticsViewController"];
    
    //统计分析开发
    BOOL opernPreview = [[NSUserDefaults standardUserDefaults] boolForKey:STATICSOPENVIEW];
    
    if (opernPreview)
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model9, model5, model6, model7, model8 ]];
    }
    else
    {
        [arr addObjectsFromArray:@[ model1, model2, model3, model4, model5, model6, model7, model8 ]];
    }
    
    return arr;
}

@end
