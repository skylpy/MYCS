//
//  TaskObject.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskObject : NSObject

@property (nonatomic, assign) NSInteger deptId;

@property (nonatomic, assign) NSInteger listOrder;

@property (nonatomic, strong) NSArray<TaskObject *> *children;

@property (nonatomic, copy) NSString *deptName;

@property (nonatomic, assign) NSInteger enterprise_uid;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *hasChild;

@property (nonatomic, assign) NSInteger parent_id;

@property (nonatomic, strong) NSArray *user_staff;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, assign) NSInteger bindUid;

@property (nonatomic,assign,getter=isExpand) BOOL expand;
@property (nonatomic,assign,getter=isArrowUp) BOOL arrowUp;

//新增字段，选择对象
@property (assign,nonatomic,getter=isSelect)BOOL select;
@property (assign,nonatomic,getter=isHasChildSelect)BOOL hasChildSelect;
@property (assign,nonatomic,getter=isNoChildSelect)BOOL noChildSelect;
@property (assign,nonatomic,getter=isChildSelect)BOOL childSelect;

@property (assign,nonatomic)NSInteger  childIndex;

+ (void)departmentConcatWithSuccess:(void (^)(NSArray *TaskObjectList))success failure:(void (^)(NSError *))failure;

+ (void)taskDepartmentConcatWithSuccess:(void (^)(NSArray *TaskObjectList))success failure:(void (^)(NSError *))failure ;

+ (void)taskDepartmentDevelopmentCommissionConcatWithGovType:(NSString *)govType Success:(void (^)(NSArray *TaskObjectList))success failure:(void (^)(NSError *))failure ;

@end


