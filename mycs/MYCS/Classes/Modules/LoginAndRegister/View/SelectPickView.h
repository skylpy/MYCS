//
//  SelectPickView.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/15.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumDefine.h"


@interface SelectPickView : UIView

@property (nonatomic,assign) SelectPickViewType type;

@property (nonatomic,strong) void(^actionBlock)(SelectPickView *view,NSString *selectString,NSString *provId,NSString *cityId,NSString *areaId,NSString *itemId);

//修改城市用的
+(instancetype)selectPickView;

-(void)selectWith:(NSString *)prov andCity:(NSString *)city andArea:(NSString *)area;

- (void)showWithBlock:(void(^)(SelectPickView *view,NSString *selectString,NSString *provId,NSString *cityId,NSString *areaId,NSString *itemId))completeBlock;

//注册用的
+ (void)showWithType:(SelectPickViewType)type complete:(void(^)(SelectPickView *view,NSString *selectString,NSString *provId,NSString *cityId,NSString *areaId,NSString *itemId))completeBlock;

@end
