//
//  HealthPictureView.m
//  MYCS
//
//  Created by GuiHua on 16/7/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "HealthPictureView.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"
#import "DoctorsHealthList.h"

@implementation HealthPictureView

+ (instancetype)healthPictureView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HealthPictureView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.scrollView.delegate = self;
}

-(void)setImageArrs:(NSArray *)imageArrs andCurrentIndex:(int)currentIndex andImageView:(UIImageView *)imageView
{
    _currentIndex = currentIndex;
    _imageArrs = imageArrs;
    _tapImageView = imageView;
    
    self.titleL.text = [NSString stringWithFormat:@"%d/%ld",_currentIndex+1,(long)self.imageArrs.count];
    
    self.scrollView.contentSize = CGSizeMake(ScreenW *imageArrs.count, ScreenH);
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = currentIndex*ScreenW;
    self.scrollView.contentOffset = contentOffset;
    
    self.imageScrollViewArrs = [NSMutableArray array];
    
    for (int i = 0;i < self.imageArrs.count; i ++)
    {
        
        DoctorsHealthPhotos *model = self.imageArrs[i];
        
        ImageScrollView *tmpImgScrollView = [[ImageScrollView alloc] initWithFrame:(CGRect){i*ScreenW,0,CGSizeMake(ScreenW, ScreenH)}];
        
        if (_currentIndex == i)
        {
            
            [tmpImgScrollView setImage:imageView.image];
        }
        else
        {
            [tmpImgScrollView setImage:PlaceHolderImage];
        }
        
        [tmpImgScrollView setOriginAnimationRect:(CGRect){(ScreenW)/2,(ScreenH) / 2,0,0}];
        [self.scrollView addSubview:tmpImgScrollView];
        
        [self setOriginFrame:tmpImgScrollView];
        
        [tmpImgScrollView setContentStr:model.title];
        
        [self.imageScrollViewArrs addObject:tmpImgScrollView];
        
    }
    
    //添加
    [self addSubImgViewWith:_currentIndex];
    
}
- (void)addSubImgViewWith:(int)index;
{
    DoctorsHealthPhotos *model = self.imageArrs[index];
    //下载图片
    model.url = [model.url stringByReplacingOccurrencesOfString:@"|" withString:@"%7C"];
    
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:model.url done:^(UIImage *image, SDImageCacheType cacheType) {
        
        if (image != nil)
        {
            ImageScrollView *tmpImgScrollView = self.imageScrollViewArrs[index];
            
            [tmpImgScrollView setNewImage:image];
            [tmpImgScrollView setAnimationRect];
            
            tmpImgScrollView.ShowContentLblock = ^(){
                
                self.ishowTopView = !self.ishowTopView;
            };
        
        }else
        {
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:model.url] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished){
                
                ImageScrollView *tmpImgScrollView = self.imageScrollViewArrs[index];
                
                if (error)
                {
                    [tmpImgScrollView.indicatorView removeFromSuperview];
                    return ;
                }
                
                [tmpImgScrollView setNewImage:image];
                [tmpImgScrollView setAnimationRect];
                
                tmpImgScrollView.ShowContentLblock = ^(){
                    
                    self.ishowTopView = !self.ishowTopView;
                };
                
                //将image缓存到本地
                [[SDImageCache sharedImageCache] storeImage:image forKey:model.url];
            }];
        }
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }];
    
}

- (void)setOriginFrame:(ImageScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        
        [sender setAnimationRect];
        self.bgView.alpha = 1.0;
    }];
}

#pragma mark - scroll delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    _currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.titleL.text = [NSString stringWithFormat:@"%d/%ld",_currentIndex+1,(long)self.imageArrs.count];
    
    ImageScrollView *tmpImgScrollView = self.imageScrollViewArrs[_currentIndex];
    
    if (!tmpImgScrollView.isLoading)return;
    
    [self addSubImgViewWith:_currentIndex];
}

- (IBAction)dismissAction:(UIButton *)sender
{
    ImageScrollView *tmpImgScrollView = self.imageScrollViewArrs[_currentIndex];
    [tmpImgScrollView setImage:tmpImgScrollView.imgView.image];
    [tmpImgScrollView.indicatorView removeFromSuperview];
    tmpImgScrollView.alpha = 0.8;
    tmpImgScrollView.backgroundColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [tmpImgScrollView setAnimationRect];
        
        self.alpha = 0.8;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.alpha = 0;
            
            [self removeFromSuperview];
        }];
        
    }];
}

-(void)setIshowTopView:(BOOL)ishowTopView
{
    
    _ishowTopView = ishowTopView;
    self.topView.hidden = ishowTopView;
    for (int i = 0; i < self.imageScrollViewArrs.count; i ++)
    {
        ImageScrollView *tmpImgScrollView = self.imageScrollViewArrs[i];
        tmpImgScrollView.contentL.hidden = ishowTopView;
    }
}


@end
