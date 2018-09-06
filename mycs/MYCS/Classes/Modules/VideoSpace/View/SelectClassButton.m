//
//  SelectClassButton.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/11.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SelectClassButton.h"
#import "VideoSpaceModel.h"

@interface SelectClassButton ()

@property (nonatomic,strong) UIImageView *selectIconView;

@end

@implementation SelectClassButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.layer.borderWidth = 1;
    
    [self setTitleColor:HEXRGB(0x666666) forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self setTitleColor:HEXRGB(0x47c1a9) forState:UIControlStateSelected];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame])
    {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
        self.layer.borderWidth = 1;
        
        [self setTitleColor:HEXRGB(0x666666) forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:13];

        [self setTitleColor:HEXRGB(0x47c1a9) forState:UIControlStateSelected];

    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected)
    {
        self.layer.borderColor = HEXRGB(0x47c1a8).CGColor;
        [self setTitleColor:HEXRGB(0x47c1a9) forState:UIControlStateNormal];

        [self addSubview:self.selectIconView];
    }
    else
    {
        [self setTitleColor:HEXRGB(0x333333) forState:UIControlStateNormal];

        self.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
        [self.selectIconView removeFromSuperview];
    }
    
}

- (UIImageView *)selectIconView {
    if (!_selectIconView) {
        _selectIconView = [UIImageView new];
        
        CGFloat buttonW = (ScreenW-10*2-15*2)/3;

        _selectIconView.image = [UIImage imageNamed:@"choose-0"];
        _selectIconView.frame = CGRectMake(buttonW-23, 40-22, 23, 22);
    }
    return _selectIconView;
}

@end
