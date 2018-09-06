//
//  CoursePackModel.h
//  MYCS
//
//  Created by GuiHua on 16/5/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "JSONModel.h"

@protocol CoursePackChapter <NSObject>
@end
@interface CoursePackChapter : JSONModel
@property (nonatomic , copy) NSString <Optional>*id;
@property (nonatomic , copy) NSString <Optional>*directoryId;
@property (nonatomic , copy) NSString <Optional>*video_id;
@property (nonatomic , copy) NSString <Optional>*chapterName;
@property (nonatomic , copy) NSString <Optional>*duration;
@property (nonatomic , copy) NSString <Optional>*title;
@property (nonatomic , copy) NSString <Optional>*url;
@property (nonatomic , copy) NSString <Optional>* isSelect;
@end

@protocol CoursePackModel <NSObject>
@end
@interface CoursePackModel : JSONModel
@property (nonatomic , copy) NSString <Optional>*id;
@property (nonatomic , copy) NSString <Optional>*coursePackId;
@property (nonatomic , copy) NSString <Optional>*directoryName;
@property (nonatomic , copy) NSString <Optional>*chapters;
@property (nonatomic , strong)NSArray<Optional> *chapterData;
@property (nonatomic , strong)NSMutableArray<Optional> *coursePackChapters;
@property (nonatomic,copy) NSString <Optional>*isSelect;

+ (void)requestCoursePackModelWithID:(NSString *)Id andIsAjax:(NSInteger)isAjax Success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end

@protocol CoursePackListModel <NSObject>
@end
@interface CoursePackListModel : JSONModel
@property (nonatomic , copy) NSString <Optional>*id;//课程的时候相当于URL的值
@property (nonatomic , copy) NSString <Optional>*tmpId;
@property (nonatomic , copy) NSString <Optional>*picUrl;
@property (nonatomic , copy) NSString <Optional>*price;
@property (nonatomic , copy) NSString <Optional>*name;
@property (nonatomic , copy) NSString <Optional>*describe;
@property (nonatomic , copy) NSString <Optional>*type;
@property (nonatomic , copy) NSString <Optional>*up;
@property (nonatomic , copy) NSString <Optional>*clickType;
@property (nonatomic , copy) NSString <Optional>*click;


+ (void)requestCoursePackListWithPage:(NSInteger)page andKeyWord:(NSString *)keyword Success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end






