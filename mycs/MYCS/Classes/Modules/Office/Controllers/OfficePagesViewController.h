//
//  OfficePagesViewController.h
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,OfficeType) {
    OfficeTypeOffice = 1,//科室
    OfficeTypeHospital = 2,//医院
    OfficeTypeLaboratory = 3,//实验室
    OfficeTypeEnterprise = 4,//企业
    OfficeTypeAcademy    = 5//学院
};
@interface OfficePagesViewController : UIViewController

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,assign) OfficeType type;//1 - 科室;2 - 医院 ；3-实验室 ;4-企业; 5-学院;

@property (nonatomic,assign) BOOL isHospitalOrOffice;//医院和科室为YES其他为NO

@end
