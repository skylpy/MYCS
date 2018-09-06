//
//  HomeQRCodeController.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/13.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeQRCodeController;
@protocol HomeQRCodeControllerDelegate <NSObject>

- (void)scanResultWith:(HomeQRCodeController *)controller resultString:(NSString *)result;

@end

@interface HomeQRCodeController : UIViewController

@property (nonatomic, weak) id<HomeQRCodeControllerDelegate> delegate;

@end
