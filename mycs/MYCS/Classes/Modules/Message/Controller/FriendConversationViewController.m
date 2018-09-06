//
//  FriendConversationViewController.m
//  MYCS
//
//  Created by Yell on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "FriendConversationViewController.h"
#import "ConstKeys.h"
#import "FriendModel.h"

@interface FriendConversationViewController ()

@end

@implementation FriendConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.conversationListTableView.tableFooterView = [[UIView alloc]init];
    self.isEnteredToCollectionViewController = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.listDelegate respondsToSelector:@selector(selectListCellWithTargetId:)]) {
        [self.listDelegate selectListCellWithTargetId:model.targetId];
    }

}

- (void)didTapCellPortrait:(RCConversationModel *)model
{
    
    if ([self.listDelegate respondsToSelector:@selector(selectListCellWithTargetId:)]) {
        [self.listDelegate selectListCellWithTargetId:model.targetId];
    }
}


- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    return dataSource;
}

- (void)didReceiveMessageNotification:(NSNotification *)notification
{
    [super didReceiveMessageNotification:notification];
    [[NSNotificationCenter defaultCenter] postNotificationName:NewIMMessage object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
