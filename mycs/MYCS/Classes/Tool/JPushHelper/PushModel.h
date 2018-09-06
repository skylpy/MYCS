//
//  PushModel.h
//  MYCS
//
//  Created by wzyswork on 16/2/24.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushModel : NSObject

@property (nonatomic,strong) NSString * title;

@property (nonatomic,strong) NSString * details;

@property (nonatomic,assign)int type;

@property (nonatomic,strong) NSString * link_id;

@property (nonatomic,strong) NSString * taskResId;

@property (nonatomic,strong) NSString * newsLinkUrl;

@end
