//
//  ProfileView.m
//  MYCS
//app启动图和底部banner图片链接跳转
//  Created by GuiHua on 16/4/27.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ProfileView.h"
#import "ActivityDetailController.h"
#import "DoctorsPageViewController.h"
#import "WebViewDetailController.h"
#import "VCSDetailViewController.h"
#import "OfficePagesViewController.h"
#import "ClassDetailViewController.h"

@implementation ProfileView

////传version参数为返回结果为新版本的格式（增加一个param返回数组）：
//$style1 =['sop','course','class','video','doctor'];  //返回id
//$style2 = ['news','activity'];  //返回 url
//$style3 = ['college'];  //返回 agroup_id，id

+(void)profileWtihParam:(Param *)param
{
    
    if ([param.type isEqualToString:@"sop"])
    {
        [self pushVideoDetailWithID:param.id andType:VCSDetailTypeSOP];
    }
    else if ([param.type isEqualToString:@"course"])
    {
         [self pushVideoDetailWithID:param.id andType:VCSDetailTypeCourse];
    }
    else if ([param.type isEqualToString:@"coursePack"])
    {
        [self pushCoursePackDetailWithURL:param.url];
    }
    else if ([param.type isEqualToString:@"video"])
    {
        [self pushVideoDetailWithID:param.id andType:VCSDetailTypeVideo];
    }
    else if ([param.type isEqualToString:@"doctor"])
    {
        [self pushDoctorDetailWithID:param.id];
    }
    else if ([param.type isEqualToString:@"news"])
    {
        [self pushNewsDetailWithURL:param.url];
    }
    else if ([param.type isEqualToString:@"activity"])
    {
        [self pushToActivityWithURL:param.url];
    }
    else if ([param.type isEqualToString:@"college"])
    {
        [self callBackWithGroupId:param.agroup_id andUid:param.id];
    }else if ([param.type isEqualToString:@"other"])
    {
        [self pushOtherWithURL:param.url];
    }
        

    
}

+(void)pushOtherWithURL:(NSString *)url
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ActivityDetailController *activityVC = [storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailController"];
    
    [activityVC loadRequestWithURL:url showProgressView:YES];
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:activityVC animated:YES];

}

+(void)pushCoursePackDetailWithURL:(NSString *)url
{
    NSArray *infoArr = [url componentsSeparatedByString:@"id="];
    
    ClassDetailViewController * classVC = [[ClassDetailViewController alloc] init];
    
    classVC.shareURL = url;
    
    classVC.coursePackId = infoArr[1];
    
    NSString *systemVersion;
    if (iS_IOS7)
    {
        systemVersion = @"ios7";
    }
    else
    {
        systemVersion = @"ios8Later";
    }
    NSString *urlStr;
    
    if ([AppManager hasLogin])
    {
        User *user = [AppManager sharedManager].user;
        urlStr = [NSString stringWithFormat:@"&userId=%@&userType=%@&staffAdmin=%@&device=%@", user.uid, @(user.userType), user.isAdmin,systemVersion];
    }else
    {
        urlStr = [NSString stringWithFormat:@"&userId=&userType=&staffAdmin=&device=%@",systemVersion];
    }
    
    urlStr = [url stringByAppendingString:urlStr];
    
    [classVC loadRequestWithURL:urlStr showProgressView:YES];
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:classVC animated:YES];
}

+(void)pushToActivityWithURL:(NSString *)url
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ActivityDetailController *activityVC = [storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailController"];
    
    User *user = [AppManager sharedManager].user;
    
    NSString *urlString = [NSString stringWithFormat:@"%@&action=detailApp&userId=%@&userType=%d&backButton=hide", url, user.uid, user.userType];
    
    NSArray *infoArr = [url componentsSeparatedByString:@"id="];
    
    activityVC.activityId = infoArr[1];
    
    [activityVC loadRequestWithURL:urlString showProgressView:YES];
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:activityVC animated:YES];
}

+ (void)pushDoctorDetailWithID:(NSString *)doctorId {
    DoctorsPageViewController *doctorPageVC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorsPageViewController"];
    
    doctorPageVC.uid = doctorId;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:doctorPageVC animated:YES];
}


+ (void)pushNewsDetailWithURL:(NSString *)newUrl {
    WebViewDetailController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewDetailController"];
    
    webVC.urlStr = newUrl;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:webVC animated:YES];
}

+ (void)pushVideoDetailWithID:(NSString *)videoId andType:(VCSDetailType)type{
    //创建视频详情的控制器
    UIStoryboard *vcsSB            = [UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil];
    VCSDetailViewController *vcsVC = [vcsSB instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];
    
    vcsVC.videoId = videoId;
    
    vcsVC.type = type;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vcsVC animated:YES];
}
+ (void)callBackWithGroupId:(NSString *)groupId andUid:(NSString *)uid {
    //医院
    if (groupId.intValue == 183)
    {
        [self showOfficeHomeWithId:uid Type:OfficeTypeHospital IsHospitalOrOffice:YES];
    } //科室
    else if (groupId.intValue == 185)
    {
        [self showOfficeHomeWithId:uid Type:OfficeTypeOffice IsHospitalOrOffice:YES];
    } //企业
    else if (groupId.intValue == 5)
    {
        [self showOfficeHomeWithId:uid Type:OfficeTypeEnterprise IsHospitalOrOffice:NO];
        
    } //实验室用户
    else if (groupId.intValue == 187)
    {
        [self showOfficeHomeWithId:uid Type:OfficeTypeLaboratory IsHospitalOrOffice:NO];
    }
}

//isHospitalOrOffice;//医院和科室为YES其他为NO
+ (void)showOfficeHomeWithId:(NSString *)officeId Type:(OfficeType)type IsHospitalOrOffice:(BOOL)isHospitalOrOffice {
    OfficePagesViewController *pVC = [[UIStoryboard storyboardWithName:@"Office" bundle:nil] instantiateViewControllerWithIdentifier:@"OfficePagesViewController"];
    
    pVC.type               = type;
    pVC.isHospitalOrOffice = isHospitalOrOffice;
    pVC.uid                = officeId;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:pVC animated:YES];
}

@end




