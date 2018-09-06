//
//  VideoClassifyModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/1/27.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@protocol childrenListModel <NSObject>
@end
@interface childrenListModel : JSONModel
@property (strong, nonatomic) NSString *cid; //三级分类ID
@property (strong, nonatomic) NSString *name; //三级分类名
@property (strong, nonatomic) NSString *parentId;//父级Id
@end
//=======================二级分类对象======================//
@protocol SecondLevelModel <NSObject>
@end
@interface SecondLevelModel : JSONModel
@property (strong, nonatomic) NSString *cid; //二级分类ID
@property (strong, nonatomic) NSString *name; //二级分类名
@property (strong, nonatomic) NSString *type; //二级分类类型
@property (strong, nonatomic) NSArray<childrenListModel> *children; //三级分类列表
@end

//=======================一级分类对象======================//
@protocol FirstLevelModel <NSObject>
@end
@interface FirstLevelModel : JSONModel
@property (strong, nonatomic) NSString *name; //一级分类名
@property (strong, nonatomic) NSArray<SecondLevelModel> *cateList; //二级分类列表
@end


@interface VideoClassifyModel : JSONModel

+ (void)requestVideoClassifySuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end
