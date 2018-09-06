//
//  ClassifyListCollectionViewCell.m
//  MYCS
//
//  Created by Yell on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ClassifyListCollectionViewCell.h"

@interface ClassifyListCollectionViewCell   ()

@end

@implementation ClassifyListCollectionViewCell
-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.layer.borderWidth = 1.f;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}


@end
