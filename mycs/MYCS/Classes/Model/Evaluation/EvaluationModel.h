//
//  EvaluationModel.h
//  MYCS
//
//  Created by Yell on 16/1/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "JSONModel.h"

typedef enum{
    EvaluationStutasTypeAccept,
    EvaluationStutasTypeSend
} EvaluationStutasType;


typedef enum {
    EvaluationTargetTypeExchange = 0,
    EvaluationTargetTypeVideo = 1,
    EvaluationTargetTypeCase = 4,
    EvaluationTargetTypeInsiders = 5
}EvaluationTargetType;

typedef enum{
    EvalutaionTableViewTypeOther,//学术交流，案例中心，视频空间
    EvalutaionTableViewTypeInsiders//评价
    
    
} EvalutaionTableViewType;

@protocol EvaluationOtherModel <NSObject>

@end

@interface EvaluationOtherModel : JSONModel

@property (nonatomic,copy)NSString<Optional> *id;
@property (nonatomic,copy)NSString<Optional> *from_uid;
@property (nonatomic,copy)NSString<Optional> *reply_uid;
@property (nonatomic,copy)NSString<Optional> *to_uid;
@property (nonatomic,copy)NSString<Optional> *reply_id;
@property (nonatomic,copy)NSString<Optional> *parent_id;
@property (nonatomic,copy)NSString<Optional> *addTime;
@property (nonatomic,copy)NSString<Optional> *title;
@property (nonatomic,copy)NSString<Optional> *content;
@property (nonatomic,copy)NSString<Optional> *target_id;
@property (nonatomic,copy)NSString<Optional> *target_type;
@property (nonatomic,copy)NSString<Optional> *praiseNum;
@property (nonatomic,copy)NSString<Optional> *isRead;
@property (nonatomic,copy)NSString<Optional> *reply_title;
@property (nonatomic,copy)NSString<Optional> *from_image;
@property (nonatomic,copy)NSString<Optional> *reply_content;
@property (nonatomic,copy)NSString<Optional> *reply_image;
@property (nonatomic,copy)NSString<Optional> *reply_realname;
@property (nonatomic,copy)NSString<Optional> *from_realname;

@end


@protocol EvaluationInsidersModel <NSObject>

@end

@interface EvaluationInsidersModel : JSONModel

@property (nonatomic,copy)NSString<Optional> *id;
@property (nonatomic,copy)NSString<Optional> *content;
@property (nonatomic,copy)NSString<Optional> *score;
@property (nonatomic,copy)NSString<Optional> *addTime;
@property (nonatomic,copy)NSString<Optional> *from_uid;
@property (nonatomic,copy)NSString<Optional> *to_uid;
@property (nonatomic,copy)NSString<Optional> *praiseNum;
@property (nonatomic,copy)NSString<Optional> *image;//from_image;
@property (nonatomic,copy)NSString<Optional> *reply_image;
@property (nonatomic,copy)NSString<Optional> *reply_realname;
@property (nonatomic,copy)NSString<Optional> *from_realname;

@end

@interface EvaluationListModel : JSONModel

@property (nonatomic,copy)NSString *iconName;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,assign) EvaluationTargetType targetType;
@property (nonatomic,assign) EvalutaionTableViewType ViewType;

+(instancetype)makeEvaluationListModelWithIconName:(NSString *)iconName Title:(NSString *)title TargetType:(EvaluationTargetType)targetType ViewType:(EvalutaionTableViewType)viewType;

@end

@interface EvaluationCommentCountModel : JSONModel

@property (nonatomic,copy)NSString<Optional> *count;
@property (nonatomic,copy)NSString<Optional> *target_name;

@end
@interface EvaluationModel : JSONModel



+(void)getInsidersListWithListType:(EvaluationStutasType)type page:(int)page Success:(void(^)(NSArray * list))success Failure:(void(^)(NSError* error))failure;

+(void)getOtherListWithListType:(EvaluationStutasType)listType targetType:(EvaluationTargetType)targetType page:(int)page Success:(void(^)(NSArray * list))success Failure:(void(^)(NSError* error))failure;

+(void)sendReplyCommentWithParentId:(NSString *)parentId targetId:(NSString *)targetId targetType:(NSString *)targetType replyId:(NSString *)replyId reply_uid:(NSString *)reply_uid toUid:(NSString *)toUid contentStr:(NSString *)contentStr Success:(void(^)(void))success Failure:(void(^)(NSError* error))failure;

+(void)getNotReadCommentCountSuccess:(void(^)(NSArray * list))success Failure:(void(^)(NSError* error))failure;

@end
