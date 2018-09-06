//
//  EdictVideoViewController.m
//  MYCS
//
//  Created by wzyswork on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "EdictVideoViewController.h"

#import "UIImageView+WebCache.h"

typedef NS_ENUM(NSUInteger,Type) {
    TypeVideo = 1,
    TypeCourse = 2,
    TypeSOP = 3
};

@interface EdictVideoViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeight;

@property (weak, nonatomic) IBOutlet UILabel *typeL;

@property (weak, nonatomic) IBOutlet UILabel *upPersonalL;

@property (weak, nonatomic) IBOutlet UILabel *introduceL;

@property (weak, nonatomic) IBOutlet UITextField *textfield;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *textfieldName;

@property (nonatomic,strong) NSString * ID;

@property (nonatomic,assign) Type type;

@end

@implementation EdictVideoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textfield.layer.borderWidth = 1;
    self.textfield.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.textfield.delegate = self;
    self.textfield.layer.cornerRadius = 4;
    
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.textView.delegate = self;
    self.textView.layer.cornerRadius = 4;
    
    [self setVideoDetail:self.videoDetail];
    [self setCourseDetail:self.courseDetail];
    [self setSopDetail:self.sopDetail];
    
}

-(void)setVideoDetail:(VideoDetail *)videoDetail
{
    if (videoDetail == nil)return;
    
    _videoDetail = videoDetail;
    
    self.ID = videoDetail.id;
    self.type = TypeVideo;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:videoDetail.picurl] placeholderImage:PlaceHolderImage];
    
    self.nameL.numberOfLines = 0;
    self.nameL.text = videoDetail.title;
    [self.nameL sizeToFit];
    self.nameHeight.constant = self.nameL.height;
    
    if (videoDetail.type == 0)
    {
        self.upPersonalL.text = @"自制";
    }else
    {
        self.upPersonalL.text = videoDetail.from;
    }
    self.typeL.text = videoDetail.category;
    self.textfieldName.text = @"视频名称";
    self.textfield.text = videoDetail.title;
    self.introduceL.text = @"视频说明";
    self.textView.text = videoDetail.describe;
    
    self.title = @"视频编辑";
}
-(void)setCourseDetail:(CourseDetail *)courseDetail
{
    if(courseDetail == nil)return;
    
    _courseDetail = courseDetail;
    
    self.ID = courseDetail.id;
    self.type = TypeCourse;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:courseDetail.image] placeholderImage:PlaceHolderImage];
    
    self.nameL.numberOfLines = 0;
    self.nameL.text = courseDetail.name;
    [self.nameL sizeToFit];
    self.nameHeight.constant = self.nameL.height;
    
    if (courseDetail.source == 0)
    {
        self.upPersonalL.text = @"自制";
    }else
    {
        self.upPersonalL.text = courseDetail.author;
    }
    self.typeL.text = courseDetail.category;
    self.textfieldName.text = @"教程名称";
    self.textfield.text = courseDetail.name;
    self.introduceL.text = @"教程说明";
    self.textView.text = courseDetail.introduction;
    
    self.title = @"教程编辑";
}

-(void)setSopDetail:(SopDetail *)sopDetail
{
    if(sopDetail == nil)return;
    
    _sopDetail = sopDetail;
    
    self.ID = sopDetail.id;
    self.type = TypeSOP;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:sopDetail.picUrl] placeholderImage:PlaceHolderImage];
    
    self.nameL.numberOfLines = 0;
    self.nameL.text = sopDetail.name;
    [self.nameL sizeToFit];
    self.nameHeight.constant = self.nameL.height;
    
    if (sopDetail.source == 0)
    {
        self.upPersonalL.text = @"自制";
    }else
    {
        self.upPersonalL.text = sopDetail.author;
    }
    self.typeL.text = sopDetail.category;
    self.textfieldName.text = @"SOP名称";
    self.textfield.text = sopDetail.name;
    self.introduceL.text = @"SOP说明";
    self.textView.text = sopDetail.introduction;
    
    self.title = @"SOP编辑";
    
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureButtonAction:(UIBarButtonItem *)sender
{
    if ([self.textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
    {
        [self showErrorMessage:@"名称不能为空"];
        
        return;
    }
    else if ([self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
    {
        [self showErrorMessage:@"说明不能为空"];
        
        return;
    }
    
    [self showLoadingHUD];
    
    if (self.type == TypeVideo)
    {
        [VideoDetail videoEdictWithUserId:[AppManager sharedManager].user.uid videoId:self.ID title:[self.textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] describe:[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] success:^(NSString *success) {
            
            [self showSuccessWithStatusHUD:@"修改成功"];
            
            self.sureBtnBlock();
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissLoadingHUD];
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(NSError *error) {
            
            [self dismissLoadingHUD];
            
            [self showError:error];
        }];

    }
    else if (self.type == TypeCourse)
    {
        [CourseDetail courseEdictWithUserId:[AppManager sharedManager].user.uid courseId:self.ID name:[self.textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] introduction:[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] success:^(NSString * success) {
            
            [self showSuccessWithStatusHUD:@"修改成功"];
            
            self.sureBtnBlock();
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissLoadingHUD];
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(NSError *error) {
            
            [self dismissLoadingHUD];
            
            [self showError:error];
        }];

    }
    else if (self.type == TypeSOP)
    {
        [SopDetail sopEdictWithUserId:[AppManager sharedManager].user.uid sopId:self.ID name:[self.textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] introduction:[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] success:^(NSString * success) {
            
            [self showSuccessWithStatusHUD:@"修改成功"];
            
            self.sureBtnBlock();
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissLoadingHUD];
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(NSError *error) {
            
            [self dismissLoadingHUD];
            
            [self showError:error];
        }];
        
    }

    
}

@end



















