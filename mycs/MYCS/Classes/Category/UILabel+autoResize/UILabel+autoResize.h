//
//  UILabel+autoResize.h
//  Starbucks
//
//  Created by Alex Peng on 8/30/13.
//  Copyright (c) 2013 FabriQate Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (autoResize)

@property(nonatomic,setter = setAutoResize:) BOOL autoResize;

/**
 *  <#Description#>
 *
 *  @param maxSize <#maxSize description#>
 */
- (void)resizeWithMaxSize:(CGSize)maxSize;

@end
