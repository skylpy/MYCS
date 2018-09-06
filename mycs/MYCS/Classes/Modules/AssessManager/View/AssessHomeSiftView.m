//
//  AssessHomeSiftView.m
//  MYCS
//
//  Created by Yell on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AssessHomeSiftView.h"
@interface AssessHomeSiftView ()

@property (weak,nonatomic) UIButton * selelctedBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *passBtn;
@property (weak, nonatomic) IBOutlet UIButton *noPassBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;


@end


@implementation AssessHomeSiftView


-(instancetype)initWithType:(AssessHomeSiftType)type
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AssessHomeSiftView" owner:nil options:nil]lastObject];
        [self selectBtnWithType:type];
    }
    return self;
}

-(void)selectBtnWithType:(AssessHomeSiftType)type
{
    switch (type) {
        case AssessHomeSiftTypeAll:
            self.selelctedBtn.selected = NO;
            self.allBtn.selected = YES;
            self.selelctedBtn = self.allBtn;
            break;
        case AssessHomeSiftTypePass:
            self.selelctedBtn.selected = NO;
            self.passBtn.selected = YES;
            self.selelctedBtn = self.passBtn;
            break;
        case AssessHomeSiftTypeNoPass:
            self.selelctedBtn.selected = NO;
            self.noPassBtn.selected = YES;
            self.selelctedBtn = self.noPassBtn;
            break;
        case AssessHomeSiftTypeEnd:
            self.selelctedBtn.selected = NO;
            self.endBtn.selected = YES;
            self.selelctedBtn = self.endBtn;
            break;
            
        default:
            break;
    }
}
- (IBAction)selectBtnAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(AssessHomeSiftView:WithType:)]) {
        
        int senderTag =(int) sender.tag;
        [self.delegate AssessHomeSiftView:self WithType:senderTag];
    }    
}

- (IBAction)BGbtnAction:(id)sender {
    [self removeFromSuperview];
}


@end
