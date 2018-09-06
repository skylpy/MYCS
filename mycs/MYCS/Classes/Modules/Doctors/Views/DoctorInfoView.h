//
//  DoctorInfoView.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *addL;
@property (weak, nonatomic) IBOutlet UILabel *hospitalL;
@property (weak, nonatomic) IBOutlet UILabel *divisionL;
@property (weak, nonatomic) IBOutlet UILabel *quarterL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

+ (instancetype)doctorInfoView;

@end
