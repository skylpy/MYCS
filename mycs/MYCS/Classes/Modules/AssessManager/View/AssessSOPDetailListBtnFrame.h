//
//  AssessSOPDetailListBtnFrame.h
//  MYCS
//
//  Created by Yell on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssessSOPDetailListBtnFrame : NSObject

@property(nonatomic,strong)NSMutableArray * modelList;


@property(nonatomic,assign)CGFloat hiddenViewHeight;

@property(nonatomic,assign)int  BtnCountInRow;

@property(nonatomic,assign)CGFloat ViewHeight;


-(void)calculateBtnsFrameWithArray:(NSArray *)array View:(UIView *)view;
-(void)calculateDownloadBtnsFrameWithArray:(NSArray *)array View:(UIView *)view;

@end


@interface AssessSOPDetailBtnFrameModel : NSObject


@property (copy, nonatomic) NSString *courseId;

@property (assign,nonatomic) CGRect btnModelFrame;

@property (assign,nonatomic) CGFloat inRow;

@property (assign,nonatomic) int index;

@end
