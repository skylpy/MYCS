//
//  VideoShopListModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/1/27.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "UserCenterModel.h"

typedef enum
{
    ClassifyVideoSearchTypeVideo = 1,
    ClassifyVideoSearchTypeCourse = 2,
    ClassifyVideoSearchTypeSOP =3
    
}ClassifyVideoSearchType;



@protocol ShopListItemModel <NSObject>
@end
@interface ShopListItemModel : JSONModel
@property (strong, nonatomic) NSString<Optional> *name; //标题
@property (strong, nonatomic) NSString<Optional> *picUrl; //缩略图
@property (strong, nonatomic) NSString<Optional> *price; //价格
@property (strong, nonatomic) NSString<Optional> *modelID; //视频、课程、SOP  ID
@property (strong, nonatomic) NSString<Optional> *describe; //
@property (strong, nonatomic) NSString<Optional> *type; //类型，video详情调用“视频中心”详情接口，
                                                        //course详情调用“教程中心”详情接口，sop详情调用“sop中心”接口
@property (strong, nonatomic) NSString<Optional> *click; //播放量
@property (copy,nonatomic) NSString<Optional> *up;//点赞数
@end


@interface VideoShopListModel : JSONModel
@property (strong, nonatomic) NSMutableArray<Optional, Focus> *focus; //轮播图
@property (strong, nonatomic) NSMutableArray<Optional, ShopListItemModel> *list; //视频、教程或者SOP列表，个数可能有几十个。。。分页app控制了，
                                                                          //免费、付费根据price的值判断

/**
 *  无忧商城--获取医学、生命科学、无忧学院视频列表
 *
 *  @param action    index
 *  @param success 成功执行块
 *  @param failure 失败执行块
 */
//+ (void)requestVideoShopListWithType:(NSString *)type success:(void (^)(VideoShopListModel *lists))success failure:(void (^)(NSError *error))failure;
+ (void)requestVideoShopListWithAction:(NSString *)action page:(int)page pageSize:(int)pageSize fromCache:(BOOL)isFromCache success:(void (^)(VideoShopListModel *model))success  failure:(void (^)(NSError *error))failure;

/**
 *  分类页、搜索页
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户的类型
 *  @param type     二级分类中的type
 *  @param cid      二级分类中的cid
 *  @param keyword  当搜索时，传关键字
 *  @param status   免费传：free   付费传： pay  全部传： all
 *  @param page     页码
 *  @param pageSize 每页个数
 *  @param success  成功返回块
 *  @param failure  失败返回块
 */
+ (void)searchVideoListWithcid:(NSString *)cid type:(ClassifyVideoSearchType)type keyword:(NSString *)keyword status:(NSString *)status page:(int)page success:(void (^)(NSArray *list, NSInteger total))success failure:(void (^)(NSError *error))failure;

@end
