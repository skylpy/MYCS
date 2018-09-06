//
//  ClassDetailViewController.m
//  MYCS
// 课程详情
//  Created by GuiHua on 16/4/27.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ClassDetailViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "SDWebImageManager.h"
#import "UMengHelper.h"
#import "DoctorsPageViewController.h"
#import "VideoDetail.h"
#import "MediaPlayerViewController.h"
#import "CoursePackModel.h"
#import "PlayRecordModel.h"
#import "UIWebView+AccessoryHiding.h"
#import "WKWebView+AccessoryHiding.h"
#import "UMSocialControllerService.h"
#import "UIAlertView+Block.h"
@interface ClassDetailViewController ()<ZHWebViewControllerDelegate,JavaScriptObjectiveCClassDetailDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) JSContext *jsContext;

@property (nonatomic,strong) UIButton * backButton;
//分享图片
@property (nonatomic, strong) UIImage *shareImage;
//分享的内容
@property (nonatomic, copy) NSString *shareContent;
//分享的标题
@property (nonatomic, copy) NSString *shareTitle;

//是否预览
@property (nonatomic, assign, getter=isPreview) BOOL preview;
//预览提示
@property (nonatomic, copy) NSString *vipTips;

@property (nonatomic, strong) NSArray * coursePackArray;

@property (assign, nonatomic) BOOL firstTime;

@end

@implementation ClassDetailViewController

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
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.firstTime = YES;
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate             = self;
    self.needToChangeNavTitle = NO;
    
    self.jsContext = [[JSContext alloc] init];
    
    if (self.iOS8Later)
    {
        [self.wkWebView addSubview:self.backButton];
        self.wkWebView.hackishlyHidesInputAccessoryView = YES;//隐藏WKwebView上键盘上的toolBar
        self.wkWebView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }else
    {
        [self.webView addSubview:self.backButton];
        self.webView.hackishlyHidesInputAccessoryView = YES;//隐藏webView上键盘上的toolBar
        self.webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    
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

-(void)setCoursePackId:(NSString *)coursePackId
{
    _coursePackId = coursePackId;
    [self getCoursePackArray];
}
-(void)setActivityId:(NSString *)activityId
{
    _activityId = activityId;
}
-(void)getCoursePackArray
{
    [CoursePackModel requestCoursePackModelWithID:self.coursePackId andIsAjax:1 Success:^(NSArray *list) {
        
        self.coursePackArray = list;
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


//下载分享图片
- (void)downloadShareImage {
    
    [self evaluatingJavaScriptFromString:@"document.getElementsByName('shareImage')[0].value" completionHandler:^(id content, NSError *error) {
        
        NSString *urlStr = (NSString *)content;
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (image && finished)
            {
                self.shareImage = image;
                
            }
            
        }];
        
    }];
    
}

#pragma mark - WebView的代理方法
- (void)ZHWebViewDidFinishLoad:(id)webView {
    if ([webView isKindOfClass:[UIWebView class]])
    {
        self.jsContext          = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        self.jsContext[@"mycs"] = self;
    }
    
    __weak typeof(self) weakSelf = self;
    //获取页面的描述
    [self evaluatingJavaScriptFromString:@"document.getElementsByName('shareContent')[0].content" completionHandler:^(id content, NSError *error) {
        weakSelf.shareContent = content;
    }];
    
    //获取页面的标题
    [self evaluatingJavaScriptFromString:@"document.getElementById('courseTitle').innerHTML" completionHandler:^(id content, NSError *error) {
        weakSelf.shareTitle = content;
    }];
    
    //下载分享的图片
    [self downloadShareImage];
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"mycs"])
    {
        
        NSDictionary *dict = message.body[@"body"];
        NSString *type = dict[@"type"];
        NSString *idStr = dict[@"id"];
        if ([type isEqualToString:@"doctor"])
        {
            [self pushDoctorDetailWithID:idStr];
        }
        else if ([type isEqualToString:@"videoDetail"])
        {
            [self getVideoDetailWithId:idStr];
        }
        
    }
}

-(void)call:(NSString *)type withId:(NSString *)idStr
{
    if ([type isEqualToString:@"doctor"])
    {
        [self pushDoctorDetailWithID:idStr];
    }
    else if ([type isEqualToString:@"videoDetail"])
    {
        [self getVideoDetailWithId:idStr];
    }
}

-(void)pushDoctorDetailWithID:(NSString *)doctorId
{
    if (self.firstTime == NO)return;//阻止两次跳转
    
    self.firstTime = NO;
    
    DoctorsPageViewController *doctorPageVC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorsPageViewController"];
    
    doctorPageVC.uid = doctorId;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:doctorPageVC animated:YES];
}

- (BOOL)ZHWebView:(id)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = request.URL.absoluteString;
    NSRange range    = [urlStr rangeOfString:@"@mycs"];
    
    if (range.length > 0)
    {
        NSString *infoStr = [urlStr substringFromIndex:range.location];
        
        NSArray *infoArr = [infoStr componentsSeparatedByString:@"?"];
        
        NSString *funName;
        
        if ([infoArr[1] isEqualToString:@"shareCourse"])
        {
            funName = [NSString stringWithFormat:@"%@", infoArr[1]];
        }
        
        SEL callFun = NSSelectorFromString(funName);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [self performSelector:callFun withObject:nil];
        
#pragma clang diagnostic pop
        
        return NO;
    }
    
    return YES;
}

//分享
- (void)shareCourse
{
    if (self.firstTime == NO)return;//阻止两次跳转
    
    self.firstTime = NO;
    
    [UMengHelper shareWith:self.shareTitle content:self.shareContent shareUrl:self.shareURL shareImage:self.shareImage viewController:self];
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    self.firstTime = YES;
}

-(void)getVideoDetailWithId:(NSString *)idStr
{
    if (self.firstTime == NO)return;//阻止两次跳转
    
    self.firstTime = NO;
    
    [self.navigationController.view addSubview:self.loadingView];
    self.loadingView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    [VideoDetail videoDetailWithUserId:[AppManager sharedManager].user.uid userType:[AppManager sharedManager].user.userType action:@"detail" videoId:idStr activityId:self.activityId fromeCache:YES success:^(VideoDetail *videoDetail) {
        
        [self.loadingView removeFromSuperview];
        
        AFNetworkReachabilityStatus status = [AppManager sharedManager].status;
        //判断是否是非WIFI环境下播放视频
        if ([AppManager sharedManager].WWLANPlayVideoOff && status == AFNetworkReachabilityStatusReachableViaWWAN)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前使用移动网络是否播放视频" cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
            
            [alertView showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                if (buttonIndex == 1)
                {
                    [self showMeidaPlayerVCWithID:idStr and:videoDetail];
                }else
                {
                    self.firstTime = YES;
                }
                
            }];
            return;
        }
        
        [self showMeidaPlayerVCWithID:idStr and:videoDetail];
        
    }failure:^(NSError *error) {
        
        [self.loadingView removeFromSuperview];
        self.firstTime = YES;
        [self showErrorMessage:@"播放失败！"];
    }];
}

-(void)showMeidaPlayerVCWithID:(NSString *)idStr and:(VideoDetail *)videoDetail
{
    [self courseSelectWithId:idStr];
    //不是从活动进来的视频，要检查权限
    if (!self.isActivity)
    {
        [self setPreviewAuthorityWithVideoDetail:videoDetail];
    }
  MediaPlayerViewController *playVC = [MediaPlayerViewController showWith:self coursePackArray:self.coursePackArray videoDetail:videoDetail courseDetail:nil sopDetail:nil chapter:nil DoctorsHealthDetail:nil isTask:NO isPreview:self.preview previewTips:self.vipTips];
    
    playVC.activityId = self.activityId;
    playVC.activity = self.activity;
    //添加到播放记录
    PlayRecordModel *model = [PlayRecordModel playRecordWith:videoDetail.title videoId:idStr picUrl:videoDetail.picurl videoType:@"video"];
    [PlayRecordModel addLocalPlayRecord:model];
    
}
-(void)courseSelectWithId:(NSString *)idStr
{
    
    for (CoursePackModel *packModel in self.coursePackArray)
    {
        for (CoursePackChapter *packChapter in packModel.coursePackChapters)
        {
            if (packChapter.video_id.integerValue == idStr.integerValue)
            {
                packChapter.isSelect = @"1";
            }
            else
            {
                packChapter.isSelect = @"0";
            }
        }
    }
    
}
//设置预览权限
- (void)setPreviewAuthorityWithVideoDetail:(VideoDetail *)videoDetail {
    int extra_permission = videoDetail.extra_permission;;
    BOOL isMember = videoDetail.isMember;
    int buy   = videoDetail.buy;
    self.vipTips = nil;
    self.preview = NO;
    
    //--当前资源的额外权限限制，0--无，1--属于会员套餐，2--无需登录即可播放的资源
    if (extra_permission != 2)
    {
        if ([AppManager hasLogin])
        {
            if (extra_permission == 1)
            {
                if (isMember)
                {
                    //播放
                }
                else
                {
                    self.preview = YES;
                    self.vipTips = @"2分钟预览已结束，观看全部课程请联系医院培训负责人开通平台套餐。";
                }
            }
            else if (extra_permission == 0)
            {
                // 0表示不需要购买，1表示需要购买，2表示申请购买中，3表示已购买
                if (buy == 1 || buy == 2)
                {
                    self.preview = YES;
                    self.vipTips = @"2分钟预览已结束，观看全部课程请联系医院培训负责人开通平台套餐。";
                }
                else
                {
                    //直接播放
                }
            }
            
        } //未登录
        else
        {
            self.preview = YES;
            self.vipTips = @"本视频需登录后才能观看!";
        }
        
    } //无需登录即可播放的资源
    else
    {
        //直接播放
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end









