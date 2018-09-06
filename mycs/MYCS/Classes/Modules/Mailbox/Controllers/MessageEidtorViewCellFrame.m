//
//  MessageEidtorViewCellFrame.m
//  SWWY
//
//  Created by Yell on 15/5/10.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "MessageEidtorViewCellFrame.h"

#import "BtnFrameModel.h"

#define nameFont 14
#define imageWH 8
#define margin 10
#define numBtnInRow 2

@interface MessageEidtorViewCellFrame ()

@property (nonatomic,assign)CGFloat depHeight;

@end

@implementation MessageEidtorViewCellFrame

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.modelList = [NSMutableArray array];
    }
    return self;
}

-(CGSize )SizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    CGSize Size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return Size;
}


-(void)setPeopleList:(NSArray *)peopleList
{
    if (!_peopleList) {
        
        CGFloat btnH = 30;
        CGFloat btnW = (self.btnEndX -self.btnBeginX-margin*numBtnInRow)/numBtnInRow;
        _peopleList = peopleList;
        NSInteger btnIndex = 0 ;
        
        for (ReceiverModel * model in peopleList)
        {
            NSInteger row = btnIndex/numBtnInRow;
            NSInteger col = btnIndex%numBtnInRow;
            NSInteger btnX = col * (btnW + margin)+self.btnBeginX;
            
            NSInteger btnY = 0;
            NSInteger fristMarginY = 12;
            NSInteger otherMarginY = 10;
            
            if (peopleList.count <=numBtnInRow)
            {
                btnY = (self.height-btnH)/2;
            }else
            {
                if (row == 0)
                {
                    btnY =fristMarginY;
                }else
                {
                    btnY = row*(btnH+otherMarginY)+fristMarginY;
                }
            }
            
            BtnFrameModel * btnModel = [[BtnFrameModel alloc]init];
            btnModel.type = model.type;
            btnModel.btnModelFrame = CGRectMake(btnX,btnY,btnW, btnH);
            btnModel.index = btnIndex;
            btnModel.userName = model.userName;
            btnModel.userID = model.userID;
            btnModel.inRow = row;
            [self.modelList addObject:btnModel];
            
            if (row > 2)
            {
                CGFloat hiddenY = 12;
                CGFloat hiddenMargin = 15;
                
                self.cellHeight =CGRectGetMaxY(btnModel.btnModelFrame)+15+hiddenY +hiddenMargin;
                
            }else if (row == 2)
            {
                CGFloat hiddenY = 12;
                CGFloat hiddenMargin = 15;
                
                self.cellHeight = CGRectGetMaxY(btnModel.btnModelFrame)+margin ;
                
                self.hiddenCellHeight = CGRectGetMaxY(btnModel.btnModelFrame)+15+hiddenY+hiddenMargin;
                
            }else
            {
                
                self.cellHeight = CGRectGetMaxY(btnModel.btnModelFrame)+margin ;
            }
            
            self.rowNum = row;
            btnIndex++;
            
        }
        
        
        
        
        
    }
}


@end
