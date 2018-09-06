//
//  PopValidateView.h
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidateCodeView : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

+ (void)popWithView:(UIView*)aView phoneNumber:(NSString *)phoneNumber Completion: (void(^)(NSString *validateCode))completion;

@end
