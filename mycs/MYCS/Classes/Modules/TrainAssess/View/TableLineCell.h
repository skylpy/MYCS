//
//  TableLineCell.h
//  MYCS
//
//  Created by yiqun on 16/8/29.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChapterModel;
@interface TableLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chapterName;
@property (weak, nonatomic) IBOutlet UILabel *passRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (nonatomic,strong) ChapterModel *chapters;

-(void)cellReloadData:(ChapterModel *)chaper andIndexPath:(NSIndexPath *)indexPath;

@end
