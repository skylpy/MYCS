//
//  DefinitionView.h
//  MYCS
//
//  Created by GuiHua on 16/6/29.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefinitionView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy) NSString *selectStr;

+ (instancetype)showInView:(UIView *)superView andSelectStr:(NSString *)selectStr and:(void (^)())block;

@property (nonatomic,copy) void(^cellClickBlock)(DefinitionView *definitionView, NSString *str);

@property (copy, nonatomic) void (^block)();

-(void)dismissWithBlock:(void (^)())block;

@end
