//
//  AboutUSViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AboutUSViewController.h"
#import "AuthorLetterView.h"

@interface AboutUSViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConst;
//授权书按钮
@property (weak, nonatomic) IBOutlet UIButton *authorLetterLabel;

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    version = [NSString stringWithFormat:@"V %@",version];
    
    self.versionLabel.text = version;
    
    [self buildUI];
    
}

- (void)buildUI {
    
    [self.view layoutIfNeeded];
    
    UIImageView *imageView = ({
        
        UIImageView *imageView = [UIImageView new];
        
        imageView.image = [UIImage imageNamed:@"aboutus_pic"];
        
        imageView.frame = CGRectMake(15, 15, ScreenW-30, 210);
        
        imageView;
    });
    
    [self.contentView addSubview:imageView];
    
    UILabel *introLabel = ({
        UILabel *label = [UILabel new];
        
        label.text = @"    名医传世，以“医术+影视+互联网”的形式，打造极具社会价值的精品视频课程，开创互联网+医院培训新模式。\n    携手全国顶级三甲名医，将精湛的医学技术打造成高标准的医术视频课程。开发智能化的医院培训管理平台，实现医院培训标准化、信息化、程序化和系统性的管理，为医院培训提供在线整体解决方案！线下开办临床模拟学院和临床技能实训基地，线上线下双向联动，助力医院优秀技术人才培养，让每位患者都能享受到优质的医疗服务！";
        
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = HEXRGB(0x999999);
        
        label.numberOfLines = 0;
        
        label.width = ScreenW - 30;
        [label sizeToFit];
        
        label.x = 15;
        label.y = CGRectGetMaxY(imageView.frame) + 10;

        [self.contentView addSubview:label];
        label;
    });
    
    self.contentHeightConst.constant = CGRectGetMaxY(introLabel.frame)+15;
    
    [self.view layoutIfNeeded];
}

- (IBAction)authorLetterButtonAction:(UIButton *)sender {
    
    [AuthorLetterView showInWindow];
    
}

@end

@interface AutorLetterButton ()

//下划线
@property (nonatomic,strong) CALayer *lineLayer;

@end

@implementation AutorLetterButton

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame])
    {
        self.lineLayer = [CALayer new];
        self.lineLayer.backgroundColor = HEXRGB(0x999999).CGColor;
        [self.layer addSublayer:self.lineLayer];

    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.lineLayer = [CALayer new];
    self.lineLayer.backgroundColor = HEXRGB(0x999999).CGColor;
    [self.layer addSublayer:self.lineLayer];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lineLayer.frame = CGRectMake(self.titleLabel.x, CGRectGetMaxY(self.titleLabel.frame), self.titleLabel.width, 0.8);
}

@end
