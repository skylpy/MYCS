//
//  ConstKeys.m
//  MYCS
//
//  Created by AdminZhiHua on 16/3/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ConstKeys.h"

//---------------设置-----------------

NSString *const kWWLANDownImageOff = @"kWWLANDownImageOff";
NSString *const kWWLANPlayVideoOff = @"kWWLANPlayVideoOff";
NSString *const kWWLANCacheVideoOff = @"kWWLANCacheVideoOff";

//---------------URL-----------------
NSString *const HOST_URL = @"http://mycsapi.mycs.cn/ios";
//NSString *const HOST_URL = @"http://192.168.1.64/ios";
//没有iOS的hostURL
NSString *const HOST_URL_NOIOS = @"http://mycsapi.mycs.cn";
// 用户登录
NSString *const LOGIN_PATH = @"/app/android/login.php";
// 授权登录
NSString *const OAUTH_LOGIN_PATH = @"/app/android/AppthirdLogin.php";
// 用户注册
NSString *const REGIST_PATH = @"/app/android/reg_new.php";
// 验证码
NSString *const CAPTCHA_PATH = @"/app/apps/captcha.php";
// 用户中心信息
NSString *const USERCENTER_PATH = @"/app/android/userCenter.php";
// 提交建议
NSString *const SUGGEST_PATH = @"/app/android/suggest.php";
// 发送邮箱验证码
NSString *const SENDEMAIL_PATH = @"/app/android/emailValidCode.php";
// 获取注册选择信息
NSString *const REGOPTION_PATH = @"/app/apps/getRegOption.php";
// 获取专业信息
NSString *const MAJOR_PATH = @"/app/apps/getProfession.php";
// 获取地区信息
NSString *const GETAREA_PATH = @"/app/templates/js/city.json";
// 发送手机验证码
NSString *const SENDSMS_PATH = @"/app/android/mobileSms.php";
// 绑定手机
NSString *const BINDPHONE_PATH = @"/app/android/userCenter.php";
// 收件箱列表
NSString *const INBOXLIST_PATH = @"/app/android/message.php";
// 未读消息数
NSString *const UNREADNUMBER_PATH = @"/app/apps/message.php";
// 视频中心
NSString *const VIDEO_PATH = @"/app/android/video.php";
// 教程中心
NSString *const COURSE_PATH = @"/app/android/course.php";
// sop中心
NSString *const SOP_PATH = @"/app/android/sop.php";
// 课程
NSString *const CoursePack_PATH = @"/appindex.php";
// 评论列表
NSString *const COMMENT_PATH = @"/app/apps/comment.php";
// 任务管理
NSString *const TASK_PATH = @"/app/android/task.php";
// 会员管理
NSString *const MEMBER_PATH = @"/app/android/member.php";
// 无忧商城视频分类列表
NSString *const VIDEOCLASSIFY_PATH = @"/app/android/index.php";
// 岗位体系接口
NSString *const POSTSYSTEM_PATH = @"/app/android/department.php";
// 收藏夹接口
NSString *const COLLECTION_PATH = @"/app/android/collection.php";
// 代付接口
NSString *const PAYFOROTHER_PATH = @"/app/android/payForOther.php";
// 支付信息获取接口
NSString *const PAYCONFIRM_PATH = @"/app/www/payConfirm.php";
// 待办任务列表
NSString *const MYWAITDOTASK_PATH = @"/app/android/myTask.php";
// 归档学习列表
NSString *const ARCHIVELIST_PATH = @"/app/apps/myTaskHistory.php";
// 统计
NSString *const STATISTICS_PATH = @"/app/android/stats.php";
// 客户端提交考核接口
NSString *const ANSWERSAVE_PATH = @"/app/apps/ItemAnswerSave.php";
// 获取课程信息接口
NSString *const GETTASKINFO_PATH = @"/app/apps/getTaskInfoById.php";
// 申请购买
NSString *const REQUESTBUY_PATH = @"/app/apps/applyBuy.php";
// 编辑图片的接口
NSString *const EDIT_IMAGE = @"/app/apps/uploadPhoto.php";
// 名医接口
NSString *const DOCTOR_PATH = @"/app/android/doctorApi.php";
// 编辑背景
NSString *const UPLOADTOPPHOTO = @"/app/android/V3/userCenter.php";
// 名医评价
NSString *const DOCTORCOMMENT = @"/app/android/doctorEvaluate.php";
// 学术交流，案例中心
NSString *const ACADEMICEXCHANGE = @"/app/android/comment.php";
// 无忧资讯
NSString *const INFOMATION = @"/app/android/newsApi.php";
//点击资讯里面的URL
NSString *const CLICKINFOMATION = @"/app/android/makeUrl.php";
// 首页搜索
NSString *const SEARCH_PATH = @"/app/android/searchApi.php";
// 科室、医院、企业、实验资料接口
NSString *const OFFICEAPI_PATH = @"/app/android/officeApi.php";
// 科室、医院、企业、实验列表接口
NSString *const HOSOFFENTLIST_PATH = @"/app/android/enterpriseApi.php";
// 活动
NSString *const ACTIVITY_PATH = @"/app/android/activityApi.php";
// 个人中心的广告
NSString *const SETPAGE_PATH = @"/app/android/setPage.php";
// 分类接口
NSString *const CATEGORY_PATH = @"/app/android/getCatExtra.php";
//自定义套餐
NSString *const CUSTOM_PATH = @"/app/android/video.php";
// 好友列表接口
NSString *const FRIEND_PATH = @"/app/android/msgFriends.php";
// 学习统计
NSString *const STUDYLOG_PATH = @"/app/apps/addStudyLog.php";
// 视频专访
NSString *const VIDEOINTERVIEW_PATH = @"/app/android/videoInterview.php";
// 公共评论接口
NSString *const GENERALCOMMENT_PATH =@"/app/android/commentForAll.php";
// 直播
NSString *const LIVE_PATH = @"/app/android/live.php";
//---------------通知-----------------

NSString *const LOGINOUT = @"LoginOut";

NSString *const ChangeUserTopHeadPic = @"ChangeUserTopHeadPic";

NSString *const NewIMMessage = @"NewIMMessage";

NSString *const ReplyCommentSuccess = @"ReplyCommentSuccess";

NSString *const ConnectIMSeverSuccess = @"ConnectIMSeverSuccess";

NSString *const LoginSuccess = @"LoginSuccess";

NSString *const ChangeLiveStatus = @"ChangeLiveStatus";

//消息Item的消息数
NSString *const MESSAGENOTI = @"MESSAGENOTI";
//我的Item的消息数
NSString *const PROFILENOTI = @"PROFILENOTI";
//帐号登录异常
NSString *const ACCOUNTLOGINERROR = @"ACCOUNTLOGINERROR";


//---------------统计分析-----------------
NSString *const STATICSOPENVIEW = @"StaticsOpenView";

