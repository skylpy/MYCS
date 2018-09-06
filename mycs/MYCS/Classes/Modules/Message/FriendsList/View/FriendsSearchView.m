//
//  FriendsSearchView.m
//  MYCS
//
//  Created by Yell on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "FriendsSearchView.h"
#import "SearchFriendListView.h"
@interface FriendsSearchView ()

@property (nonatomic,strong) SearchFriendListView * listView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation FriendsSearchView

+(instancetype)FriendsSearchView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"FriendsSearchView" owner:nil options:nil]lastObject];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.searchBtn.layer.cornerRadius = 2;
}
- (IBAction)searchBtnAction:(UIButton *)sender {
    self.listView = [SearchFriendListView SearchFriendListView];
    self.listView.frame = [AppDelegate sharedAppDelegate].window.frame;
    [[AppDelegate sharedAppDelegate].window addSubview:self.listView];
    
}

@end
