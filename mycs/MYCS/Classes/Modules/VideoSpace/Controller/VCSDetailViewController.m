//
//  VCSDetailViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "VCSDetailViewController.h"
#import "VideoTitleButton.h"
#import "UpDownButton.h"
#import "MJRefresh.h"
#import "NSString+Size.h"
#import "IQKeyboardManager.h"
#import "CommentModel.h"
#import "VideoDetail.h"
#import "CourseDetail.h"
#import "SopDetail.h"
#import "UIImageView+WebCache.h"
#import "MediaPlayerViewController.h"
#import "NSString+Util.h"
#import "PlayRecordModel.h"
#import "NSDate+Util.h"
#import "UILabel+Attr.h"
#import "NSMutableAttributedString+Attr.h"
#import "MMPickerView.h"
#import "UMengHelper.h"
#import "EdictVideoViewController.h"
#import "ZHCycleView.h"
#import "VideoCacheDownloadManager.h"
#import "CourseDownLoadView.h"
#import "SOPDownLoadView.h"
#import "UIAlertView+Block.h"

static NSString *reuseID = @"VCSCommentCell";

@interface VCSDetailViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, VCSCommentCellDelegate, UITextFieldDelegate>

/**< 控件 */
//视频图像
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
//滚动试图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//标题按钮
@property (weak, nonatomic) IBOutlet VideoTitleButton *titleButton;
//分类
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
//来源
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
//播放图标
@property (weak, nonatomic) IBOutlet UIImageView *playView;
//描述
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
//点赞按钮
@property (weak, nonatomic) IBOutlet UpDownButton *praiseButton;
//收藏按钮
@property (weak, nonatomic) IBOutlet UpDownButton *collectionButton;
//缓存按钮
@property (weak, nonatomic) IBOutlet UpDownButton *cacheButton;
//选择教程、sop View
@property (weak, nonatomic) IBOutlet UIView *selectView;
//选择教程、sop Button
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
//评论标签
@property (weak, nonatomic) IBOutlet UIView *commentView;
//评论表
@property (weak, nonatomic) IBOutlet UITableView *commentTable;
//评论输入框
@property (weak, nonatomic) IBOutlet UITextField *editTextField;
//分享按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareBarBth;

//编辑按钮
@property (weak, nonatomic) IBOutlet UpDownButton *edictButton;

/**< 约束 */
//视频详情的高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewConstH;
//选择按钮顶部的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonConstTop;
//图片的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstHeight;
//评论view的高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableConstH;
//评论工具条底部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentToolConstBottom;
//编辑按钮右边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *edictButtonConstTrailing;
//时间总长
@property (weak, nonatomic) IBOutlet UILabel *durationL;

//获取评论的列表ID
@property (nonatomic, strong) NSString *commentId;

@property (nonatomic, strong) VideoDetail *videoDetail;
@property (nonatomic, strong) CourseDetail *courseDetail;
@property (nonatomic, strong) SopDetail *sopDetail;
@property (nonatomic, strong) ChapterModel *chapter;

@property (nonatomic, strong) NSMutableArray *ChapterSource;

//评论列表的数组
@property (nonatomic, strong) NSMutableArray *commentDataBase;

//评论的页码
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) CGFloat commentTableStartH;

//轮播图
@property (nonatomic, strong) ZHCycleView *loopScrollView;

//发表评论需要
@property (nonatomic, copy) NSString *toEid;
@property (nonatomic, copy) NSString *toUid;

//是否预览
@property (nonatomic, assign, getter=isPreview) BOOL preview;
//预览提示
@property (nonatomic, copy) NSString *vipTips;

@end

@implementation VCSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.commentTable addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    self.ChapterSource = [NSMutableArray array];

    [self buildUI];
    
    [self requestVideoDataFromServer];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutAction:) name:LoginSuccess object:nil];
}

- (void)loginOutAction:(NSNotification *)noti
{
     [self requestVideoDataFromServer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LoginSuccess object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [IQKeyboardManager sharedManager].enable = NO;

    [self installNotification];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [IQKeyboardManager sharedManager].enable = YES;
    [self removeallNotification];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //从活动进入的视频禁止下载
    //    self.cacheButton.enabled = !self.isActivity;

    //检查当前视频是否在下载列表中
    if (self.type == VCSDetailTypeVideo)
    {
        DownloadChapterObject *object = [VideoCacheDownloadManager downloadObjectWithChpaterId:self.videoDetail.id];

        if (!object.objId) return;

        self.cacheButton.enabled = NO;
    }
}

- (void)installNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}
- (void)removeallNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)buildUI {
    [self.scrollView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.scrollView addFooterWithTarget:self action:@selector(loadMoreData)];

    self.commentTable.tableFooterView = [UIView new];
    self.commentTable.backgroundColor = [UIColor whiteColor];

    //设置显示或者隐藏选择按钮
    if (self.type == VCSDetailTypeVideo && !self.isActivity)
    {
        self.selectButtonConstTop.constant = -50;
        self.selectView.hidden             = YES;
        self.collectionButton.hidden       = NO;
    }
    else if (self.type == VCSDetailTypeCourse)
    {
        [self.selectButton setTitle:@"选择教程" forState:UIControlStateNormal];

        self.collectionButton.hidden = YES;
    }
    else if (self.type == VCSDetailTypeSOP)
    {
        [self.selectButton setTitle:@"选择SOP" forState:UIControlStateNormal];

        self.collectionButton.hidden = YES;
    }
    else
    {
        self.selectButtonConstTop.constant = -50;
        self.selectView.hidden             = YES;
        self.collectionButton.hidden       = YES;
    }

    //    if (!self.isMySelft || ([AppManager sharedManager].user.userType == 3 && [AppManager sharedManager].user.isAdmin.intValue != 1))
    //    {
    self.edictButton.hidden                = YES;
    self.edictButton.alpha                 = 0;
    self.edictButtonConstTrailing.constant = 0;
    //    }

    //设置图片的高度
    self.imageConstHeight.constant = (self.view.width * 9) / 16;

    [self.view layoutIfNeeded];

    //计算评论区显示的高度
    CGFloat commentTableH            = self.scrollView.height - CGRectGetMaxY(self.commentView.frame);
    self.commentTableConstH.constant = commentTableH;
    //保存初始高度
    self.commentTableStartH = commentTableH;

    [self.view layoutIfNeeded];
}

#pragma mark - Action
- (IBAction)titleButtonAction:(VideoTitleButton *)button {
    button.selected = !button.selected;

    //展开
    if (button.selected)
    {
        [self.desLabel sizeToFit];
        self.detailViewConstH.constant = CGRectGetMaxY(self.desLabel.frame) + 10;

    } //收起
    else
    {
        self.detailViewConstH.constant = 123;
    }

    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)editButtonAction:(id)sender {
    EdictVideoViewController *edictVC = [[UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil] instantiateViewControllerWithIdentifier:@"EdictVideoViewController"];

    if (self.type == VCSDetailTypeVideo)
    {
        edictVC.videoDetail = self.videoDetail;
    }
    else if (self.type == VCSDetailTypeCourse)
    {
        edictVC.courseDetail = self.courseDetail;
    }
    else if (self.type == VCSDetailTypeSOP)
    {
        edictVC.sopDetail = self.sopDetail;
    }

    edictVC.sureBtnBlock = ^() {

        [self requestVideoDataFromServer];
    };

    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:edictVC animated:YES];
}

- (IBAction)likeButtonAction:(UIButton *)button {
    if (![AppManager checkLogin]) return;

    //    2--视频资源点赞，3--课程资源点赞，4--sop资源点赞
    NSString *commentType = [NSString stringWithFormat:@"%d", (int)(self.type + 1)];

    NSString *commentId = self.videoDetail ? self.videoDetail.commentCId : self.courseDetail ? self.courseDetail.commentCId : self.sopDetail.commentCId;
    if (commentId == nil) return;
    button.enabled = NO;

    [CommentModel praiseChangeWithcmt_type:commentType cmt_cid:commentId success:^(SCBModel *model) {

        NSString *tips = self.praiseButton.selected ? @"取消点赞" : @"点赞成功";
        [self showSuccessWithStatusHUD:tips];

        self.praiseButton.selected = !self.praiseButton.selected;
        button.enabled             = YES;

    }
        failure:^(NSError *error) {
            button.enabled = YES;
            [self showError:error];

        }];
}

- (IBAction)collectionButtonAction:(UIButton *)button {
    if (![AppManager checkLogin]) return;

    NSString *collectionType;
    if (self.type == VCSDetailTypeVideo)
    {
        collectionType = @"video";
    }
    else if (self.type == VCSDetailTypeCourse)
    {
        collectionType = @"course";
    }
    else if (self.type == VCSDetailTypeSOP)
    {
        collectionType = @"sop";
    }

    NSString *collect;

    if (button.selected)
    {
        collect = @"0";
    }
    else
    {
        collect = @"1";
    }

    if (self.videoId == nil) return;

    button.enabled = NO;

    [SopDetail addCollection:self.videoId collectionType:collectionType Collect:collect success:^{

        NSString *tips = button.selected ? @"取消收藏" : @"收藏成功";

        [self showSuccessWithStatusHUD:tips];

        button.selected = !button.selected;

        button.enabled = YES;

    }
        failure:^(NSError *error) {

            button.enabled = YES;

            [self dismissLoadingHUD];

            [self showError:error];

        }];
}
- (IBAction)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareBarButtonAction:(UIBarButtonItem *)sender {
    NSString *linkUrl;
    if (self.type == VCSDetailTypeVideo)
    {
        linkUrl = self.videoDetail.link_url;
    }
    else if (self.type == VCSDetailTypeCourse)
    {
        linkUrl = self.courseDetail.link_url;
    }
    else if (self.type == VCSDetailTypeSOP)
    {
        linkUrl = self.sopDetail.link_url;
    }

    NSString *contentStr = self.desLabel.text;

    if (self.desLabel.text.length <= 0)
    {
        contentStr = @"名医传世视频";
    }

    [UMengHelper shareWith:self.titleButton.titleLabel.text content:contentStr shareUrl:linkUrl shareImage:self.iconImage.image viewController:self];
}

- (IBAction)cacheButtonAction:(UIButton *)button {
    button.selected = !button.selected;

    if (!self.isActivity)
    {
        [self setPreviewAuthority];
    }

    if (self.isPreview)
    {
        if ([self.vipTips isEqualToString:@"本视频需登录后才能观看!"])
        {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本视频需登录后才能缓存!" cancelButtonTitle:@"确定"];
            [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                [AppManager checkLogin];
            }];
            
        }else
        {
            [self showErrorMessage:@"你没有权限下载该视频，请联系医院培训负责人开通平台套餐。"];
        }
        
        return;
    }

    if (self.type == VCSDetailTypeVideo)
    {
        DownloadChapterObject *downloadChapter = [VideoCacheDownloadManager downloadObjectWithChpaterId:self.videoDetail.id];

        if (!downloadChapter.objId)
        {
            //添加到下载列表
            ChapterModel *chapter = [ChapterModel new];
            chapter.m3u8          = self.videoDetail.m3u8;
            chapter.m3u8Hd        = self.videoDetail.m3u8Hd;
            chapter.mp4Url        = self.videoDetail.mp4url;
            chapter.mp4UrlHd      = self.videoDetail.mp4urlHd;
            chapter.chapterId     = self.videoDetail.id;
            chapter.name          = self.videoDetail.title;
            chapter.picUrl = self.videoDetail.picurl;
            
            [VideoCacheDownloadManager addDownloadChapterWithId:self.videoDetail.id chapterId:self.videoDetail.id chapter:chapter];
            [self showSuccessWithStatusHUD:@"添加下载"];

            self.cacheButton.enabled = NO;
        }
    }
    else if (self.type == VCSDetailTypeCourse)
    {
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.shareBarBth.enabled                      = NO;
        [CourseDownLoadView showWith:self.courseDetail InView:self.navigationController.view belowView:self.navigationController.navigationBar action:^(void) {
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.shareBarBth.enabled                      = YES;
        }];
    }
    else if (self.type == VCSDetailTypeSOP)
    {
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.shareBarBth.enabled                      = NO;
        [SOPDownLoadView showWith:self.sopDetail InView:self.navigationController.view belowView:self.navigationController.navigationBar action:^{

            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.shareBarBth.enabled                      = YES;

        }];
    }
}

- (IBAction)selectChapterAction:(id)sender {
    
    if (self.ChapterSource.count == 0)return;
    
    [MMPickerView showPickerViewInVideoView:self.view withObjects:self.ChapterSource withOptions:nil objectToStringConverter:^NSString *(id object) {

        return ((ChapterModel *)object).name;

    }
        completion:^(id selectedObject) {

            if ([selectedObject isKindOfClass:[ChapterModel class]])
            {
                ChapterModel *chapterModel = (ChapterModel *)selectedObject;
                self.chapter = chapterModel;
                
                [self playAction:nil];
        
            }
        }];
}

//评论
- (IBAction)commentButtonAction:(id)sender {
    if (![AppManager checkLogin]) return;

    [self.view endEditing:YES];

    if (self.editTextField.text.length == 0) return;

    NSString *commentType = [NSString stringWithFormat:@"%lu", (unsigned long)self.type];

    if (!self.toUid && !self.toEid)
    {
        [self sendCommentWith:commentType andToEid:@"0" andToUid:@"0"];
    }
    else
    {
        [self sendCommentWith:commentType andToEid:self.toEid andToUid:self.toUid];
    }

    [self resetEditParam];
}

//type = 1 评论;type = 2 回复; type = 3 回复某条回复;
- (void)sendCommentWith:(NSString *)commentType andToEid:(NSString *)toEid andToUid:(NSString *)toUid {
    NSString *commentId = self.videoDetail ? self.videoDetail.commentCId : self.courseDetail ? self.courseDetail.commentCId : self.sopDetail.commentCId;

    NSString *comment = [self.editTextField.text trimmingWhitespaceAndNewline];

    [CommentModel addCmtWithcmt_type:commentType cmt_cid:commentId content:comment toEid:toEid toUid:toUid success:^(SCBModel *model) {

        [self showSuccessWithStatusHUD:@"发表评论成功"];
        [self.scrollView headerBeginRefreshing];

    }
        failure:^(NSError *error) {

            [self showError:error];

        }];
}

- (IBAction)playAction:(id)sender {
    if (self.type == VCSDetailTypeVideo && !self.videoDetail) return;
    if (self.type == VCSDetailTypeCourse && !self.courseDetail) return;
    if (self.type == VCSDetailTypeSOP && !self.sopDetail) return;

    //不是从活动进来的视频，要检查权限
    if (!self.isActivity)
    {
        [self setPreviewAuthority];
    }

    AFNetworkReachabilityStatus status = [AppManager sharedManager].status;

    //判断是否是非WIFI环境下播放视频
    if ([AppManager sharedManager].WWLANPlayVideoOff && status == AFNetworkReachabilityStatusReachableViaWWAN)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前使用移动网络是否播放视频" cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];

        [alertView showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {

            if (buttonIndex == 1)
            {
                [self showMeidaPlayerVC];
            }

        }];

        return;
    }

    [self showMeidaPlayerVC];
}

//播放视频
- (void)showMeidaPlayerVC {
    [MediaPlayerViewController showWith:self coursePackArray:nil videoDetail:self.videoDetail courseDetail:self.courseDetail sopDetail:self.sopDetail chapter:self.chapter DoctorsHealthDetail:nil isTask:NO isPreview:self.preview previewTips:self.vipTips];

    //添加到播放记录
    PlayRecordModel *model;
    if (self.type == VCSDetailTypeVideo)
    {
        model = [PlayRecordModel playRecordWith:self.videoDetail.title videoId:self.videoId picUrl:self.videoDetail.picurl videoType:@"video"];
    }
    else if (self.type == VCSDetailTypeCourse)
    {
        model = [PlayRecordModel playRecordWith:self.courseDetail.name videoId:self.videoId picUrl:self.courseDetail.image videoType:@"course"];
    }
    else if (self.type == VCSDetailTypeSOP)
    {
        model = [PlayRecordModel playRecordWith:self.sopDetail.name videoId:self.videoId picUrl:self.sopDetail.picUrl videoType:@"sop"];
    }

    [PlayRecordModel addLocalPlayRecord:model];
}

//设置预览权限
- (void)setPreviewAuthority {
    
    self.preview = NO;
    self.vipTips = nil;
    
    int extra_permission = 0;
    BOOL isMember;
    int buy;

    if (self.type == VCSDetailTypeVideo)
    {
        extra_permission = self.videoDetail.extra_permission;
        isMember         = self.videoDetail.isMember;
        buy              = self.videoDetail.buy;
    }
    else if (self.type == VCSDetailTypeCourse)
    {
        extra_permission = self.courseDetail.extra_permission;
        isMember         = self.courseDetail.isMember;
        buy              = self.courseDetail.buy;
    }
    else
    {
        extra_permission = self.sopDetail.extra_permission;
        isMember         = self.sopDetail.isMember;
        buy              = self.sopDetail.buy;
    }

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
                    //                    if (previewTime=0)
                    //                    {
                    //                        //提示购买
                    //                    }
                    //                    else
                    //                    {
                    //                        //预览后提示购买
                    //                    }

                    self.preview = YES;
                    self.vipTips = @"2分钟预览已结束，观看全部课程请联系医院培训负责人开通平台套餐。";
                }
            }
            else if (extra_permission == 0)
            {
                // 0表示不需要购买，1表示需要购买，2表示申请购买中，3表示已购买
                if (buy == 1 || buy == 2)
                {
                    //                    if (previewTime=0)
                    //                    {
                    //                        //提示联系客服
                    //                    }
                    //                    else
                    //                    {
                    //                        //预览后提示购买
                    //                    }
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
            //            if (previewTime=0)
            //            {
            //                //提示登录
            //            }
            //            else
            //            {
            //                //预览
            //            }
            self.preview = YES;
            self.vipTips = @"本视频需登录后才能观看!";
        }

    } //无需登录即可播放的资源
    else
    {
        //直接播放
    }
}

#pragma mark - Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentDataBase.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VCSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];

    commentListModel *model = self.commentDataBase[indexPath.row];

    [cell configWith:model];

    cell.delegate = self;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VCSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];

    commentListModel *model = self.commentDataBase[indexPath.row];

    return [cell configWith:model];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.editTextField.placeholder = @"我要评论...";
}

- (void)resetEditParam {
    self.editTextField.text        = @"";
    self.editTextField.placeholder = @"我要评论...";
    self.toEid                     = nil;
    self.toUid                     = nil;
}

#pragma mark - CustomDelegat
- (void)VCSCommentCell:(VCSCommentCell *)cell didTapReplyLabel:(ReplayControl *)control commentModel:(commentListModel *)model {
    if (![AppManager checkLogin]) return;

    commentReplyListModel *replyListModel = control.model;

    NSString *placeHolder          = [NSString stringWithFormat:@"回复:%@", replyListModel.from_uname];
    self.editTextField.placeholder = placeHolder;

    self.toEid = model.lid;
    self.toUid = replyListModel.from_uid;

    [self.editTextField becomeFirstResponder];
}

- (void)VCSCommentCell:(VCSCommentCell *)cell showAllButtonAction:(UIButton *)button {
    [self.commentTable reloadData];
}

- (void)VCSCommentCell:(VCSCommentCell *)cell replyButtonAction:(UIButton *)button commentModel:(commentListModel *)model {
    if (![AppManager checkLogin]) return;

    self.toEid = model.lid;
    self.toUid = @"0";

    NSString *placeHolder          = [NSString stringWithFormat:@"回复:%@", model.from_uname];
    self.editTextField.placeholder = placeHolder;

    [self.editTextField becomeFirstResponder];
}

#pragma mark - 键盘事件
- (void)keyBoardWillShow:(NSNotification *)noti {
    if (![AppManager checkLogin]) return;

    NSValue *value        = noti.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect keyboardBounds = [value CGRectValue];

    NSString *durationString = noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"];

    [UIView animateWithDuration:[durationString floatValue] animations:^{
        self.commentToolConstBottom.constant = keyboardBounds.size.height;
        [self.view layoutIfNeeded];
    }];
}

- (void)keyBoardWillHide:(NSNotification *)noti {
    NSString *durationString = noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"];

    [UIView animateWithDuration:[durationString floatValue] animations:^{
        self.commentToolConstBottom.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    //根据tableView的contentSize来改变tableView的高度
    NSValue *value = change[@"new"];
    CGSize size    = [value CGSizeValue];

    if (size.height > self.commentTableStartH)
    {
        self.commentTableConstH.constant = size.height;
        [self.view layoutIfNeeded];
    }
}

#pragma mark - Network
- (void)loadNewData {
    NSString *commentType = [NSString stringWithFormat:@"%lu", (unsigned long)self.type];

    self.page = 1;

    [CommentModel getCommentWithcmt_type:commentType cmt_cid:self.commentId page:[NSString stringWithFormat:@"%ld", (long)self.page] replyId:nil success:^(NSArray *listArr) {

        [self.commentDataBase removeAllObjects];
        self.commentDataBase = [NSMutableArray arrayWithArray:listArr];
        [self.commentTable reloadData];
        [self.scrollView headerEndRefreshing];

    }
        failure:^(NSError *error) {

            [self.scrollView headerEndRefreshing];

        }];
}

- (void)loadMoreData {
    NSString *commentType = [NSString stringWithFormat:@"%lu", (unsigned long)self.type];

    self.page++;

    [CommentModel getCommentWithcmt_type:commentType cmt_cid:self.commentId page:[NSString stringWithFormat:@"%ld", (long)self.page] replyId:nil success:^(NSArray *listArr) {

        [self.commentDataBase addObjectsFromArray:listArr];
        [self.commentTable reloadData];
        [self.scrollView footerEndRefreshing];

    }
        failure:^(NSError *error) {

            [self.scrollView footerEndRefreshing];

        }];
}

- (void)requestVideoDataFromServer {
    [self showLoadingHUD];

    if (self.type == VCSDetailTypeVideo)
    {
        [VideoDetail videoDetailWithUserId:[AppManager sharedManager].user.uid userType:[AppManager sharedManager].user.userType action:@"detail" videoId:self.videoId activityId:self.activityId fromeCache:YES success:^(VideoDetail *videoDetail) {

            self.videoDetail = videoDetail;

            [self dismissLoadingHUD];

        }
            failure:^(NSError *error) {

                [self dismissLoadingHUD];

                [self showError:error];

            }];
    }
    else if (self.type == VCSDetailTypeCourse)
    {
        [CourseDetail courseDetailWithUserId:[AppManager sharedManager].user.uid userType:[AppManager sharedManager].user.userType action:@"detail" videoId:self.videoId activityId:self.activityId fromCache:YES success:^(CourseDetail *courseDetail) {

            self.courseDetail = courseDetail;

            [self dismissLoadingHUD];

            [self.ChapterSource removeAllObjects];
            
            [self.ChapterSource addObjectsFromArray:courseDetail.chapters];

        }
            failure:^(NSError *error) {

                [self dismissLoadingHUD];

                [self showError:error];

            }];
    }
    else if (self.type == VCSDetailTypeSOP)
    {
        [SopDetail sopDetailWithsopId:self.videoId activityId:self.activityId fromCache:YES success:^(SopDetail *sopDetail) {

            self.sopDetail = sopDetail;

            [self dismissLoadingHUD];

             [self.ChapterSource removeAllObjects];
            
            for (SopCourseModel *model in sopDetail.sopCourse)
            {
                [self.ChapterSource addObjectsFromArray:model.chapters];
            }


        }
            failure:^(NSError *error) {

                [self dismissLoadingHUD];

                [self showError:error];
            }];
    }
}

#pragma mark - Getter 和 Setter
- (void)setVideoDetail:(VideoDetail *)videoDetail {
    _videoDetail = videoDetail;

    //图片
    if (videoDetail.picList.count <= 1)
    {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:videoDetail.picurl] placeholderImage:PlaceHolderImage];
    }
    else
    {
        [_loopScrollView removeFromSuperview];
        __weak typeof(self) weakSelf = self;

        _loopScrollView = [ZHCycleView cycleViewWithFrame:CGRectMake(0, 0, ScreenW, self.iconImage.height) imageUrlGroups:videoDetail.picList placeHolderImage:PlaceHolderImage selectAction:^(NSInteger index) {

            [weakSelf playAction:nil];

        }];

        _loopScrollView.currentPageTintColor = HEXRGB(0x47c1a8);
        _loopScrollView.pageTintColor        = HEXRGB(0xeeeeee);

        [self.view insertSubview:_loopScrollView belowSubview:self.playView];
    }

    //标题
    [self.titleButton setTitle:videoDetail.title forState:UIControlStateNormal];

    //分类
    self.classLabel.text = videoDetail.category;

    //来源
    self.sourceLabel.text = videoDetail.from;

    //简介
    self.desLabel.numberOfLines = 0;
    self.desLabel.text          = videoDetail.describe;

    //点赞
    self.praiseButton.selected = [videoDetail.isPraise intValue];
    //收藏
    self.collectionButton.selected = videoDetail.is_collect;

    self.durationL.text = [NSString stringWithFormat:@" %@ ",videoDetail.duration];
    
    self.title = @"视频详情";

    self.commentId = videoDetail.commentCId;

    [VideoCacheDownloadManager addObjectWith:videoDetail.id cacheType:CacheObjectTypeVideo object:videoDetail];
}

- (void)setCourseDetail:(CourseDetail *)courseDetail {
    _courseDetail = courseDetail;

    //图片
    if (courseDetail.picList.count <= 1)
    {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:courseDetail.image] placeholderImage:PlaceHolderImage];
    }
    else
    {
        [_loopScrollView removeFromSuperview];

        _loopScrollView = [ZHCycleView cycleViewWithFrame:CGRectMake(0, 0, ScreenW, self.iconImage.height) imageUrlGroups:courseDetail.picList placeHolderImage:PlaceHolderImage selectAction:^(NSInteger index) {

            [self playAction:nil];

        }];

        _loopScrollView.currentPageTintColor = HEXRGB(0x47c1a8);
        _loopScrollView.pageTintColor        = HEXRGB(0xeeeeee);

        [self.view insertSubview:_loopScrollView belowSubview:self.playView];
    }

    //标题
    [self.titleButton setTitle:courseDetail.name forState:UIControlStateNormal];

    //分类
    self.classLabel.text = courseDetail.category;

    //来源
    self.sourceLabel.text = courseDetail.author;

    //简介
    self.desLabel.numberOfLines = 0;
    self.desLabel.text          = courseDetail.introduction;

    //点赞
    self.praiseButton.selected = [courseDetail.isPraise intValue];
    //收藏
    self.collectionButton.selected = courseDetail.is_collect;

     self.durationL.text = [NSString stringWithFormat:@" %@ ",courseDetail.duration];
    
    self.title = @"教程详情";

    self.commentId = courseDetail.commentCId;
}

- (void)setSopDetail:(SopDetail *)sopDetail {
    _sopDetail = sopDetail;

    //图片
    if (sopDetail.picList.count <= 1)
    {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:sopDetail.picUrl] placeholderImage:PlaceHolderImage];
    }
    else
    {
        [_loopScrollView removeFromSuperview];

        _loopScrollView = [ZHCycleView cycleViewWithFrame:CGRectMake(0, 0, ScreenW, self.iconImage.height) imageUrlGroups:sopDetail.picList placeHolderImage:PlaceHolderImage selectAction:^(NSInteger index) {

            [self playAction:nil];

        }];

        _loopScrollView.currentPageTintColor = HEXRGB(0x47c1a8);
        _loopScrollView.pageTintColor        = HEXRGB(0xeeeeee);

        [self.view insertSubview:_loopScrollView belowSubview:self.playView];
    }

    //标题
    [self.titleButton setTitle:sopDetail.name forState:UIControlStateNormal];

    //分类
    self.classLabel.text = sopDetail.category;

    //来源
    self.sourceLabel.text = sopDetail.author;

    //简介
    self.desLabel.numberOfLines = 0;
    self.desLabel.text          = sopDetail.introduction;

    //点赞
    self.praiseButton.selected = [sopDetail.isPraise intValue];

    //收藏
    self.collectionButton.selected = sopDetail.is_collect;

     self.durationL.text = [NSString stringWithFormat:@" %@ ",sopDetail.duration];
    
    self.title = @"SOP详情";

    self.commentId = sopDetail.commentCId;
}

- (void)setCommentId:(NSString *)commentId {
    _commentId = commentId;

    //获取评论数据
    [self.scrollView headerBeginRefreshing];
}

- (void)dealloc {
    [self.commentTable removeObserver:self forKeyPath:@"contentSize"];
    self.commentTable = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@interface VCSCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avartView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIView *replyContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyContentViewConstH;

@property (nonatomic, strong) UIButton *showAllReplyButton;

@end

@implementation VCSCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avartView.layer.cornerRadius  = 20;
    self.avartView.layer.masksToBounds = YES;
}

- (CGFloat)configWith:(commentListModel *)model {
    self.model = model;

    [self.avartView sd_setImageWithURL:[NSURL URLWithString:model.from_upicurl] placeholderImage:PlaceHolderImage];
    self.nameLabel.text = model.from_uname;

    //--用户标签，0-无 1-人物 2-医生 3-名医 4-专家
    NSString *personTag;
    if (model.from_personTag == 0)
    {
        personTag = @"";
    }
    else if (model.from_personTag == 1)
    {
        personTag = @"人物_已认证";
    }
    else if (model.from_personTag == 2)
    {
        personTag = @"医生_已认证";
    }
    else if (model.from_personTag == 3)
    {
        personTag = @"名医_已认证";
    }
    else if (model.from_personTag == 4)
    {
        personTag = @"专家_已认证";
    }

    self.authorLabel.text = personTag;
    self.timeLabel.text   = [NSDate dateWithTimeInterval:[model.addTime integerValue] format:@"yyyy-MM-dd"];

    self.contentLabel.text = model.content;

    NSString *replyCount = [NSString stringWithFormat:@"%lu", (unsigned long)model.replyList.count];
    [self.replyButton setTitle:replyCount forState:UIControlStateNormal];

    [self layoutIfNeeded];

    CGFloat cellH;

    if (model.replyList.count == 0)
    {
        cellH = self.replyContent.y;
    }
    else
    {
        [self.replyContent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        //评论区
        CGFloat replyLabelY = 10;
        for (int i = 0; i < model.replyList.count; i++)
        {
            if (i > 2 && !model.expand)
            {
                [self.replyContent addSubview:self.showAllReplyButton];

                NSString *title = [NSString stringWithFormat:@"更多%u条回复...", (int)model.replyList.count - 3];
                [self.showAllReplyButton setTitle:title forState:UIControlStateNormal];

                CGFloat buttonW = ScreenW - 30 - 10 * 2;

                self.showAllReplyButton.frame = CGRectMake(10, replyLabelY, buttonW, 16);

                replyLabelY = CGRectGetMaxY(self.showAllReplyButton.frame) + 10;

                break;
            }
            else
            {
                [self.showAllReplyButton removeFromSuperview];
            }

            commentReplyListModel *replyModel = model.replyList[i];
            UILabel *replyLabel               = [UILabel new];
            [self.replyContent addSubview:replyLabel];

            replyLabel.textColor = HEXRGB(0x666666);

            NSString *replyContenStr;
            if (replyModel.reply_uname && replyModel.reply_uname.length != 0)
            {
                replyContenStr = [NSString stringWithFormat:@"%@回复%@:%@", replyModel.from_uname, replyModel.reply_uname, replyModel.content];

                NSRange fromRange  = NSMakeRange(0, replyModel.from_uname.length);
                NSRange replyRange = NSMakeRange(fromRange.length + 2, replyModel.reply_uname.length);

                NSMutableAttributedString *attrString = [NSMutableAttributedString string:replyContenStr value1:HEXRGB(0x5382c5) range1:fromRange value2:HEXRGB(0x5382c5) range2:replyRange font:12];

                replyLabel.attributedText = attrString;
            }
            else
            {
                replyContenStr = [NSString stringWithFormat:@"%@:%@", replyModel.from_uname, replyModel.content];

                NSRange fromRange = NSMakeRange(0, replyModel.from_uname.length);

                NSMutableAttributedString *attrString = [NSMutableAttributedString string:replyContenStr value1:HEXRGB(0x5382c5) range1:fromRange value2:nil range2:NSMakeRange(0, 0) font:12];

                replyLabel.attributedText = attrString;
            }

            //设置label的属性
            replyLabel.numberOfLines = 0;
            replyLabel.font          = [UIFont systemFontOfSize:12];

            //设置frame
            CGFloat margin = 10;
            CGFloat labelW = ScreenW - 30 - margin * 2;
            CGFloat labelH = [replyContenStr heightWithFont:[UIFont systemFontOfSize:12] constrainedToWidth:labelW];

            replyLabel.frame = CGRectMake(margin, replyLabelY, labelW, labelH + 4);

            //设置响应事件
            ReplayControl *tapControl = [ReplayControl new];
            tapControl.frame          = replyLabel.frame;
            [self.replyContent addSubview:tapControl];
            [tapControl addTarget:self action:@selector(replyLabelClickAction:) forControlEvents:UIControlEventTouchUpInside];
            tapControl.model = replyModel;

            replyLabelY = CGRectGetMaxY(replyLabel.frame) + margin;
        }

        self.replyContentViewConstH.constant = replyLabelY;
        [self layoutIfNeeded];

        cellH = CGRectGetMaxY(self.replyContent.frame) + 15;
    }

    return cellH;
}

- (void)replyLabelClickAction:(ReplayControl *)control {
    if ([self.delegate respondsToSelector:@selector(VCSCommentCell:didTapReplyLabel:commentModel:)])
    {
        [self.delegate VCSCommentCell:self didTapReplyLabel:control commentModel:self.model];
    }
}

- (void)showAllReply:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(VCSCommentCell:showAllButtonAction:)])
    {
        if (self.model.expand)
        {
            self.model.expand = nil;
        }
        else
        {
            self.model.expand = @"1";
        }
        [self.delegate VCSCommentCell:self showAllButtonAction:button];
    }
}

- (IBAction)replyButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(VCSCommentCell:replyButtonAction:commentModel:)])
    {
        [self.delegate VCSCommentCell:self replyButtonAction:button commentModel:self.model];
    }
}


#pragma mark - Getter和Setter
- (UIButton *)showAllReplyButton {
    if (!_showAllReplyButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.replyContent addSubview:button];

        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.font            = [UIFont systemFontOfSize:12];

        [button setTitleColor:HEXRGB(0x5382c5) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showAllReply:) forControlEvents:UIControlEventTouchUpInside];

        _showAllReplyButton = button;
    }

    return _showAllReplyButton;
}


@end

@implementation ReplayControl


@end
