//
//  ZHMemberInfo.h
//  SWWY
//
//  Created by zhihua on 15/5/10.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHMemberInfo : NSObject

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *sid;
@property (nonatomic,copy) NSString *avatar;

@end

@interface ZHMemberInfoResutl : NSObject

@property (nonatomic,copy) NSString *total;

@property (nonatomic,strong) NSArray *list;

@end


