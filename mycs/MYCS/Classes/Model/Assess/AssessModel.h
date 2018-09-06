//
//  AssessModel.h
//  MYCS
//
//  Created by Yell on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "JSONModel.h"

@protocol AssessChapterModel <NSObject>

@end
@interface AssessChapterModel : JSONModel

@property (nonatomic,copy) NSString * chapterId;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * video_id;
@property (nonatomic,assign) BOOL try;
@property (nonatomic,assign) BOOL passStatus;
@property (nonatomic,assign) NSNumber *listOrder;
@property (nonatomic,assign) BOOL canDo;

@end

@protocol AssessChaptersListModel <NSObject>

@end
@interface AssessChaptersListModel : JSONModel

@property (nonatomic,copy) NSString * total;
@property (nonatomic,strong) NSArray<AssessChapterModel>* list;

@end

@protocol AssessCourseModel <NSObject>

@end

@interface AssessCourseModel : JSONModel

@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * sop_id;
@property (nonatomic,copy) NSString * course_id;
@property (nonatomic,copy) NSString * pass_rate;
@property (nonatomic,assign) NSNumber *listOrder;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,strong) AssessChaptersListModel *chapter;

@end


@interface AssessModel : JSONModel

+(void)getSOPListWithSopId:(NSString *)sopId taskId:(NSString *)taskId Success:(void(^)(NSArray *list))success failure:(void(^)(NSError * error))failure;

+(void)getCourseListWithCourseId:(NSString *)courseId taskId:(NSString *)taskId Success:(void(^)(NSArray *list))success failure:(void(^)(NSError * error))failure;

@end
