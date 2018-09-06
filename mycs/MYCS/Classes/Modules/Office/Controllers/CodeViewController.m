//
//  CodeViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "CodeViewController.h"

#import "UIImageView+WebCache.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface CodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *QRCodeView;

@property (weak, nonatomic) IBOutlet UIView *alertView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewBottom;

@end

@implementation CodeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.alertViewBottom.constant = -85;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //加载网页的内容
    self.fd_prefersNavigationBarHidden = YES;
    
    NSURL *url = [NSURL URLWithString:self.imageURL];
    
    [self.QRCodeView sd_setImageWithURL:url placeholderImage:PlaceHolderImage];
    
    UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc] init];
    
    [self.view addGestureRecognizer:longPressGest];
    
    [longPressGest addTarget:self action:@selector(longPressGest:)];
    
    self.alertView.y = ScreenH;
}
#pragma mark -- 长按手势longPressGest Delegate
- (void)longPressGest:(UILongPressGestureRecognizer *)longGest
{
    
    if (longGest.state == UIGestureRecognizerStateBegan) {
        
        [UIView animateWithDuration:0.1 animations:^{
            self.alertViewBottom.constant = 0;
        }];
        
    }
}
#pragma mark -- back Action
- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self cancelAction:nil];
}
#pragma mark -- save Action
- (IBAction)saveAction:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.QRCodeView.image, nil, nil, nil);
    [self showSuccessWithStatusHUD:@"保存成功"];
    [self cancelAction:nil];
    
}
#pragma mark cancel Action
- (IBAction)cancelAction:(id)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.alertViewBottom.constant = -85;
        
    }];
}


@end
