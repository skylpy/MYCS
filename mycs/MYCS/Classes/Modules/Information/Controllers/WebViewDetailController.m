//
//  WebViewDetailController.m
//  MYCS
//
//  Created by wzyswork on 16/2/3.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "WebViewDetailController.h"
#import "InfomationModel.h"
#import "UMengHelper.h"
#import "SDWebImageManager.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ProfileView.h"

@interface WebViewDetailController () <ZHWebViewControllerDelegate>

//分享的内容
@property (nonatomic, copy) NSString *shareContent;
//分享的标题
@property (nonatomic, copy) NSString *shareTitle;

@end

@implementation WebViewDetailController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.needToChangeNavTitle          = YES;
    self.fd_prefersNavigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"名医资讯";
    
    //设置代理
    self.delegate = self;
    
    //添加分享按钮
    UIBarButtonItem *rightBarButtonItem    = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(responseRightButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //开始加载网页
    [self loadRequestWithURL:self.urlStr showProgressView:YES];
}

-(void)setIsCollege:(BOOL)isCollege
{
    _isCollege = isCollege;
}

#pragma mark - *** shareAction ***
- (void)responseRightButton {
    //获取要分享的属性
    NSString *shareURL = [self getShareURLStr];
    
    if (self.shareContent == nil || [self.shareContent isEqualToString:@""])
    {
        self.shareContent = @"名医传世资讯";
    }
    
    if (self.shareTitle == nil || [self.shareTitle isEqualToString:@""])
    {
        self.shareTitle = @"名医传世资讯";
    }
    
    [UMengHelper shareWith:self.shareTitle content:self.shareContent shareUrl:shareURL shareImage:self.shareImage viewController:self];
}

#pragma mark - *** 获取分享链接 ***
- (NSString *)getShareURLStr {
    //分享的链接
    NSRange idRange = [self.urlString rangeOfString:@"id="];
    
    if (idRange.location == NSNotFound)
    {
        return self.urlString;
    }
    
    NSString *idStr = [self.urlString substringFromIndex:idRange.location + idRange.length];
    
    NSString *shareURL;
    if (self.isCollege)
    {
        shareURL = [@"http://m.mycs.cn/app/mobileweb/enterpriseNewsWap.php?id=" stringByAppendingString:idStr];
    }else
    {
        shareURL = [@"http://www.mycs.cn/app/mobileweb/mobileNews.php?id=" stringByAppendingString:idStr];
    }
    
    return shareURL;
}

#pragma mark - *** 获取分享内容 ***
- (NSString *)getContent:(UIWebView *)webView jsStr:(NSString *)js {
    NSString *content = [webView stringByEvaluatingJavaScriptFromString:js];
    
    return content;
}

#pragma mark - *** UIWebView Delegate ***
- (void)ZHWebViewDidFinishLoad:(id)webView {
    //允许右边的按钮交互
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    //下载分享的图片
    [self downloadShareImage];
    
    __weak typeof(self) weakSelf = self;
    //获取页面的描述
    [self evaluatingJavaScriptFromString:@"document.getElementsByName('description')[0].content" completionHandler:^(id content, NSError *error) {
        weakSelf.shareContent = content;
    }];
    
    //获取页面的标题
    [self evaluatingJavaScriptFromString:@"document.title" completionHandler:^(id content, NSError *error) {
        weakSelf.shareTitle = content;
    }];
}
- (BOOL)ZHWebView:(id)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr = request.URL.absoluteString;
    
    if ([urlStr hasPrefix:@"http://www.mycs.cn/app/android/news.php?id="] || [urlStr hasPrefix:@"http://www.swwy.com/app/mobileweb/enterpriseNews.php?id="] || urlStr == nil) {
        
        return YES;
    }
    
    [self.navigationController.view addSubview:self.loadingView];
    self.loadingView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    [Param InformationClickWithCheckUrl:urlStr success:^(Param *pama) {
        
        if ([pama.type isEqualToString:@"news"])
        {
            [self loadRequestWithURL:pama.url showProgressView:YES];
            [self.loadingView removeFromSuperview];
        }
        else
        {
            [ProfileView profileWtihParam:pama];
            [self.loadingView removeFromSuperview];
        }
        
    } failure:^(NSError *error) {
        
        [self.loadingView removeFromSuperview];
        
    }];
    
    return NO;
}

//如果没有默认的分享，下载分享图片
- (void)downloadShareImage {
    //如果外界没有传递参数，则下载图片
    if (!self.shareImage)
    {
        [self evaluatingJavaScriptFromString:@"document.getElementsByTagName('img')[0].src" completionHandler:^(id content, NSError *error) {
            [self downloadImage:content];
        }];
    }
}

- (void)downloadImage:(NSString *)imageURL {
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if (image && finished)
        {
            self.shareImage = image;
        }
        
    }];
}

@end
