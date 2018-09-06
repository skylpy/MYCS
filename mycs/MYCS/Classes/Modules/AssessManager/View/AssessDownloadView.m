//
//  AssessDownloadView.m
//  MYCS
//
//  Created by Yell on 16/1/27.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AssessDownloadView.h"
@interface AssessSOPDownloadView ()
@property (weak, nonatomic) IBOutlet UIButton *downloadListBtn;
@property (weak, nonatomic) IBOutlet UIButton *allDownloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;


@end

@implementation AssessSOPDownloadView



- (IBAction)BGBtnAction:(id)sender {
    
    [self removeFromSuperview];
}

@end
