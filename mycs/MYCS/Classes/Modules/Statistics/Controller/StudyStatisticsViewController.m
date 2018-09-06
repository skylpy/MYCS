//
//  StudyStatisticsViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/4/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "StudyStatisticsViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "DatePickerView.h"

@interface StudyStatisticsViewController ()<ZHWebViewControllerDelegate,JavaScriptStudyStaticsDeleagte>

@property (nonatomic, strong) JSContext *jsContext;

@property (assign, nonatomic) BOOL firstTime;

@end

@implementation StudyStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.title = @"考核记录";
    
    //加载网页
    [self loadRequestWithURL:[self requestURL] showProgressView:YES];
    
    
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.firstTime = YES;
    
    self.needToChangeNavTitle          = YES;
    self.fd_prefersNavigationBarHidden = NO;
}

//获取请求的连接地址
- (NSString *)requestURL {
    NSString *userId  = [AppManager sharedManager].user.uid;
    UserType type     = [AppManager sharedManager].user.userType;
    NSString *isAdmin = [AppManager sharedManager].user.isAdmin;
    NSString *systemVersion;
    if (iS_IOS7)
    {
        systemVersion = @"ios7";
    }
    else
    {
        systemVersion = @"ios8Later";
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://mycsapi.mycs.cn/taskStatisList.php?action=index&userId=%@&userType=%@&staffAdmin=%@&device=%@", userId, @(type), isAdmin, systemVersion];
    
    return urlStr;
    
}

#pragma mark - ZHWebViewControllerDelegate
-(void)ZHWebViewDidFinishLoad:(id)webView
{
    if ([webView isKindOfClass:[UIWebView class]])
    {
        self.jsContext          = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        self.jsContext[@"mycs"] = self;
    }
}

#pragma mark - WkWebview Delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"mycs"])
    {
        if (message.body[@"body"])
        {
            NSString * type = [message.body[@"body"] objectForKey:@"type"];
            
            if ([type isEqualToString:@"date"])
            {
                [self showDatePickerView];
            }
            
        }
    }
}

#pragma mark - UIWebview Delegate
-(void)selectTime
{
    if (!self.firstTime)return;
    
    self.firstTime = NO;
    [self showDatePickerView];
}


-(void)showDatePickerView
{
    [DatePickerView showInView:self WithBlock:^(NSString *dateStr) {
        
        self.firstTime = YES;
        if (!dateStr)return;
        
        NSString *jsFunctStr = [NSString stringWithFormat:@"getUserDate('%@')",dateStr];
        
        if (self.isIOS8Later)
        {
            [self.wkWebView evaluateJavaScript:jsFunctStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                
                NSLog(@"response: %@ error: %@", response, error);
            }];
            
        }else
        {
            [self.jsContext evaluateScript:jsFunctStr];
            
        }
    }];
    
}

@end














