//
//  PersonCardViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PersonCardViewController.h"

#import "MySheetView.h"
#import "UIImageView+WebCache.h"
#import "UMengHelper.h"
#import "ShareToolBar.h"

@interface PersonCardViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgIconView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UIImageView *QRCodeView;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *hospitalL;

@property (weak, nonatomic) IBOutlet UILabel *divisionL;

@property (weak, nonatomic) IBOutlet UILabel *jobL;

@property (weak, nonatomic) IBOutlet UILabel *webL;

@property (weak, nonatomic) IBOutlet UIView *statusView;

@property (strong, nonatomic)ShareToolBar * toolBar;
@end

@implementation PersonCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgIconView.layer.cornerRadius = self.bgIconView.width * 0.5;
    self.bgIconView.layer.masksToBounds = YES;
    
    self.iconView.layer.cornerRadius = self.iconView.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.contentMode = UIViewContentModeScaleToFill;
    
    UILongPressGestureRecognizer *longGest = [[UILongPressGestureRecognizer alloc] init];
    
    [self.view addGestureRecognizer:longGest];
    [longGest addTarget:self action:@selector(longPressView:)];
    
    [self biuldUI];
    
}
#pragma mark - *** 数据加载 ***
-(void)biuldUI
{
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.doctorInfo.imgUrl] placeholderImage:PlaceHolderImage];
    
    [self.QRCodeView sd_setImageWithURL:[NSURL URLWithString:self.doctorInfo.perQrCode] placeholderImage:PlaceHolderImage];
    
    self.nameL.text = self.doctorInfo.realname;
    
    self.hospitalL.text = self.doctorInfo.hospital;
    
    self.divisionL.text = self.doctorInfo.divisionName;
    
    self.jobL.text = self.doctorInfo.jobTitle;
    
    self.webL.text = self.doctorInfo.myurl;
    
}

#pragma mark - *** 长按手势 ***
- (void)longPressView:(UILongPressGestureRecognizer *)longGest
{
    
    if (longGest.state == UIGestureRecognizerStateBegan){
        
        self.statusView.hidden = YES;
        
        [MySheetView showInView:self andBlock:^(MySheetView * sheet, NSInteger index) {
            
            [sheet removeFromSuperview];
            
            if (index == 2)
            {
                [self savePersonCardPicture];
            }
            
            self.statusView.hidden = NO;
            
        }];
        
    }
    
}

#pragma mark -- 保存名片到手机
-(void)savePersonCardPicture
{
    
    UIImageWriteToSavedPhotosAlbum([self renderImage], nil, nil, nil);
    [self showSuccessWithStatusHUD:@"保存成功"];
}


- (IBAction)backAction:(id)sender
{
    if (self.backBlok)
    {
        self.backBlok();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - *** exchageAction ***
- (IBAction)exchageAction:(id)sender {
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    
    //这里时查找视图里的子视图（这种情况查找，可能时因为父视图里面不只两个视图）
    NSInteger fist= [[self.view subviews] indexOfObject:[self.view viewWithTag:100]];
    NSInteger seconde= [[self.view subviews] indexOfObject:[self.view viewWithTag:101]];
    
    [self.view exchangeSubviewAtIndex:fist withSubviewAtIndex:seconde];
    
    [UIView setAnimationDelegate:self];
    
    [UIView commitAnimations];
    
}


#pragma mark - *** 截取屏幕 ***
- (UIImage *)renderImage{
    
    self.statusView.hidden = YES;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ScreenW, ScreenH), NO, 0);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.statusView.hidden = NO;
    
    return newImage;
}

- (void)setDoctorInfo:(DoctorInfoModel *)doctorInfo
{
    _doctorInfo = doctorInfo;
}

#pragma mark - *** shareAction ***
- (IBAction)shareAction:(id)sender
{
    [self.toolBar removeFromSuperview];
    
    self.toolBar = [ShareToolBar shareToolBar];
    
    [self.toolBar showInView:self.view Block:^(NSString * type, ShareToolBar *toolBar) {
        
        [UMengHelper shareImageWith:[self renderImage] title:[NSString stringWithFormat:@"%@名片",_doctorInfo.realname] content:_doctorInfo.skill shareType:type];
    }];
}


- (void)didReceiveMemoryWarning
{
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
