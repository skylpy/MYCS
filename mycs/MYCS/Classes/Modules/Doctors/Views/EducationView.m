//
//  EducationView.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "EducationView.h"
#import "NSDate+Util.h"

@interface EducationView ()

@property (weak, nonatomic) IBOutlet UILabel *educationL;
@property (weak, nonatomic) IBOutlet UILabel *professionL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *professionLConstraintW;

@property (weak, nonatomic) IBOutlet UILabel *degreeL;


@end

@implementation EducationView

+ (instancetype)educationView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"EducationView" owner:nil options:nil] lastObject];
}

- (void)setEudcation:(Education *)eudcation
{
    _eudcation = eudcation;
    
    NSString *startTime = [NSDate dateWithTimeInterval:[eudcation.start_time floatValue] format:@"yyyy-MM-dd"];
    NSString *endTime = [NSDate dateWithTimeInterval:[eudcation.end_time floatValue] format:@"yyyy-MM-dd"];
    
    NSString *eduStr = [NSString stringWithFormat:@"%@(%@ 至 %@)",eudcation.school,startTime,endTime];
    
    self.educationL.text = eduStr;
    
    self.professionL.text = eudcation.major;
    [self.professionL sizeToFit];
    self.professionLConstraintW.constant = self.professionL.width;
    
    self.degreeL.text = eudcation.degree;
    self.height = 50;
    
}
- (void)setFrame:(CGRect)frame
{
    frame.size.height = 50;
    
    [super setFrame:frame];
    
}
@end
