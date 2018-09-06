//
//  AssessTaskDetailTableViewCell.h
//  MYCS
//
//  Created by Yell on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessModel.h"

@interface AssessTaskDetailTableViewCell : UITableViewCell



@property (nonatomic,strong) AssessChapterModel *model;
@property (weak, nonatomic) IBOutlet UILabel *chapterLabel;

@end
