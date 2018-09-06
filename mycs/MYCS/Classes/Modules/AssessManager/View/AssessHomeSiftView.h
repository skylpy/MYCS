//
//  AssessHomeSiftView.h
//  MYCS
//
//  Created by Yell on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AssessHomeSiftTypeAll = 1, //全部
    AssessHomeSiftTypeNoPass,  //未达标
    AssessHomeSiftTypePass,    //已达标
    AssessHomeSiftTypeEnd      //结束
}AssessHomeSiftType;

@class AssessHomeSiftView;
@protocol AssessHomeSiftViewDelegate <NSObject>

-(void)AssessHomeSiftView:(AssessHomeSiftView *)view WithType:(AssessHomeSiftType)type;

@end

@interface AssessHomeSiftView : UIView

@property(assign,nonatomic) AssessHomeSiftType * type;

@property(assign,nonatomic) id<AssessHomeSiftViewDelegate> delegate;

-(instancetype)initWithType:(AssessHomeSiftType)type;

@end
