//
//  ActivityHomeWebViewController.m
//  MYCS
//
//  Created by money on 16/4/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ActivityHomeWebViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "ActivityDetailController.h"
#import "ActivityModel.h"

@interface ActivityHomeWebViewController () <ZHWebViewControllerDelegate>

@end

@implementation ActivityHomeWebViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UMAnalyticsHelper beginLogPageName:@"活动"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UMAnalyticsHelper endLogPageName:@"活动"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadRequestWithURL:@"http://www.mycs.cn/app/mobileweb/activity.php?action=indexApp" showProgressView:YES];
    
    self.delegate = self;
    
    
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

- (BOOL)ZHWebView:(id)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr = request.URL.absoluteString;
    NSRange range    = [urlStr rangeOfString:@"@mycs"];
    
    if (range.length > 0)
    {
        NSString *infoStr = [urlStr substringFromIndex:range.location];
        
        NSArray *infoArr = [infoStr componentsSeparatedByString:@"?"];
        
        NSString *funName = [NSString stringWithFormat:@"%@:", infoArr[1]];
        
        SEL callFun = NSSelectorFromString(funName);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [self performSelector:callFun withObject:infoArr[2]];
        
#pragma clang diagnostic pop
        
        return NO;
    }
    
    return YES;
}

//活动详情
- (void)go2ActivityDetailPage:(NSString *)base64Str {
    ActivityParamModel *model = [self decodeWithBase64:base64Str];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ActivityDetailController *activityVC = [storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailController"];
    
    self.navigationController.navigationBarHidden = YES;
    
    NSArray *infoArr = [model.url componentsSeparatedByString:@"id="];
    
    activityVC.activityId = infoArr[1];
    
    [activityVC loadRequestWithURL:[self detailURL:model] showProgressView:YES];
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:activityVC animated:YES];
}


- (NSString *)detailURL:(ActivityParamModel *)model {
    User *user = [AppManager sharedManager].user;
    
    NSString *paramStr = [NSString stringWithFormat:@"&userId=%@&userType=%d&backButton=hide", user.uid, user.userType];
    
    NSString *urlStr = [model.url stringByAppendingString:paramStr];
    
    return urlStr;
}

//base64解码
- (ActivityParamModel *)decodeWithBase64:(NSString *)base64Str {
    NSData *data      = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    ActivityParamModel *model = [ActivityParamModel objectWithKeyValues:jsonStr];
    
    return model;
}
@end
