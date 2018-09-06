//
//  StaticsViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/3/16.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "StaticsViewController.h"
#import "ConstKeys.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "PreviewStatusTool.h"
#import "SelectDeptView.h"
#import "DatePickerView.h"

@interface StaticsViewController () <ZHWebViewControllerDelegate,JavaScriptStaticsDeleagte>

@property (nonatomic, assign, getter=isOpenView) BOOL openView;

@property (nonatomic, strong) JSContext *jsContext;

@property (assign, nonatomic) BOOL firstTime;

@end

@implementation StaticsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.firstTime = YES;
    
    self.needToChangeNavTitle          = YES;
    self.fd_prefersNavigationBarHidden = NO;
    
    [UMAnalyticsHelper beginLogPageName:@"统计分析"];
    
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [UMAnalyticsHelper endLogPageName:@"统计分析"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor                 = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置代理
    self.delegate = self;
    
    self.title = @"统计分析";
    
    //文件配置
    [self fileOperation];
    
    //开始加载网页
    AFNetworkReachabilityStatus status = [AppManager sharedManager].status;
    BOOL hasNetWork = (status!=AFNetworkReachabilityStatusUnknown&&status!=AFNetworkReachabilityStatusNotReachable);
    if (hasNetWork)
    {
        [self loadLocalHtmlWith:[self requestURL]];
    }
    else
    {
        [self loadRequestWithURL:[self requestURL] showProgressView:YES];
    }
    
    [self headerPullWithCallBack:^{
        
        if (hasNetWork)
        {
            [self loadRequestWithURL:self.urlString showProgressView:YES];
        }
        [self headerEndRefreshing];
        
    }];
    
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
    NSString *urlStr;
    if ([AppManager sharedManager].user.agroup_id.integerValue == 9) {
    
        urlStr = [NSString stringWithFormat:@"http://mycsapi.mycs.cn/taskStatisList.php?action=totallList&userId=%@&userType=%@&staffAdmin=%@&device=%@&type=2&agroup_id=9", userId, @(type), isAdmin,systemVersion];
    }
    else if ([AppManager sharedManager].user.agroup_id.integerValue == 10) {
        
        urlStr = [NSString stringWithFormat:@"http://mycsapi.mycs.cn/taskStatisList.php?action=baseTotallList&userId=%@&userType=%@&staffAdmin=%@&device=%@&agroup_id=10", userId, @(type), isAdmin,systemVersion];
    }
    else{
    
        urlStr = [NSString stringWithFormat:@"http://mycsapi.mycs.cn/taskStatisList.php?action=totallList&userId=%@&userType=%@&staffAdmin=%@&device=%@", userId, @(type), isAdmin,systemVersion];
    }
   
    
    return urlStr;
}

- (void)loadLocalHtmlWith:(NSString *)url {
    //根据连接下载HTML源码
    [self requestHtmlWithURL:url complete:^(NSString *htmlString) {
        
        NSString *replaceStr = [self replaceLoacalJSAndCSS:htmlString];
        
        NSString *staticPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"static"];
        
        NSString *filePath = [staticPath stringByAppendingPathComponent:@"temp.html"];
        
        //将html文件保存到本地
        [replaceStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //加载本地HTML
            [self loadRequestWithFilePath:filePath showProgressView:YES];
            
        });
        
    }];
}

//将网络的ionic.bundle.min.js和ionic.min.css替换成为本地文件
- (NSString *)replaceLoacalJSAndCSS:(NSString *)htmlStr {
    NSString *html;
    html = [htmlStr stringByReplacingOccurrencesOfString:@"http://code.ionicframework.com/1.2.4/css/ionic.min.css" withString:@"./ionic.min.css"];
    
    html = [html stringByReplacingOccurrencesOfString:@"http://code.ionicframework.com/1.2.4/js/ionic.bundle.min.js" withString:@"./ionic.bundle.min.js"];
    
    return html;
}

- (void)requestHtmlWithURL:(NSString *)urlStr complete:(void (^)(NSString *htmlString))completeBlock {
    //根据url下载内容
    NSURL *url            = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *_Nullable response, NSData *_Nullable data, NSError *_Nullable connectionError) {
        
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (completeBlock)
        {
            completeBlock(string);
        }
        
    }];
}

- (void)fileOperation {
    //对本地文件进行操作
    //1、在tmp目录下，创建static文件夹
    //2、ionic.bundle.min.js、ionic.min.css拷贝到tmp文件夹下
    NSString *staticPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"static"];
    
    if (![self fileExitAtPath:staticPath])
    {
        [self createDocumentAtPath:staticPath];
    }
    
    if (![self fileExitAtStaticPathWith:@"ionic.bundle.min.js"])
    {
        [self copyFileToStaticTempPathWith:@"ionic.bundle.min.js"];
    }
    
    if (![self fileExitAtStaticPathWith:@"ionic.min.css"])
    {
        [self copyFileToStaticTempPathWith:@"ionic.min.css"];
    }
}

- (BOOL)copyFileToStaticTempPathWith:(NSString *)fileName {
    //获取bundle的路劲文件
    NSString *fileBundlePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    //判断文件是否存在static缓存路劲
    NSString *staticPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"static"];
    
    NSString *destPath = [staticPath stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    return [fileManage copyItemAtPath:fileBundlePath toPath:destPath error:nil];
}

- (BOOL)fileExitAtStaticPathWith:(NSString *)fileName {
    //判断文件是否存在static缓存路劲
    NSString *staticPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"static"];
    
    NSString *filePath = [staticPath stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    return [fileManage fileExistsAtPath:filePath];
}

- (BOOL)fileExitAtPath:(NSString *)filePath {
    //判断文件是否存在
    NSFileManager *manage = [NSFileManager defaultManager];
    
    return [manage fileExistsAtPath:filePath];
}

- (BOOL)createDocumentAtPath:(NSString *)path {
    NSFileManager *manage = [NSFileManager defaultManager];
    
    return [manage createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

- (BOOL)string:(NSString *)string contailString:(NSString *)containStr {
    NSRange range = [string rangeOfString:containStr];
    
    return (range.location != NSNotFound) ? YES : NO;
}

#pragma mark - WkWebview Delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"mycs"])
    {
        
        if (message.body[@"body"])
        {
            NSString * type = [message.body[@"body"] objectForKey:@"type"];
            
            if ([type isEqualToString:@"dept"])
            {
                [self pushSelectDeptViewWithDeptId:[message.body[@"body"] objectForKey:@"deptId"]];
            }
            else if ([type isEqualToString:@"date"])
            {
                [self showDatePickerView];
            }
            
        }
    }
}


#pragma mark - ZHWebViewControllerDelegate
-(void)ZHWebViewDidFinishLoad:(id)webView
{
    NSLog(@"%@",self.urlString);
    if ([webView isKindOfClass:[UIWebView class]])
    {
        self.jsContext = [[JSContext alloc] init];
        
        self.jsContext          = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        self.jsContext[@"mycs"] = self;
    }
}

#pragma mark - UIWebview Delegate
-(void)selectDept:(NSString *)deptId
{
    
    [self pushSelectDeptViewWithDeptId:deptId];
}
#pragma mark - UIWebview Delegate
-(void)selectTime
{
    
    [self showDatePickerView];
}

#pragma mark - DatePickerView
-(void)showDatePickerView
{
    if (!self.firstTime)return;
    
    self.firstTime = NO;
    
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

#pragma mark - Dept Select Controller
-(void)pushSelectDeptViewWithDeptId:(NSString *)deptId
{
    if (!self.firstTime)return;
    
    self.firstTime = NO;
    
   NSString * govType = [self returnsGovType:self.urlString];
    
    [SelectDeptView showInView:self WithCurrentDeptId:deptId andGovType:govType  WithBlock:^(NSString *deptId, NSString *deptName) {
        
        NSString *jsFunctStr = [NSString stringWithFormat:@"getUserDept('%@','%@')",deptId,deptName];
        
        self.firstTime = YES;
        
        if (!deptId)return;
        
        if (self.iOS8Later)
        {
            [self.wkWebView evaluateJavaScript:jsFunctStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                NSLog(@"response: %@ error: %@", response, error);
                
            }];
            
        }
        else
        {
            [self.jsContext evaluateScript:jsFunctStr];
        }
        
    }];
}

//截取字符串
-(NSString *)returnsGovType:(NSString *)urlStr{

    NSString * str;
    if ([AppManager sharedManager].user.agroup_id.integerValue == 9) {
        
        NSRange range = [urlStr rangeOfString:@"govType="];//匹配得到的下标
        str = [urlStr substringWithRange:NSMakeRange(range.location+range.length,1)];//截取范围类的字符串
        
        NSLog(@"截取的值为：%@",str);
    }
    
    return str;
}

@end

























