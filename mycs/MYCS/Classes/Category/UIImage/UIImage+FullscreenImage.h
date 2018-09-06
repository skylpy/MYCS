//
//  UIImage+FullscreenImage.h
//  atest
//
//  Created by AdminZhiHua on 15/12/16.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, thisDeviceClass) {
    
    thisDeviceClass_iPhone,
    thisDeviceClass_iPhoneRetina,
    thisDeviceClass_iPhone5,
    thisDeviceClass_iPhone6,
    thisDeviceClass_iPhone6plus,
    // we can add new devices when we become aware of them
    thisDeviceClass_iPad,
    thisDeviceClass_iPadRetina,
    
    thisDeviceClass_unknown
};

thisDeviceClass currentDeviceClass();

@interface UIImage (FullscreenImage)

/*!
 *  @author zhihua, 16-12-30 15:12:40
 *
 *  根据图片名，来获取图片的实例
 *
 *  @param fileName 不带后缀的图片名 eg：newfeature_01
 *
 *  @return 图片的实例
 */
+ (instancetype )imageForDeviceWithName:(NSString *)fileName;

@end
