//
//  ImageScrollView.m
//  MYCS
//
//  Created by GuiHua on 16/7/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ImageScrollView.h"

#import "ComfirmView.h"
#import "UIView+Message.h"
#import "UMengHelper.h"
#import "ShareToolBar.h"

@interface ImageScrollView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic)ShareToolBar * toolBar;

@end

@implementation ImageScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        
        self.imgView = [[UIImageView alloc] init];
        self.imgView.clipsToBounds = YES;
        self.imgView.userInteractionEnabled = YES;
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imgView];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressImageView:)];
        
        [self.imgView addGestureRecognizer:longPress];
        
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(10, ScreenH - 15, ScreenW - 20, 0)];
        self.contentL.numberOfLines = 0;
        self.contentL.font = [UIFont systemFontOfSize:15];
        self.contentL.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.contentL];
        
        
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [self.imgView addGestureRecognizer:pinchGestureRecognizer];
        
    }
    return self;
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        self.imgView.transform = CGAffineTransformScale(self.imgView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[self.imgView class]]){
        
        return NO;
        
    }
    
    return YES;
    
}

-(void)longPressImageView:(UILongPressGestureRecognizer *)longPress
{
    if (self.isLoading)return;
    
    if (longPress.state == UIGestureRecognizerStateBegan){
        
        ModelComfirm *model1 = [ModelComfirm comfirmModelWith:@"分享给朋友" titleColor:HEXRGB(0x333333) fontSize:16];
        
        ModelComfirm *model2 = [ModelComfirm comfirmModelWith:@"保存图片" titleColor:HEXRGB(0x333333) fontSize:16];
        
        ModelComfirm *model3 = [ModelComfirm comfirmModelWith:@"取消" titleColor:HEXRGB(0x333333) fontSize:16];
        
        NSArray *sourceArray = @[ model1, model2 ];
        
        [ComfirmView showInView:self cancelItemWith:model3 dataSource:sourceArray actionBlock:^(ComfirmView *view, NSInteger index) {
            
            if (0 == index)
            {
                [self.toolBar removeFromSuperview];
                
                self.toolBar = [ShareToolBar shareToolBar];
                
                [self.toolBar showInView:self Block:^(NSString * type, ShareToolBar *toolBar) {
                    
                    [UMengHelper shareImageWith:self.imgView.image title:@"" content:@"" shareType:type];
                }];
            }
            else if (1 == index)
            {
                [self savePicture];
            }
            
        }];
        
    }
}

#pragma mark -- 保存名片到手机
-(void)savePicture
{
    
    UIImageWriteToSavedPhotosAlbum(self.imgView.image, nil, nil, nil);
    [self showSuccessWithStatus:@"保存成功"];
}

- (void)setOriginAnimationRect:(CGRect)rect
{
    self.imgView.frame = rect;
    self.initRect = rect;
}

- (void)setAnimationRect
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.imgView.frame = self.scaleOriginRect;
    }];
}

- (void)rechangeInitRdct
{
    self.zoomScale = 1.0;
    self.imgView.frame = self.initRect;
}

- (void)setImage:(UIImage *) image
{
        self.isLoading = YES;
        [self.indicatorView startAnimating];
    
        self.imgView.center = CGPointMake(ScreenW/2, ScreenH/2);
        self.imgView.image = image;
        self.imgSize = image.size;
        
        //判断首先缩放的值
        float scaleX = self.frame.size.width/self.imgSize.width;
        float scaleY = self.frame.size.height/self.imgSize.height;
        
        //倍数小的，先到边缘
        
        if (scaleX > scaleY)
        {
            //Y方向先到边缘
            float imgViewWidth = self.imgSize.width*scaleY;
            self.maximumZoomScale = 200/imgViewWidth;
            
            self.scaleOriginRect = (CGRect){(ScreenW - 200)/2,(ScreenH - 120) / 2,200,120};
        }
        else
        {
            //X先到边缘
            float imgViewHeight = self.imgSize.height*scaleX;
            self.maximumZoomScale = 150/imgViewHeight;
            
            self.scaleOriginRect = (CGRect){(ScreenW - 200)/2,(ScreenH - 120) / 2,200,120};
        }
}

- (void)setNewImage:(UIImage *)image
{
    if (image)
    {
        [self.indicatorView stopAnimating];
        self.isLoading = NO;
        self.imgView.center = CGPointMake(ScreenW/2, ScreenH / 2);
        self.imgView.image = image;
        self.imgSize = image.size;
        
        //判断首先缩放的值
        float scaleX = self.frame.size.width/self.imgSize.width;
        float scaleY = self.frame.size.height/self.imgSize.height;
        
        //倍数小的，先到边缘
        
        if (scaleX > scaleY)
        {
            //Y方向先到边缘
            float imgViewWidth = self.imgSize.width*scaleY;
            self.maximumZoomScale = ScreenW/imgViewWidth;
            
            self.scaleOriginRect = (CGRect){0,0,ScreenW,ScreenH};
        }
        else
        {
            //X先到边缘
            float imgViewHeight = self.imgSize.height*scaleX;
            self.maximumZoomScale = ScreenH/imgViewHeight;
            
            self.scaleOriginRect = (CGRect){0,0,ScreenW,ScreenH};
        }
    }
}

-(void)setContentStr:(NSString *)str
{
    self.contentL.text = str;
    [self.contentL sizeToFit];
    self.contentL.y = ScreenH - 20 - self.contentL.height;
   
    self.contentL.center = CGPointMake(ScreenW / 2, self.contentL.center.y);
    
    [self.contentL layoutIfNeeded];
    [self layoutIfNeeded];
}

#pragma mark -
#pragma mark - scroll delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    if (self.ShowContentLblock)
    {
        self.ShowContentLblock();
    }
    
}

//加载中...
-(UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView)
    {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];//指定进度轮的大小
        
        [_indicatorView setCenter:CGPointMake(ScreenW / 2, ScreenH / 2)];//指定进度轮中心点
        
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
        
        [self addSubview:_indicatorView];
        
    }
    return _indicatorView;
}


@end