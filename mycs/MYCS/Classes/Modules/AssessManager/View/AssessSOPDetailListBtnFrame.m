//
//  AssessSOPDetailListBtnFrame.m
//  MYCS
//
//  Created by Yell on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AssessSOPDetailListBtnFrame.h"
#import "AssessModel.h"

#define topMargin 5
@interface AssessSOPDetailListBtnFrame()


@property (nonatomic,assign)CGFloat depHeight;




@end


@implementation AssessSOPDetailListBtnFrame



-(void)calculateBtnsFrameWithArray:(NSArray *)array View:(UIView *)view
{
    
    CGFloat BtnHeight = 40;
    CGFloat BtnWidth = 70;

    self.modelList = [NSMutableArray array];
    if (array.count == 0 || view ==nil)
        return;
    
    int numBtnInRow = view.width/BtnWidth;
    
    int marginCount = numBtnInRow+1;
    
    int margin = (view.width -numBtnInRow*BtnWidth)/marginCount;
    
    
    NSInteger btnIndex = 0 ;
    for (AssessCourseModel * model in array) {
        NSInteger row = btnIndex/numBtnInRow;
        NSInteger col = btnIndex%numBtnInRow;
        NSInteger btnX = col *(BtnWidth+ margin)+margin;
        NSInteger btnY = 0;
        NSInteger fristMarginY = 5;
        NSInteger otherMarginY = 5;

            if (row == 0) {
                btnY =fristMarginY;
            }else
            {
                btnY = row*(BtnHeight+otherMarginY)+fristMarginY;
            }
        
        AssessSOPDetailBtnFrameModel * btnModel = [[AssessSOPDetailBtnFrameModel alloc]init];
        btnModel.btnModelFrame = CGRectMake(btnX,btnY,BtnWidth, BtnHeight);
        btnModel.courseId = model.course_id;
        btnModel.inRow = row;
        [self.modelList addObject:btnModel];
        self.ViewHeight = CGRectGetMaxY(btnModel.btnModelFrame)+topMargin;
        btnIndex++;
    }
    
    if (array.count<= numBtnInRow)
        self.hiddenViewHeight = self.ViewHeight;
    else
        self.hiddenViewHeight = BtnHeight + topMargin*2;

    self.BtnCountInRow = view.width/BtnWidth;
}



-(void)calculateDownloadBtnsFrameWithArray:(NSArray *)array View:(UIView *)view
{
    
    CGFloat BtnHeight = 40;
    CGFloat BtnWidth = 80;
    self.modelList = [NSMutableArray array];
    if (array.count == 0 || view ==nil)
        return;
    
    int numBtnInRow = view.width/BtnWidth;
    
    int marginCount = numBtnInRow+1;
    
    int margin = (view.width -numBtnInRow*BtnWidth)/marginCount;
    
    
    NSInteger btnIndex = 0 ;
    for (AssessCourseModel * model in array) {
        NSInteger row = btnIndex/numBtnInRow;
        NSInteger col = btnIndex%numBtnInRow;
        NSInteger btnX = col *(BtnWidth+ margin)+margin;
        NSInteger btnY = 0;
        NSInteger fristMarginY = 5;
        NSInteger otherMarginY = 5;
        
        if (row == 0) {
            btnY =fristMarginY;
        }else
        {
            btnY = row*(BtnHeight+otherMarginY)+fristMarginY;
        }
        
        AssessSOPDetailBtnFrameModel * btnModel = [[AssessSOPDetailBtnFrameModel alloc]init];
        btnModel.btnModelFrame = CGRectMake(btnX,btnY,BtnWidth, BtnHeight);
        btnModel.courseId = model.course_id;
        btnModel.inRow = row;
        [self.modelList addObject:btnModel];
        self.ViewHeight = CGRectGetMaxY(btnModel.btnModelFrame)+topMargin;
        btnIndex++;
    }
    
    if (array.count<= numBtnInRow)
        self.hiddenViewHeight = self.ViewHeight;
    else
        self.hiddenViewHeight = BtnHeight + topMargin*2;
    
    
    self.BtnCountInRow = view.width/BtnWidth;
}


@end

@implementation AssessSOPDetailBtnFrameModel



@end
