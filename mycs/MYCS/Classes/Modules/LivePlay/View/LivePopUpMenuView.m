//
//  LivePopUpMenuView.m
//  MYCS
//
//  Created by AdminZhiHua on 16/4/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "LivePopUpMenuView.h"

static CGFloat cornerRadius   = 4;
static CGFloat margin         = 5;
static CGFloat arrowEdgeHeigh = 8;   //箭头与contentView的边距
static CGFloat arrowWidth     = 12;  //箭头底边的长
static CGFloat popUpViewW     = 110; //contentView的宽度
static CGFloat popUpViewCellH = 40;  //contentView的高度


@interface LivePopUpMenuView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, assign) CGPoint arrowPoint;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) CGRect contentRect;

@property (nonatomic, copy) void (^itemClickBlock)(NSInteger idx);

@end

@implementation LivePopUpMenuView

+ (void)showInView:(UIView *)view fromRect:(CGRect)rect withItems:(NSArray *)items itemClick:(void (^)(NSInteger idx))block {
    //初始化popupview
    LivePopUpMenuView *popView = [[LivePopUpMenuView alloc] initWithItems:items];

    popView.itemClickBlock = block;

    popView.frame = view.bounds;
    [view addSubview:popView];

    popView.contentView.frame = [popView popUpViewFrameWithView:view rect:rect];

    [popView.tableView reloadData];
}

- (instancetype)initWithItems:(NSArray *)items {
    if ([super init])
    {
        self.backgroundColor = [UIColor clearColor];
        self.dataSource      = items;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //画三角形
    [self drawTriangle];
}

- (void)drawTriangle {
    CGFloat y = self.contentRect.origin.y;

    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:self.arrowPoint];
    [arrowPath addLineToPoint:(CGPoint){self.arrowPoint.x - arrowWidth * 0.5, y}];
    [arrowPath addLineToPoint:(CGPoint){self.arrowPoint.x + arrowWidth * 0.5, y}];

    [HEXRGB(0x222222) set];

    [arrowPath fill];
}

- (CGRect)popUpViewFrameWithView:(UIView *)view rect:(CGRect)rect {
    //减一是为了，切除最好一个分割线
    CGFloat popUpViewH = popUpViewCellH * self.dataSource.count - 1;

    //箭头的顶点坐标
    CGFloat arrowPointX = rect.origin.x + rect.size.width * 0.5;
    CGFloat arrowPointY = CGRectGetMaxY(rect) + 4;
    CGPoint arrowPoint  = CGPointMake(arrowPointX, arrowPointY);

    CGFloat popUpViewY = arrowPointY + arrowEdgeHeigh;
    CGFloat popUpViewX;

    //计算contentview的x位置
    CGFloat contentViewMaxX = arrowPointX + popUpViewW * 0.5;

    BOOL rightOver = contentViewMaxX > ScreenW - margin;
    BOOL leftOver  = arrowPointX * 0.5 - popUpViewW * 0.5 < margin;

    // 右边超出
    if (rightOver && !leftOver)
    {
        popUpViewX = ScreenW - margin - popUpViewW;
    } //左边超出
    else if (leftOver && !rightOver)
    {
        popUpViewX = margin;
    }
    else
    {
        popUpViewX = arrowPointX - popUpViewW * 0.5;
    }

    CGRect popUpViewFrame = CGRectMake(popUpViewX, popUpViewY, popUpViewW, popUpViewH);

    self.contentRect = popUpViewFrame;
    self.arrowPoint  = arrowPoint;

    return popUpViewFrame;
}

#pragma mark - Action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dissmissAnimation];
    if (self.itemClickBlock)
    {
        self.itemClickBlock(-1);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return popUpViewCellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"LivePopUpMenuCell";

    LivePopUpMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];

    LivePopUpMenuItem *item = self.dataSource[indexPath.row];

    cell.item = item;

    cell.button.tag = indexPath.row;

    //bug:本来打算使用didSelectRowAtIndexPath来处理响应事件，无奈没法响应。
    [cell.button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)buttonDidClick:(UIButton *)button {
    if (self.itemClickBlock)
    {
        self.itemClickBlock(button.tag);
        [self dissmissAnimation];
    }
}

- (void)dissmissAnimation {
    [self removeFromSuperview];
}

#pragma mark - Getter&Setter

- (UIView *)contentView {
    if (!_contentView)
    {
        UIView *view = [UIView new];
        [self addSubview:view];
        _contentView             = view;
        view.layer.cornerRadius  = cornerRadius;
        view.layer.masksToBounds = YES;
        view.backgroundColor     = HEXRGB(0x222222);
        view.clipsToBounds       = YES;
    }
    return _contentView;
}

- (UITableView *)tableView {
    if (!_tableView)
    {
        UITableView *tableView    = [UITableView new];
        tableView.allowsSelection = YES;
        _tableView                = tableView;
        tableView.scrollEnabled   = NO;
        tableView.backgroundColor = [UIColor clearColor];
        [tableView registerClass:[LivePopUpMenuCell class] forCellReuseIdentifier:@"LivePopUpMenuCell"];
        tableView.delegate        = self;
        tableView.dataSource      = self;
        tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [UIView new];
        [self.contentView addSubview:tableView];
        [self addConstsToTableView];
    }
    return _tableView;
}

- (void)addConstsToTableView {
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    //
    UIView *tableView = self.tableView;

    NSString *hVFL = @"H:|-(0)-[tableView]-(0)-|";
    NSString *vVFL = @"V:|-(0)-[tableView]-(0)-|";

    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)];
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)];

    [tableView.superview addConstraints:hConsts];
    [tableView.superview addConstraints:vConsts];
}

@end

@interface LivePopUpMenuCell ()

@property (nonatomic, strong) CALayer *lineLayer;

@end

@implementation LivePopUpMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView removeFromSuperview];
        [self addConstsToSubView];
    }
    return self;
}

- (void)setItem:(LivePopUpMenuItem *)item {
    _item = item;

    [self.button setImage:[UIImage imageNamed:item.imageName] forState:UIControlStateNormal];
    [self.button setTitle:item.title forState:UIControlStateNormal];
}

- (UIButton *)button {
    if (!_button)
    {
        UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _button                = button;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:HEXRGB(0x999999) forState:UIControlStateNormal];
        //禁止button与用户交互
        //        button.enabled                = NO;
        //        button.userInteractionEnabled = NO;
        [self addSubview:button];
    }
    return _button;
}

- (void)addConstsToSubView {
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    //
    UIView *button = self.button;

    NSString *hVFL = @"H:|-(0)-[button]-(0)-|";
    NSString *vVFL = @"V:|-(0)-[button]-(0)-|";

    NSArray *hConstsButton = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
    NSArray *vConsts       = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];

    [button.superview addConstraints:hConstsButton];
    [button.superview addConstraints:vConsts];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //设置分割线的位置
    self.lineLayer.frame = CGRectMake(10, CGRectGetHeight(self.bounds) - 1, popUpViewW - 20, 0.5);
}

- (CALayer *)lineLayer {
    if (!_lineLayer)
    {
        CALayer *layer        = [CALayer layer];
        layer.backgroundColor = HEXRGB(0x666666).CGColor;
        [self.layer addSublayer:layer];
        _lineLayer = layer;
    }
    return _lineLayer;
}

@end

@implementation LivePopUpMenuItem

+ (instancetype)itemWith:(NSString *)imageName title:(NSString *)title {
    LivePopUpMenuItem *item = [LivePopUpMenuItem new];
    item.imageName          = imageName;
    item.title              = title;
    return item;
}

@end
