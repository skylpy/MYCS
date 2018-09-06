//
//  TaskExamDeatilModel.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/20.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Taskone,SoptEmplate,TaskCourseList,TaskChapters,TaskPapers,TaskItems,TaskOption;
@interface TaskExamDeatilModel : NSObject


@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger sopId;

@property (nonatomic, copy) NSString *extra;

@property (nonatomic, strong) SoptEmplate *sopTemplate;

@property (nonatomic, strong) NSArray<TaskCourseList *> *courseList;

@property (nonatomic, copy) NSString *sopName;

@property (nonatomic, assign) NSInteger issueTime;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger requireNum;

@property (nonatomic, assign) NSInteger endTime;

@property (nonatomic, copy) NSString *taskId;

@property (nonatomic, assign) NSInteger addTime;

@property (nonatomic, assign) NSInteger add_uid;

@property (nonatomic, copy) NSString *from_deptId;

@property (nonatomic, assign) NSInteger actualNum;

@property (nonatomic, strong) Taskone *taskOne;

@property (nonatomic, assign) NSInteger status;

+ (void)employeeTestDetailWith:(NSString *)taskId taskType:(int)type employeeId:(NSString *)uid success:(void (^)(TaskExamDeatilModel *))success failure:(void (^)(NSError *))failure;

@end
@interface Taskone : NSObject

@property (nonatomic, copy) NSString *entity;

@end

@interface SoptEmplate : NSObject

@property (nonatomic, copy) NSString *entity;

@end

@interface TaskCourseList : NSObject

@property (nonatomic, assign) NSInteger course_id;

@property (nonatomic, assign) NSInteger taskId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<TaskChapters *> *chapters;

@end

@interface TaskChapters : NSObject

@property (nonatomic, assign) NSInteger chapterId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *percent;

@property (nonatomic, strong) NSArray<TaskPapers *> *papers;

@property (nonatomic,assign,getter=isExpand) BOOL expand;

@end

@interface TaskPapers : NSObject

@property (nonatomic, assign) NSInteger paperId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<TaskItems *> *items;

@end

@interface TaskItems : NSObject

@property (nonatomic, assign) NSInteger itemId;

@property (nonatomic, copy) NSString *answer;

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, assign) NSInteger passed;

@property (nonatomic, strong) NSArray<TaskOption *> *option;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *type;

@end

@interface TaskOption : NSObject

@property (nonatomic, copy) NSString *index;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger selected;

@end

