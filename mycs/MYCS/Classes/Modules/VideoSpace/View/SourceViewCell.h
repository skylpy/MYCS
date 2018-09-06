//
//  SourceViewCell.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/11.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SourceViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@property (nonatomic, copy) void (^chooseButtonAction)(SourceViewCell *cell,UIButton *button);

- (void)setupWithTitle:(NSString *)title level:(NSInteger)level chooseButtonSelected:(BOOL)selected;

- (void)setArrowHiden:(BOOL)hiden;

- (BOOL)isArrowHiden;

- (void)setArrowDirection:(BOOL)expand;

@end
