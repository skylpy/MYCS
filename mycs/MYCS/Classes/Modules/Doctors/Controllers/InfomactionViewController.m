//
//  InfomactionViewController.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "InfomactionViewController.h"

#import "EducationView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "BaseInfoView.h"
#import "DoctorInfoView.h"
#import "EducationBgView.h"
#import "HonourView.h"
#import "WorkView.h"
#import "NSDate+Util.h"
#import "PhotoBroswerVC.h"


@interface InfomactionViewController ()
{
    NSMutableArray *_selections;
}

@property (nonatomic,strong) BaseInfoView *baseInfoV;

@property (nonatomic,strong) DoctorInfoView *doctorInfoV;

@property (nonatomic,strong) EducationBgView *educationBgV;

@property (nonatomic,strong) HonourView *honourV;

@property (nonatomic,strong) WorkView *workV;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,assign) CGFloat eduViewHeight;
@property (nonatomic,assign) CGFloat honourViewHeight;
@property (nonatomic,assign) CGFloat workViewHeight;

@property (nonatomic,strong) NSMutableArray *honourUrlArr;

@property (nonatomic,strong) NSMutableArray *workUrlArr;

@property (nonatomic,assign) BOOL showAllIntroduction;

@end

@implementation InfomactionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showAllIntroduction = NO;
    
    self.baseInfoV = [BaseInfoView baseInfoView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.baseInfoV.introductionL.userInteractionEnabled = YES;
    [self.baseInfoV.introductionL addGestureRecognizer:tap];
    
    self.doctorInfoV = [DoctorInfoView doctorInfoView];
    self.educationBgV = [EducationBgView educationBgView];
    self.honourV = [HonourView honourView];
    self.workV = [WorkView workView];
    
}

-(void)tapAction:(UITapGestureRecognizer *)tap
{
    self.showAllIntroduction = !self.showAllIntroduction;
    [self setDoctorInfo:self.doctorInfo];
}

#pragma mark - *** 数据显示 **
- (void)setDoctorInfo:(DoctorInfoModel *)doctorInfo
{
    _doctorInfo = doctorInfo;
    
    [self.honourUrlArr removeAllObjects];
    [self.workUrlArr removeAllObjects];
    
    //基本信息
    _baseInfoV.width = ScreenW;
    self.baseInfoV.y = 10;
    _baseInfoV.width = self.scrollView.width;
    _baseInfoV.nickNameL.text = doctorInfo.realname;
    _baseInfoV.addressL.text = doctorInfo.placeStr;
    
    self.baseInfoV.gootAtL.width = self.baseInfoV.width - 80;
    self.baseInfoV.gootAtL.numberOfLines = 0;
    _baseInfoV.gootAtL.text = doctorInfo.skill;
    [self.baseInfoV.gootAtL sizeToFit];
    if (self.baseInfoV.gootAtL.height < 21)
    {
        self.baseInfoV.introductionConstraintT.constant = 21;
    }
    
    self.baseInfoV.introductionL.numberOfLines = self.showAllIntroduction ?0:5;
    self.baseInfoV.introductionL.width = self.baseInfoV.width - 80;
    _baseInfoV.introductionL.text = doctorInfo.introduction;
    [self.baseInfoV.introductionL sizeToFit];
    
    [self.baseInfoV layoutIfNeeded];
    self.baseInfoV.height = CGRectGetMaxY(self.baseInfoV.introductionL.frame) + 30;
    
    [self.scrollView addSubview:self.baseInfoV];
    
    //医生资料
    _doctorInfoV.width = ScreenW;
    self.doctorInfoV.y = CGRectGetMaxY(self.baseInfoV.frame) + 10;
    _doctorInfoV.nameL.text = doctorInfo.extraInfo.realname;
    _doctorInfoV.addL.text = doctorInfo.placeStr;
    _doctorInfoV.hospitalL.text = doctorInfo.hospital;
    _doctorInfoV.divisionL.text = doctorInfo.divisionName;
    _doctorInfoV.quarterL.text = doctorInfo.posTitle;
    _doctorInfoV.titleL.text = doctorInfo.jobTitle;
    [self.scrollView addSubview:self.doctorInfoV];
    
    //教育背景
    _educationBgV.width = ScreenW;
    self.educationBgV.y = CGRectGetMaxY(self.doctorInfoV.frame) + 10;
    for (int i = 0; i < doctorInfo.eduList.count; i ++)
    {
        
        EducationView * eView = [EducationView educationView];
        
        Education *education = doctorInfo.eduList[i];
        
        eView.eudcation = education;
        [eView setFrame:CGRectMake(0, i * 55, _educationBgV.educationView.width, 55)];
        [_educationBgV.educationView addSubview:eView];
        [eView setFrame:eView.frame];
        
        _educationBgV.educationViewH.constant = eView.height * doctorInfo.eduList.count;
        self.eduViewHeight = _educationBgV.educationViewH.constant + 50;
        _educationBgV.height = self.eduViewHeight;
    }
    if (_doctorInfo.eduList.count == 0)
    {
        _educationBgV.height = 50;
        _educationBgV.educationView.hidden = YES;
        
    }else
    {
            _educationBgV.educationViewH.constant += 28;
            _educationBgV.height = self.eduViewHeight + 28;
    }
    
    [self.scrollView addSubview:self.educationBgV];
    
    
    //荣誉
    _honourV.width = ScreenW;
    self.honourV.y = CGRectGetMaxY(self.educationBgV.frame) + 10;
    for (int i = 0; i < doctorInfo.honourList.count; i ++)
    {
        
        UIButton *imageV = [[UIButton alloc] init];
        
        Honour *honour = doctorInfo.honourList[i];
        
        //添加事件
        imageV.tag = _honourV.honourView.subviews.count;
        [imageV addTarget:self action:@selector(honourBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        int col = i % 3;
        int row = i / 3;
        CGFloat margin = 15;
        CGFloat imageW = (ScreenW - margin * 4) / 3;
        CGFloat imageH = imageW * 180 / 144;
        CGFloat imageX = margin + (imageW + margin)*col;
        CGFloat imageY = margin + (imageH + margin)*row;
        
        imageV.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/0/w/%d/h/%d/format/jpg/q/100",honour.imgUrl,(int)imageW*2,(int)imageH*2]];
        [imageV sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:PlaceHolderImage];
        imageV.imageView.contentMode =UIViewContentModeScaleToFill;
        
        self.honourViewHeight = CGRectGetMaxY(imageV.frame) + 15 + _honourV.honourView.y;
        [_honourV.honourView addSubview:imageV];
        
        [self.honourUrlArr addObject:honour.imgUrl];
        
    }
    
    if (_doctorInfo.honourList.count == 0)
    {
        _honourV.height = 50;
        _honourV.honourView.hidden = YES;
        
    }else
    {
        _honourV.height = self.honourViewHeight;
        
    }
    
    [self.scrollView addSubview:self.honourV];
    
    
    //著作
    _workV.width = ScreenW;
    self.workV.y = CGRectGetMaxY(self.honourV.frame) + 10;
    for (int i = 0; i< doctorInfo.treatiseList.count; i ++)
    {
        
        UIButton *imageV = [[UIButton alloc] init];
        
        Treatise *treatise = doctorInfo.treatiseList[i];
       
        imageV.tag = _workV.workView.subviews.count;
        [imageV addTarget:self action:@selector(treatiseBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        int col = i % 3;
        int row = i / 3;
        CGFloat margin = 15;
        CGFloat imageW = ( ScreenW - margin * 4 ) / 3;
        CGFloat imageH = imageW * 180 / 144;
        CGFloat imageX = margin + (imageW + margin)*col;
        CGFloat imageY = margin + (imageH + margin)*row;
        imageV.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/0/w/%d/h/%d/format/jpg/q/100",treatise.imgUrl,(int)imageW*2,(int)imageH*2]];
        [imageV sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:PlaceHolderImage];
        imageV.imageView.contentMode =UIViewContentModeScaleToFill;
        
        self.workViewHeight = CGRectGetMaxY(imageV.frame) + 15 + _workV.workView.y;
        [_workV.workView addSubview:imageV];
        
        [self.workUrlArr addObject:treatise.imgUrl];
        
    }
    if (_doctorInfo.treatiseList.count == 0)
    {
        _workV.height = 50;
        _workV.workView.hidden = YES;
        
    }else
    {
        _workV.height = self.workViewHeight;
        
    }
    
    
    [self.scrollView addSubview:self.workV];
    
    self.scrollView.contentSize = CGSizeMake(ScreenW, CGRectGetMaxY(self.workV.frame));
    
}




#pragma mark - *** treatise图片 Action **
- (void)treatiseBtnDidClick:(UIButton *)btn
{
    [self networkImageShow:btn.tag inArr:self.workUrlArr];
}

#pragma mark - *** honour图片 Action **
- (void)honourBtnDidClick:(UIButton *)btn{
    
    [self networkImageShow:btn.tag inArr:self.honourUrlArr];
    
}

#pragma mark - *** 图片显示 **
-(void)networkImageShow:(NSUInteger)index inArr:(NSArray *)imageArr
{
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeModal index:index photoModelBlock:^NSArray *{
        
        NSArray *networkImages= imageArr;
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        
        for (NSUInteger i = 0; i < networkImages.count; i ++)
        {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            
            pbModel.image_HD_U = networkImages[i];
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

#pragma mark - *** 懒加载 ***
- (NSMutableArray *)honourUrlArr
{
    if (!_honourUrlArr)
    {
        _honourUrlArr = [NSMutableArray array];
    }
    
    return _honourUrlArr;
}

#pragma mark - *** 懒加载 ***
- (NSMutableArray *)workUrlArr
{
    if (!_workUrlArr)
    {
        _workUrlArr = [NSMutableArray array];
    }
    
    return _workUrlArr;
}


@end
