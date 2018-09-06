//
//  DiseaseViewController.h
//  MYCS
//
//  Created by GuiHua on 16/7/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiseaseViewController : UIViewController

/**
 *  @author GuiHua, 16-07-14 16:07:37
 *
 *  用于筛选不同的疾病
 *  @param diseaseCategoryId 疾病类别ID
 */
-(void)loadDataWithDiseaseCategoryId:(NSString *)diseaseCategoryId;

@end
