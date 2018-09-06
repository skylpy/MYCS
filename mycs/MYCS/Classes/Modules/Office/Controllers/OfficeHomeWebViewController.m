//
//  OfficeHomeWebViewController.m
//  MYCS
//
//  Created by money on 16/4/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "OfficeHomeWebViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "OfficePagesViewController.h"

@interface OfficeHomeWebViewController () <ZHWebViewControllerDelegate, JavaScriptObjectiveCPageDelegate>

@property (nonatomic, strong) JSContext *jsContext;

@property (assign, nonatomic) BOOL firstTime;

@end

@implementation OfficeHomeWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.firstTime = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.fd_prefersNavigationBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置代理
    self.delegate = self;
    
    self.jsContext = [[JSContext alloc] init];
    
    ///下拉刷新
    [self headerPullWithCallBack:^{
       
        AFNetworkReachabilityStatus status = [AppManager sharedManager].status;
        BOOL hasNetWork = (status!=AFNetworkReachabilityStatusUnknown&&status!=AFNetworkReachabilityStatusNotReachable);
        if (hasNetWork)
        {
            [self loadRequestWithURL:self.urlString showProgressView:YES];
        }
        [self headerEndRefreshing];
        
    }];
}

- (void)ZHWebViewDidFinishLoad:(id)webView {
    if ([webView isKindOfClass:[UIWebView class]])
    {
        self.jsContext          = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        self.jsContext[@"mycs"] = self;
    }
}

///WebView 调用方法
- (void)homePageWithGroupId:(NSString *)groupId andUid:(NSString *)uid {
    if (!uid) return;

    [self jsCallBackWithGroupId:groupId andUid:uid];
}

///wkWebView 调用方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"mycs"])
    {
        NSString *groupId = [message.body[@"body"] objectForKey:@"groupId"];
        NSString *uid     = [message.body[@"body"] objectForKey:@"uid"];
        if (!uid)
        {
            return;
        }
        
        [self jsCallBackWithGroupId:groupId andUid:uid];
    }
}

- (void)jsCallBackWithGroupId:(NSString *)groupId andUid:(NSString *)uid {
    
    if (self.firstTime == NO)return;//阻止两次跳转
    
    self.firstTime = NO;
    
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
- (void)showOfficeHomeWithId:(NSString *)officeId Type:(OfficeType)type IsHospitalOrOffice:(BOOL)isHospitalOrOffice {
    OfficePagesViewController *pVC = [[UIStoryboard storyboardWithName:@"Office" bundle:nil] instantiateViewControllerWithIdentifier:@"OfficePagesViewController"];
    
    pVC.type               = type;
    pVC.isHospitalOrOffice = isHospitalOrOffice;
    pVC.uid                = officeId;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:pVC animated:YES];
}

@end
