//
//  SopDownloadCell.h
//  MYCS
//
//  Created by AdminZhiHua on 16/2/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SopCourseModel;
@interface SopDownloadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong) SopCourseModel *course;

@property (nonatomic,copy) NSString *sopId;

@property (assign,nonatomic) BOOL isOpen;

@property (nonatomic,copy) void(^cellHeaderAction)(void);

- (CGFloat)heightForCellWith:(SopCourseModel *)course;

@end
