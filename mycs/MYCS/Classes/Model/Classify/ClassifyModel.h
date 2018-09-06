//
//  ClassifyModel.h
//  MYCS
//
//  Created by Yell on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <JSONModel/JSONModel.h>



@protocol ClassifyModel <NSObject>
@end
@interface ClassifyModel : JSONModel

@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * text;

+(void)getListSuccess:(void(^)(NSArray * list))success failure:(void(^)(NSError * error))failure;

@end


@protocol firstClassifyModel <NSObject>
@end
@interface firstClassifyModel : JSONModel

@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * text;
@property (nonatomic,copy) NSString * state;
@property (strong, nonatomic) NSArray<ClassifyModel> *children; //二级分类列表


@end