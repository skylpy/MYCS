//
//  ZHWebView.h
//  atest
//
//  Created by AdminZhiHua on 16/3/9.
//  Copyright © 2016年 AdminZhiHua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "LoadingView.h"
#import "NetworkAnomalyView.h"

@protocol ZHWebViewControllerDelegate <NSObject>

@optional
//去除iOS9的非空警告
- (BOOL)ZHWebView:(id)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)ZHWebViewDidStartLoad:(id)webView;
- (void)ZHWebView:(id)webView didFailLoadWithError:(NSError *)error;
- (void)ZHWebViewDidFinishLoad:(id)webView;
////wkWebView 调用OC方法
//- (void)ZHUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;
//

@end


@interface ZHWebViewController : UIViewController

//是否是首页
@property (nonatomic, assign) BOOL isHome;

//iOS7属性
@property (nonatomic, strong) UIWebView *webView;

//iOS8以后的属性
@property (nonatomic, strong) WKWebView *wkWebView;

//进度条的颜色
@property (nonatomic, strong) UIColor *progressColor;

//判断是否是iOS8以后的版本
@property (nonatomic, assign, getter=isIOS8Later) BOOL iOS8Later;

@property (nonatomic, weak) id<ZHWebViewControllerDelegate> delegate;

///  当前网页的RUL,当网页加载完成会显示
@property (nonatomic, copy) NSString *urlString;

//是否显示进度条
@property (nonatomic, assign, getter=isShowProgressView) BOOL showProgressView;

//是否重新设置导航条的标题
@property (nonatomic, assign) BOOL needToChangeNavTitle;

//网络异常View
@property (nonatomic, strong) NetworkAnomalyView * networkAnomalyView;

//加载中View
@property (nonatomic, strong) LoadingView * loadingView;

//下拉刷新的回调
- (void)headerPullWithCallBack:(void (^)())callBack;

//加载网络请求
- (void)loadRequestWithURL:(NSString *)urlString showProgressView:(BOOL)isShow;

//加载本地网页
- (void)loadRequestWithFilePath:(NSString *)filePath showProgressView:(BOOL)isShow;

//执行js
- (void)evaluatingJavaScriptFromString:(NSString *)js completionHandler:(void (^)(id content, NSError *error))completionHandler;


- (BOOL)canGoBack;

- (void)goBack;

- (BOOL)canGoForward;

- (void)goForward;

- (void)reload;

///  停止加载网页
- (void)stopLoading;

//结束上拉刷新
- (void)headerEndRefreshing;

@end
