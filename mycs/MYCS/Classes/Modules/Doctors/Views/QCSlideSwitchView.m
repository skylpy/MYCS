//
//  QCSlideSwitchView.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "QCSlideSwitchView.h"

@implementation QCSlideSwitchView

- (void)initValues
{
    //创建顶部可滑动的tab
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.heightOfTopScrollView)];
    _topScrollView.delegate = self;
    _topScrollView.backgroundColor = self.topBackgroundColor;
    _topScrollView.pagingEnabled = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_topScrollView];
    _userSelectedChannelID = 100+_selectViewControllerIndex;
    
    //创建主滚动视图
    self.rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.heightOfTopScrollView, self.width, self.height - self.heightOfTopScrollView)];
    _rootScrollView.delegate = self;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.userInteractionEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _userContentOffsetX = 0;
    [_rootScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    [self addSubview:_rootScrollView];
    
    _shadowView = [[UIView alloc] init ];
    _shadowView.backgroundColor = RGBCOLOR(222, 222, 222);
    [self addSubview:_shadowView];
    
    _viewArray = [[NSMutableArray alloc] init];
    
    _isBuildUI = NO;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initValues];
    }
    return self;
}

//当横竖屏切换时可通过此方法调整布局
- (void)layoutSubviews
{
    //创建完子视图UI才需要调整布局
    if (_isBuildUI)
    {
        self.topScrollView.frame = CGRectMake(0, 0, self.width, self.heightOfTopScrollView);
        
        self.rootScrollView.frame = CGRectMake(0, self.heightOfTopScrollView, self.width, self.height - self.heightOfTopScrollView);
        _topScrollView.backgroundColor = self.topBackgroundColor;
        
        _shadowView.frame = CGRectMake(0, self.heightOfTopScrollView-1, ScreenW, 1);
        
        //更新主视图的总宽度
        _rootScrollView.contentSize = CGSizeMake(self.width * [_viewArray count], 0);
        
        //更新主视图各个子视图的宽度
        for (int i = 0; i < [_viewArray count]; i++)
        {
            UIViewController *listVC = _viewArray[i];
            listVC.view.frame = CGRectMake(0+_rootScrollView.width*i, 0,
                                           _rootScrollView.width, _rootScrollView.height);
        }
        
        //滚动到选中的视图
        [_rootScrollView setContentOffset:CGPointMake((_userSelectedChannelID - 100)*self.width, 0) animated:NO];
        
        //调整顶部滚动视图选中按钮位置
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        [self adjustScrollViewContentX:button];
    }
}

- (void)setSelectViewControllerIndex:(NSInteger)selectViewControllerIndex
{
    _selectViewControllerIndex = selectViewControllerIndex;
    _userSelectedChannelID = 100+_selectViewControllerIndex;
}

- (void)changeViewWithIndex:(NSInteger)index
{
    UIButton *button = (UIButton*)[_topScrollView viewWithTag:index+100];
    [self selectNameButton:button];
}

- (void)buildUI
{
    NSUInteger number = [self.slideSwitchViewDelegate numberOfTab:self];
    
    for (int i=0; i<number; i++)
    {
        UIViewController *vc = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:i];
        [_viewArray addObject:vc];
        [_rootScrollView addSubview:vc.view];
    }
    [self createNameButtons];
    
    //选中第一个view
    if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)])
    {
        [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
    }
    
    _isBuildUI = YES;
    
    //创建完子视图UI才需要调整布局
    [self setNeedsLayout];
}

- (void)createNameButtons
{
    
    kFontSizeOfTabButton = _viewArray.count>4?14.0f:15.0f;
    
    self.scrollBar = [[UIImageView alloc] init];
    _scrollBar.backgroundColor = HEXRGB(0x47c1a9);
    [_topScrollView addSubview:_scrollBar];
    
    //顶部tabbar的总长度
    CGFloat topScrollViewContentWidth = self.widthOfButtonMargin;
    //每个tab偏移量
    CGFloat xOffset = self.widthOfButtonMargin;
    for (int i = 0; i < [_viewArray count]; i++)
    {
        UIViewController *vc = _viewArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        CGSize textSize = [vc.title sizeWithFont:[UIFont systemFontOfSize:kFontSizeOfTabButton]
                               constrainedToSize:CGSizeMake(_topScrollView.bounds.size.width, self.heightOfTopScrollView)
                                   lineBreakMode:NSLineBreakByWordWrapping];
        
#pragma clang diagnostic pop

        
        //累计每个tab文字的长度
        topScrollViewContentWidth += self.widthOfButtonMargin+textSize.width;
        //设置按钮尺寸
        if (self.scrollBarWidth>0)
        {
            [button setFrame:CGRectMake(self.scrollBarWidth*i,0,
                                        self.scrollBarWidth, self.heightOfTopScrollView)];
            //添加分隔线
            if (_viewArray.count >= 3)
            {
                UIView *lineView = [self addMarginLineInView:_topScrollView];
                lineView.center = button.center;
                lineView.x = CGRectGetMaxX(button.frame);
            }
        }else
        {
            [button setFrame:CGRectMake(xOffset,0,
                                        textSize.width, self.heightOfTopScrollView)];
        }
        
        //计算下一个tab的x偏移量
        xOffset += textSize.width + self.widthOfButtonMargin;
        
        [button setTag:i+100];
        if (i == _selectViewControllerIndex)
        {
            if (_scrollBar > 0)
            {
                _scrollBar.frame = CGRectMake(button.x, self.heightOfTopScrollView-3, _scrollBarWidth, 3);
                
                CGPoint center = _scrollBar.center;
                center.x = button.center.x;
                _scrollBar.center = center;
                
            }else
            {
                _scrollBar.frame = CGRectMake(button.x, self.heightOfTopScrollView-3, textSize.width, 3);
            }
            
            button.selected = YES;
        }
        [button setTitle:vc.title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:kFontSizeOfTabButton];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:self.tabItemNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.tabItemSelectedColor forState:UIControlStateSelected];
        [button setBackgroundImage:self.tabItemNormalBackgroundImage forState:UIControlStateNormal];
        [button setBackgroundImage:self.tabItemSelectedBackgroundImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:button];
    }
    
    //设置顶部滚动视图的内容总尺寸
    _topScrollView.contentSize = CGSizeMake(topScrollViewContentWidth, self.heightOfTopScrollView);
}

- (UIView *)addMarginLineInView:(UIView *)supverView
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 1, 18);
    view.alpha = 0.4;
    view.backgroundColor = [UIColor grayColor];
    [supverView addSubview:view];
    
    return view;
}

- (void)setButtonsName:(NSArray*)nameArray
{
    NSArray *array = [_topScrollView subviews];
    
    for (UIView *view in array)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton*)view;
            NSString *name = [nameArray objectAtIndex:button.tag-100];
            [button setTitle:name forState:UIControlStateNormal];
            [button setTitle:name forState:UIControlStateSelected];
        }
    }
}

- (void)selectNameButton:(UIButton *)sender
{
    //如果点击的tab文字显示不全，调整滚动视图x坐标使用使tab文字显示全
    [self adjustScrollViewContentX:sender];
    
    //如果更换按钮
    if (sender.tag != _userSelectedChannelID)
    {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        lastButton.selected = NO;
        //赋值按钮ID
        _userSelectedChannelID = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected)
    {
        sender.selected = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            if (_scrollBarWidth > 0)
            {
                
                _scrollBar.frame = CGRectMake(sender.x, self.heightOfTopScrollView-3, _scrollBarWidth, 3);
                
                CGPoint center = _scrollBar.center;
                center.x = sender.center.x;
                _scrollBar.center = center;
                
            }else
            {
                _scrollBar.frame = CGRectMake(sender.x, self.heightOfTopScrollView-3, sender.width, 3);
            }
            
            if (!_isRootScroll)
            {
                _rootScrollView.contentOffset = CGPointMake((sender.tag - 100)*self.bounds.size.width, 0);
                
            }
        } completion:^(BOOL finished) {
            
            if (finished)
            {
                _isRootScroll = NO;
                
                if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)])
                {
                    [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
                }
            }
        }];
    }
}

- (void)adjustScrollViewContentX:(UIButton *)sender
{
    //如果 当前显示的最后一个tab文字超出右边界
    if (sender.x - _topScrollView.contentOffset.x > self.width - (self.widthOfButtonMargin+sender.width))
    {
        //向左滚动视图，显示完整tab文字
        [_topScrollView setContentOffset:CGPointMake(sender.x - (_topScrollView.width- (self.widthOfButtonMargin+sender.width)), 0)  animated:YES];
    }
    
    //如果 （tab的文字坐标 - 当前滚动视图左边界所在整个视图的x坐标） < 按钮的隔间 ，代表tab文字已超出边界
    if (sender.x - _topScrollView.contentOffset.x < self.widthOfButtonMargin)
    {
        //向右滚动视图（tab文字的x坐标 - 按钮间隔 = 新的滚动视图左边界在整个视图的x坐标），使文字显示完整
        [_topScrollView setContentOffset:CGPointMake(sender.x - self.widthOfButtonMargin, 0)  animated:YES];
    }
}

#pragma mark 主视图逻辑方法

//滚动视图开始时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView)
    {
        _userContentOffsetX = scrollView.contentOffset.x;
    }
}

//滚动视图结束
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView)
    {
        //判断用户是否左滚动还是右滚动
        if (_userContentOffsetX < scrollView.contentOffset.x)
        {
            _isLeftScroll = YES;
        }
        else
        {
            _isLeftScroll = NO;
        }
    }
}

//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView)
    {
        _isRootScroll = YES;
        //调整顶部滑条按钮状态
        int tag = (int)scrollView.contentOffset.x/self.width +100;
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:tag];
        [self selectNameButton:button];
    }
}

//传递滑动事件给下一层
-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    //当滑道左边界时，传递滑动事件给代理
    if(_rootScrollView.contentOffset.x <= 0)
    {
        if (self.slideSwitchViewDelegate
            && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panLeftEdge:)])
        {
            [self.slideSwitchViewDelegate slideSwitchView:self panLeftEdge:panParam];
        }
    } else if(_rootScrollView.contentOffset.x >= _rootScrollView.contentSize.width - _rootScrollView.width)
    {
        if (self.slideSwitchViewDelegate
            && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panRightEdge:)])
        {
            [self.slideSwitchViewDelegate slideSwitchView:self panRightEdge:panParam];
        }
    }
}

@end
