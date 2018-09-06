//
//  SearchMoreOtherController.h
//  MYCS
//
//  Created by wzyswork on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchMoreOtherController : UIViewController

@property(nonatomic,copy) NSString *keyword;

@property(nonatomic,assign) int type;//0-医生，1-科室，2-医院，3-实验室，4-企业，5资讯

@end
