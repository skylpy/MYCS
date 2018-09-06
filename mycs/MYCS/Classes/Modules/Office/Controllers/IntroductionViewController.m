//
//  IntroductionViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "IntroductionViewController.h"

#import "OfficeIntroView.h"
#import "HonourView.h"
#import "UIButton+WebCache.h"
#import "PhotoBroswerVC.h"

#import "OfficeContentModel.h"

@interface IntroductionViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) OfficeIntroView *introView;

@property (nonatomic,strong) HonourView *honourView;

@property (nonatomic,strong) NSMutableArray *honourUrlArr;

@property (nonatomic,assign) CGFloat honourViewHeight;

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.honourUrlArr = [NSMutableArray array];
    
    self.introView = [OfficeIntroView introView];
    
    self.honourView = [HonourView honourView];
    
    [self.scrollView addSubview:_introView];
    [self.scrollView addSubview:_honourView];
    
    
}

#pragma mark -- setting and getting
- (void)setModel:(OfficeDetailModel *)model
{
    _model = model;
    
    self.introView.y = 10;
    _honourView.width = ScreenW;
    self.introView.width = ScreenW;
    
    self.introView.content.numberOfLines = 0;
    self.introView.content.text = model.introduction;
    [self.introView.content sizeToFit];
    self.introView.contentHeight.constant = self.introView.content.height;
    
    if (self.introView.content.text||self.introView.content.text.length != 0)
    {
        self.introView.height = CGRectGetMaxY(self.introView.content.frame)+25;
    }else
    {
        
        self.introView.height = 45;
    }
    
    
    //荣誉
    self.honourView.y = CGRectGetMaxY(self.introView.frame)+10;
    for (int i = 0; i<model.honourList.count; i++)
    {
        
        UIButton *imageV = [[UIButton alloc] init];
        
        OfficeDetailHonourListModel *honour = model.honourList[i];
        
        //添加事件
        imageV.tag = _honourView.honourView.subviews.count;
        [imageV addTarget:self action:@selector(honourBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        int col = i%3;
        int row = i/3;
        CGFloat margin = 15;
        CGFloat imageW = (ScreenW - margin*4)/3;
        CGFloat imageH = imageW*180/144;
        CGFloat imageX = margin + (imageW + margin)*col;
        CGFloat imageY = margin + (imageH + margin)*row;
        
        imageV.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/0/w/%d/h/%d/format/jpg/q/100",honour.imgUrl,(int)imageW*2,(int)imageH*2]];
        [imageV sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:PlaceHolderImage];
        
        self.honourViewHeight = CGRectGetMaxY(imageV.frame)+15+_honourView.honourView.y;
        
        [_honourView.honourView addSubview:imageV];
        
        [self.honourUrlArr addObject:honour.imgUrl];
        
    }
    if (_model.honourList.count==0)
    {
        _honourView.height = 50;
        _honourView.honourView.hidden = YES;
        
    }else
    {
        _honourView.height = self.honourViewHeight;
    }
    
    self.scrollView.contentSize = CGSizeMake(ScreenW, CGRectGetMaxY(self.honourView.frame));
    
}

#pragma mark -- setting and getting
- (void)setType:(int)type
{
    _type = type;
    
    //TODO: 设置类型
    if (self.type == 1)
    {
        self.introView.titleL.text = @"科室简介";
        
    }else if (self.type == 2)
    {
      self.introView.titleL.text = @"医院简介";
        
    }else if (self.type == 3)
    {
        self.introView.titleL.text = @"实验室简介";
        
    }else if (self.type == 4)
    {
        self.introView.titleL.text = @"企业简介";
        
    }else if(self.type == 5)
    {
        self.introView.titleL.text = @"学院简介";
    }
    
}
#pragma mark -- honourImage Action
- (void)honourBtnDidClick:(UIButton *)btn
{
    [self networkImageShow:btn.tag inArr:self.honourUrlArr];
    
}

-(void)networkImageShow:(NSUInteger)index inArr:(NSArray *)imageArr {
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeModal index:index photoModelBlock:^NSArray *{
        
        NSArray *networkImages= imageArr;
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        
        for (NSUInteger i = 0; i< networkImages.count; i++)
        {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            
            pbModel.image_HD_U = networkImages[i];
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}


@end
