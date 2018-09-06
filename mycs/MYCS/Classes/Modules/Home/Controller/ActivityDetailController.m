//
//  ActivityDetailController.m
//  MYCS
//
//  Created by wzyswork on 16/3/30.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ActivityDetailController.h"
#import "MJExtension.h"
#import "NSString+Util.h"
#import "VCSDetailViewController.h"
#import "DoctorsPageViewController.h"

#import "SDWebImageManager.h"
#import "UMengHelper.h"
#import <UMSocial.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ClassDetailViewController.h"

@interface ActivityDetailController () <UMSocialUIDelegate, ZHWebViewControllerDelegate>

@property (nonatomic, strong) UIImage *shareImage;

@property (nonatomic, strong) ActivityParamModel *model;

@property (nonatomic,strong) UIButton * backButton;

@end

@implementation ActivityDetailController

-(UIButton *)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(15, 18, 40, 40);
        _backButton.layer.cornerRadius = 10;
        _backButton.clipsToBounds = YES;
        _backButton.alpha = 0.6;
        _backButton.backgroundColor = [UIColor blackColor];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(closePage) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate             = self;
    self.needToChangeNavTitle = NO;
    
    if (self.iOS8Later)
    {
        [self.wkWebView addSubview:self.backButton];
    }else
    {
        [self.webView addSubview:self.backButton];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)setActivityId:(NSString *)activityId
{
    _activityId = activityId;
}
//如果没有默认的分享，下载分享图片
- (void)downloadShareImage {
    if (!self.shareImage)
    {
        [self evaluatingJavaScriptFromString:@"document.getElementsByTagName('shareImage')." completionHandler:^(id content, NSError *error) {
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:content] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (image && finished)
                {
                    self.shareImage = image;
                }
                
            }];
            
        }];
    }
}

//根据js获取网页的内容
- (NSString *)getContent:(UIWebView *)webView jsStr:(NSString *)js {
    NSString *content = [webView stringByEvaluatingJavaScriptFromString:js];
    
    NSLog(@"%@==", content);
    
    return content;
}

/*!
 *   @author wzyswork, 16-03-30 12:03:03
 *
 *   @brief ZHWebViewControllerDelegate
 *
 *   @param webView
 */
- (void)ZHWebViewDidFinishLoad:(id)webView {
    [self downloadShareImage];
}


/**
 * ZHWebViewControllerDelegate  html页面的js动作触发时运行的代理方法
 *
 *当网页视图被指示载入内容而得到通知。应当返回YES，这样会进行加载。
 *通过导航类型参数可以得到请求发起的原因，可以是以下任意值：
 *
 */
- (BOOL)ZHWebView:(id)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr = request.URL.absoluteString;
    NSRange range    = [urlStr rangeOfString:@"@mycs"];
    
    if (range.length > 0)
    {
        NSString *infoStr = [urlStr substringFromIndex:range.location];
        
        NSArray *infoArr = [infoStr componentsSeparatedByString:@"?"];
        
        
        NSLog(@"urlStr :%@ =======   %@   =======%@", urlStr, infoStr, infoArr);
        
        NSString *funName;
        if ([infoArr[1] isEqualToString:@"closePage"])
        {
            funName = [NSString stringWithFormat:@"%@", infoArr[1]];
        }
        else
        {
            funName = [NSString stringWithFormat:@"%@:", infoArr[1]];
        }
        //这个方法是上个方法的补充，也是动态加载实例方法。
        SEL callFun = NSSelectorFromString(funName);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (![infoArr[1] isEqualToString:@"closePage"])
        {
            [self performSelector:callFun withObject:infoArr[2]];
        }
        else
        {
            [self performSelector:callFun withObject:nil];
        }
#pragma clang diagnostic pop
        
        return NO;
    }
    
    return YES;
}
- (void)closePage {
    
    if ([self canGoBack])
    {
        [self goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//----------------分享活动 -----------------------
- (void)shareActivity:(NSString *)base64Str {
    if (![self isLogin]) return;
    
    ActivityParamModel *model = [self decodeWithBase64:base64Str];
    
    self.model = model;
    
    //弹出分享界面
    [UMengHelper shareWith:model.title content:model.describe shareUrl:model.linkUrl shareImage:self.shareImage viewController:self];
}


//----------------参加活动 -----------------------
- (void)joinActivity:(NSString *)base64Str {
    if (![self isLogin]) return;
    
    ActivityParamModel *model = [self decodeWithBase64:base64Str];
    
    [ActivityModel joinActivityWith:[AppManager sharedManager].user.uid activityId:model.activityId success:^{
        
        [self reload];
        
    }
                            failure:^(NSError *error) {
                                
                                [self showError:error];
                            }];
}
//-----------------跳转到课程页 -------------------
- (void)go2CoursePackPage:(NSString *)base64Str {
    
    ActivityParamModel *model = [self decodeWithBase64:base64Str];
    
    NSArray *infoArr = [model.videoId componentsSeparatedByString:@"id="];
    
    ClassDetailViewController * classVC = [[ClassDetailViewController alloc] init];
    
    classVC.shareURL = model.videoId;
    
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
    
    urlStr = [model.videoId stringByAppendingString:urlStr];
    
    [classVC loadRequestWithURL:urlStr showProgressView:YES];
    
    classVC.activity = YES;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:classVC animated:YES];
}

//-----------------跳转到播放视频页 -------------------
- (void)go2VideoDetailPage:(NSString *)base64Str {
    NSLog(@"base64Str ==  %@", base64Str);
    ActivityParamModel *model = [self decodeWithBase64:base64Str];
    
    [self modalVideoDetailWithIdentify:@"VCSDetailViewController" videoID:model.videoId type:1];
}

//-----------------跳转到播放教程页页 -------------------
- (void)go2CourseDetailPage:(NSString *)base64Str {
    ActivityParamModel *model = [self decodeWithBase64:base64Str];
    
    [self modalVideoDetailWithIdentify:@"VCSDetailViewController" videoID:model.videoId type:2];
}

//-----------------跳转到播放SOP页 -------------------
- (void)go2SopDetailPage:(NSString *)base64Str {
    ActivityParamModel *model = [self decodeWithBase64:base64Str];
    
    [self modalVideoDetailWithIdentify:@"VCSDetailViewController" videoID:model.videoId type:3];
}


- (void)modalVideoDetailWithIdentify:(NSString *)identifier videoID:(NSString *)videoId type:(int)type {
    UIStoryboard *storyboard            = [UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil];
    VCSDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
    
    controller.activityId = self.activityId;
    controller.videoId  = videoId;
    controller.type     = type;
    controller.activity = YES;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
}

//-----------------跳转到医生主页 -------------------
- (void)go2DoctorHomePage:(NSString *)base64Str {
    ActivityParamModel *model = [self decodeWithBase64:base64Str];
    
    DoctorsPageViewController *doctorVC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorsPageViewController"];
    
    doctorVC.uid = model.uid;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:doctorVC animated:YES];
}

//base64解码
- (ActivityParamModel *)decodeWithBase64:(NSString *)base64Str {
    NSData *data      = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    ActivityParamModel *model = [ActivityParamModel objectWithKeyValues:jsonStr];
    
    return model;
}

- (BOOL)isLogin {
    if (![AppManager hasLogin])
    {
        UIStoryboard *loginSB     = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *loginVC = [loginSB instantiateInitialViewController];
        
        [[AppDelegate sharedAppDelegate].rootNavi presentViewController:loginVC animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}


///分享成功返回的代理方法
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if (response.responseCode == 200) //分享成功
    {
        [ActivityModel shareCompleteWith:[AppManager sharedManager].user.uid activityId:self.model.activityId success:^{
            
            [self reload];
            
        }
                                 failure:^(NSError *error) {
                                     
                                     [self showError:error];
                                     
                                 }];
    }
}

@end
