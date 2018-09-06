//
//  ZHWebView.m
//  atest
//
//  Created by AdminZhiHua on 16/3/9.
//  Copyright © 2016年 AdminZhiHua. All rights reserved.
//

#import "ZHWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "MJRefresh.h"

@interface ZHWebViewController () <UINavigationControllerDelegate, UINavigationBarDelegate, NJKWebViewProgressDelegate, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;

///  进度条view
@property (nonatomic, strong) UIProgressView *wkProgressView;

//导航条按钮
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;
@property (nonatomic, strong) UIBarButtonItem *backButtomItem;

//上一次的导航title
@property (nonatomic, strong)NSString *oldTitle;

@end

@implementation ZHWebViewController

- (instancetype)init {
    if ([super init])
    { //初始化属性值
        self.showProgressView = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor                 = [UIColor whiteColor];
    
    //iOS8以前使用UIWebView
    if (!self.isIOS8Later)
    {
        self.webView.delegate = self.progressProxy;
    }
    
    [self.navigationItem setLeftBarButtonItems:@[ self.backButtomItem ] animated:NO];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //隐藏网络状态显示
    [self setNetworkIndicatorVisible:NO];
}

- (void)loadRequestWithURL:(NSString *)urlString showProgressView:(BOOL)isShow {
    self.urlString        = urlString;
    self.showProgressView = isShow;
    [_loadingView removeFromSuperview];
    [_networkAnomalyView removeFromSuperview];
    
    NSURL *url            = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    if (self.isIOS8Later)
    {
        
        [self.wkWebView loadRequest:request];
    }
    else
    {
        [self.webView loadRequest:request];
        
    }
    
    [self.view addSubview:self.loadingView];
}
- (void)loadRequestWithFilePath:(NSString *)filePath showProgressView:(BOOL)isShow {
    self.showProgressView = isShow;
    [_loadingView removeFromSuperview];
    
    NSURL *url            = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    if (self.isIOS8Later)
    {
        [self.wkWebView loadRequest:request];
    }
    else
    {
        
        [self.webView loadRequest:request];
    }
    
    [self.view addSubview:self.loadingView];
}


#pragma mark - Action
//关闭按钮
- (void)closeButtonItemClick:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

//返回按钮
- (void)backButtonItem:(UIButton *)button {
    
    [_networkAnomalyView removeFromSuperview];
    [_loadingView removeFromSuperview];
    
    if ([self canGoBack])
    {
        [self goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Public
- (BOOL)canGoBack {
    return self.isIOS8Later ? [self.wkWebView canGoBack] : [self.webView canGoBack];
}

- (void)goBack {
    self.isIOS8Later ? [self.wkWebView goBack] : [self.webView goBack];
}

- (void)reload {
    self.isIOS8Later ? [self.wkWebView reload] : [self.webView reload];
}

- (void)stopLoading {
    self.isIOS8Later ? [self.wkWebView stopLoading] : [self.webView stopLoading];
}

- (BOOL)canGoForward {
    return self.isIOS8Later ? [self.wkWebView canGoForward] : [self.webView canGoForward];
}

- (void)goForward {
    self.isIOS8Later ? [self.wkWebView goForward] : [self.webView goForward];
}

- (void)headerPullWithCallBack:(void (^)())callBack {
    if (!callBack) return;
    
    if (self.isIOS8Later)
    {
        [self.wkWebView.scrollView addHeaderWithCallback:callBack];
    }
    else
    {
        [self.webView.scrollView addHeaderWithCallback:callBack];
    }
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    //先判断是否显示
    [self.progressView setProgress:progress animated:YES];
    if (progress>0.8)
    {
        [_loadingView removeFromSuperview];
    }
}


#pragma mark - jubgeNetError(判断加载失败)
-(void)jubgeNetError:(NSURLRequest *)request
{
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        NSHTTPURLResponse *tmpresponse = (NSHTTPURLResponse*)response;
        
        if (tmpresponse.statusCode != 200)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.needToChangeNavTitle)
                {
                    self.title = @"网络异常";
                }
                if (self.isIOS8Later)
                {
                    //网页加载失败时，隐藏进度条
                    [self hideWKProgressView];
                    [self.view insertSubview:self.networkAnomalyView aboveSubview:self.wkWebView];
                }
                else
                {
                    //网页加载失败时，隐藏进度条
                    self.progressView.progress = 0;
                    [self.view insertSubview:self.networkAnomalyView aboveSubview:self.webView];
                }
                
                [_loadingView removeFromSuperview];
                
            });
            
        }
        
    }];
    [dataTask resume];
}

#pragma mark - WebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self setNetworkIndicatorVisible:YES];
    
    if ([self.delegate respondsToSelector:@selector(ZHWebViewDidStartLoad:)])
    {
        [self.delegate ZHWebViewDidStartLoad:webView];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    [_networkAnomalyView removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(ZHWebView:shouldStartLoadWithRequest:navigationType:)])
    {
        BOOL isAllow = [self.delegate ZHWebView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
        
        return isAllow;
    }
    
    [self jubgeNetError:request];
    
     return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if([error code] == NSURLErrorCancelled)return;
    
    //通知代理对象
    if ([self.delegate respondsToSelector:@selector(ZHWebView:didFailLoadWithError:)])
    {
        [self.delegate ZHWebView:webView didFailLoadWithError:error];
    }
    
    //网页加载失败时，隐藏进度条
    self.progressView.progress = 0;

    [_loadingView removeFromSuperview];
    [self.webView addSubview:self.networkAnomalyView];
    
    //结束下拉刷新
    [self headerEndRefreshing];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.hidden = NO;
    [self setNavigationControllTitle];
    
    [self updateNavigationItems];
    
    [self setNetworkIndicatorVisible:NO];
    
    //更新URL
    self.urlString = webView.request.URL.absoluteString;
    
    //结束下拉刷新
    [self headerEndRefreshing];
    
    if ([self.delegate respondsToSelector:@selector(ZHWebViewDidFinishLoad:)])
    {
        [self.delegate ZHWebViewDidFinishLoad:webView];
    }
    
    [_loadingView removeFromSuperview];
}


//设置导航条的标题
- (void)setNavigationControllTitle {
    //是否需要设置导航条标题
    if (!self.needToChangeNavTitle) return;
    
    [self evaluatingJavaScriptFromString:@"document.title" completionHandler:^(id content, NSError *error) {
        
        if ([content isKindOfClass:[NSString class]])
        {
            NSString *title = content;
            if (title.length > 10)
            {
                title = [[title substringToIndex:9] stringByAppendingString:@"…"];
            }
            self.oldTitle = title;
            self.title = title;
        }
        
    }];
}

//是否显示网络加载
- (void)setNetworkIndicatorVisible:(BOOL)visible {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:visible];
}

#pragma mark - WKWebView的代理
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self setNetworkIndicatorVisible:YES];
    
    if ([self.delegate respondsToSelector:@selector(ZHWebViewDidStartLoad:)])
    {
        [self.delegate ZHWebViewDidStartLoad:webView];
    }

    [self jubgeNetError:[NSURLRequest requestWithURL:webView.URL]];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self setNavigationControllTitle];
    webView.hidden = NO;
    
    [self updateNavigationItems];
    
    [self setNetworkIndicatorVisible:NO];
    
    //更新URL
    self.urlString = webView.URL.absoluteString;
    
    //结束上拉刷新
    [self headerEndRefreshing];
    
    if ([self.delegate respondsToSelector:@selector(ZHWebViewDidFinishLoad:)])
    {
        [self.delegate ZHWebViewDidFinishLoad:webView];
    }
    
    [_loadingView removeFromSuperview];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    if([error code] == NSURLErrorCancelled)return;
    
    if ([self.delegate respondsToSelector:@selector(ZHWebView:didFailLoadWithError:)])
    {
        [self.delegate ZHWebView:webView didFailLoadWithError:error];
    }
    
    [_loadingView removeFromSuperview];
    [self.wkWebView addSubview:self.networkAnomalyView];
    
    //结束下拉刷新
    [self headerEndRefreshing];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
#pragma clang diagnostic pop
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    BOOL isAllow;
    
    if ([self.delegate respondsToSelector:@selector(ZHWebView:shouldStartLoadWithRequest:navigationType:)])
    {
        isAllow = [self.delegate ZHWebView:webView shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeLinkClicked];
    }
    else
    {
        isAllow = YES;
    }
    
    WKNavigationActionPolicy allow = isAllow ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel;
    
    decisionHandler(allow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(YES);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(NO);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *_Nullable))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.placeholder = defaultText;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// 防止在HTML <a> 中的 target="_blank"不发生响应
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame)
    {
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"])
    {
    }
    if ([keyPath isEqualToString:@"title"])
    {
    }
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.wkProgressView.alpha    = 1;
        self.wkProgressView.progress = self.wkWebView.estimatedProgress;
        if (self.wkWebView.estimatedProgress>0.8)
        {
            [_loadingView removeFromSuperview];
        }
    }
    
    //加载完成
    if (!self.wkWebView.isLoading)
    {
        [self hideWKProgressView];
    }
}

- (void)hideWKProgressView {
    //不显示进度条，返回
    [UIView animateWithDuration:0.5 animations:^{
        self.wkProgressView.alpha = 0;
    }];
}


#pragma mark - 更新NavigationBarItem
- (void)updateNavigationItems {
    if ([self canGoBack])
    {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width            = 1;
        
        [self.navigationItem setLeftBarButtonItems:@[ self.backButtomItem, spaceButtonItem, self.closeButtonItem ] animated:NO];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItems:@[ self.backButtomItem ] animated:NO];
    }
}

#pragma mark - Private
- (void)evaluatingJavaScriptFromString:(NSString *)js completionHandler:(void (^)(id, NSError *))completionHandler {
    if (self.isIOS8Later)
    {
        [self.wkWebView evaluateJavaScript:js completionHandler:^(id content, NSError *error) {
            if (completionHandler)
            {
                completionHandler(content, error);
            }
        }];
    }
    else
    {
        NSString *content = [self.webView stringByEvaluatingJavaScriptFromString:js];
        
        if (completionHandler)
        {
            completionHandler(content, nil);
        }
    }
}

//结束上拉刷新
- (void)headerEndRefreshing {
    if (self.isIOS8Later)
    {
        [self.wkWebView.scrollView headerEndRefreshing];
    }
    else
    {
        [self.webView.scrollView headerEndRefreshing];
    }
}

#pragma mark - Action

#pragma mark - Getter&Setter
- (NJKWebViewProgress *)progressProxy {
    if (!_progressProxy)
    {
        _progressProxy                      = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = (id)self;
        _progressProxy.progressDelegate     = (id)self;
    }
    
    return _progressProxy;
}

- (NJKWebViewProgressView *)progressView {
    if (!_progressView)
    {
        CGFloat progressBarHeight   = 3.0f;
        CGRect navigaitonBarBounds  = self.navigationController.navigationBar.bounds;
        CGRect barFrame             = CGRectMake(0, navigaitonBarBounds.size.height, navigaitonBarBounds.size.width, progressBarHeight);
        _progressView               = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.progressColor = HEXRGB(0xffab65);
        
        [self.view addSubview:_progressView];
        
        [self addConstToProgressView:_progressView webView:self.webView];
    }
    
    return _progressView;
}

- (UIProgressView *)wkProgressView {
    if (!_wkProgressView)
    {
        _wkProgressView = [[UIProgressView alloc] init];
        [self.view addSubview:_wkProgressView];
        
        _wkProgressView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.navigationController.navigationBar.frame), 3);
        
        _wkProgressView.progressTintColor = HEXRGB(0xffab65);
        _wkProgressView.trackTintColor    = [UIColor whiteColor];
        
        [self addConstToProgressView:_wkProgressView webView:self.wkWebView];
    }
    
    return _wkProgressView;
}

//给进度条添加约束
- (void)addConstToProgressView:(UIView *)progressView webView:(UIView *)webView {
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:webView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *constH = [NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:3];
    
    NSLayoutConstraint *constLeft = [NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    
    NSLayoutConstraint *constRight = [NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    [self.view addConstraints:@[ constTop, constLeft, constRight, constH ]];
}

- (UIWebView *)webView {
    if (!_webView)
    {
        UIWebView *webView       = [[UIWebView alloc] init];
        _webView                 = webView;
        _webView.delegate        = (id)self;
        _webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        
        [self addConstrainstToWebView:webView];
    }
    return _webView;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView)
    {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:[self webViewConfiguration]];
        [self.view addSubview:_wkWebView];
        _wkWebView.UIDelegate         = self;
        _wkWebView.navigationDelegate = self;
        
        [self addConstrainstToWebView:_wkWebView];
        
        [self installObserver];
    }
    return _wkWebView;
}

- (WKWebViewConfiguration *)webViewConfiguration {
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    
    configuration.preferences                   = [WKPreferences new];
    configuration.preferences.minimumFontSize   = 10;
    configuration.preferences.javaScriptEnabled = YES;
    
    configuration.processPool = [WKProcessPool new];
    
    configuration.userContentController = [WKUserContentController new];
    [configuration.userContentController addScriptMessageHandler:self name:@"mycs"];
    
    return configuration;
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //    if ([self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)])
    //    {
    //        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    //    }
}

- (void)installObserver {
    
        [self.wkWebView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
        [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

//给WebView添加约束
- (void)addConstrainstToWebView:(UIView *)webView {
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!webView) return;
    
    id topLayoutGuide = self.topLayoutGuide;
    
    NSString *hVFL = @"H:|-(0)-[webView]-(0)-|";
    
    BOOL showNavBar = (BOOL)self.navigationController.navigationBar;
    
    //根据导航条是否显示来处理
    NSString *vVFL;
    if (showNavBar)
    {
        vVFL = @"V:|-(0)-[topLayoutGuide]-(0)-[webView]-(0)-|";
    }
    else
    {
        vVFL = @"V:|-(0)-[webView]-(0)-|";
    }
    
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLayoutGuide, webView)];
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLayoutGuide, webView)];
    
    [webView.superview addConstraints:hConsts];
    [webView.superview addConstraints:vConsts];
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    
    if (self.isIOS8Later)
    {
        self.wkProgressView.progressTintColor = progressColor;
    }
    else
    {
        self.progressView.progressColor = progressColor;
    }
}

- (UIBarButtonItem *)closeButtonItem {
    if (!_closeButtonItem)
    {
        UIButton *closeButton = [[UIButton alloc] init];
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [closeButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        
        [closeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        
        [closeButton sizeToFit];
        
        [closeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        
        [closeButton addTarget:self action:@selector(closeButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [closeButton sizeToFit];
        
        _closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    }
    return _closeButtonItem;
}

- (UIBarButtonItem *)backButtomItem {
    if (!_backButtomItem)
    {
        UIImage *backItemImage   = [[UIImage imageNamed:@"ZHWebView.bundle/back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage *backItemHlImage = [[UIImage imageNamed:@"ZHWebView.bundle/back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIButton *backButton = [[UIButton alloc] init];
        
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        
        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        
        [backButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        
        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        
        [backButton addTarget:self action:@selector(backButtonItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [backButton sizeToFit];
        
        _backButtomItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    
    return _backButtomItem;
}

//网络异常
-(NetworkAnomalyView *)networkAnomalyView
{
    if (!_networkAnomalyView)
    {
        _networkAnomalyView = [NetworkAnomalyView networkAnomalyView];
        _networkAnomalyView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        _networkAnomalyView.closeButton.hidden = self.isHome;
        __weak typeof(self)weakSelf = self;
        _networkAnomalyView.buttonBlock = ^(NetworkAnomalyView * networkAnomalyView, NSInteger index){
            
            [networkAnomalyView removeFromSuperview];
            
            if (index == 0)
            {
                if (weakSelf.isIOS8Later)
                {
                    weakSelf.wkWebView.hidden = YES;
                    [weakSelf.wkWebView.scrollView headerBeginRefreshing];
                }else
                {
                    weakSelf.webView.hidden = YES;
                    [weakSelf.webView.scrollView headerBeginRefreshing];
                }
                
                weakSelf.title = weakSelf.oldTitle;
                [weakSelf loadRequestWithURL:weakSelf.urlString showProgressView:weakSelf.showProgressView];
                
            }else if(index == 1)
            {
                [weakSelf backButtonItem:nil];
            }
            
        };
    }
    
    return _networkAnomalyView;
}

//加载中...
-(LoadingView *)loadingView
{
    if (!_loadingView)
    {
        _loadingView = [LoadingView shareLoadingView];
        _loadingView.frame = CGRectMake(0, 64, self.view.width, self.view.height - 64 - 49);
    }
    return _loadingView;
}
//设置URL时自动加载网页
- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
}

- (void)setShowProgressView:(BOOL)showProgressView {
    _showProgressView = showProgressView;
    
    if (showProgressView)
    {
        if (self.isIOS8Later)
        {
            //            self.wkProgressView.hidden = NO;
            [self.view addSubview:self.wkProgressView];
            [self.view bringSubviewToFront:self.wkProgressView];
        }
        else
        {
            //            self.progressView.hidden = NO;
            [self.view addSubview:self.progressView];
            [self.view bringSubviewToFront:self.progressView];
        }
    }
    else
    {
        if (self.isIOS8Later)
        {
            //            self.wkProgressView.hidden = YES;
            [self.wkProgressView removeFromSuperview];
        }
        else
        {
            //            self.progressView.hidden = YES;
            [self.progressView removeFromSuperview];
        }
    }
}

- (BOOL)isIOS8Later {
    if (!_iOS8Later)
    {
        CGFloat sysVersion = [[UIDevice currentDevice].systemVersion floatValue];
        _iOS8Later         = sysVersion >= 8.0;
        //        _iOS8Later         = NO;
    }
    return _iOS8Later;
}

-(void)setIsHome:(BOOL)isHome
{
    _isHome = isHome;
}

- (void)dealloc {
    if (_wkWebView)
    {
        [self.wkWebView removeObserver:self forKeyPath:@"loading"];
        [self.wkWebView removeObserver:self forKeyPath:@"title"];
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    
    NSLog(@"ZHWebViewController销毁");
}

@end
