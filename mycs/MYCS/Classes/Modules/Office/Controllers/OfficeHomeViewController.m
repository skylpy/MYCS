//
//  OfficeHomeViewController.m
//  MYCS
//
//  Created by money on 16/4/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "OfficeHomeViewController.h"
#import "OfficeHomeWebViewController.h"

@interface OfficeHomeViewController ()

@end

@implementation OfficeHomeViewController

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [UMAnalyticsHelper endLogPageName:@"学院"];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [UMAnalyticsHelper beginLogPageName:@"学院"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    OfficeHomeWebViewController * HWebVC = self.childViewControllers[0];
    
    [HWebVC loadRequestWithURL:_url showProgressView:YES];
    
}

-(void)setUrl:(NSString *)url
{
    _url = url;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
