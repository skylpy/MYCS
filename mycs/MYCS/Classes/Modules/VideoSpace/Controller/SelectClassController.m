//
//  SelectClassController.m
//  MYCS
// 《我的视频空间－选择分类》
//  Created by AdminZhiHua on 16/1/9.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SelectClassController.h"
#import "VideoSpaceModel.h"
#import "UIViewController+Message.h"
#import "SelectClassButton.h"
#import "MJRefresh.h"
// 浅灰——线背景颜色
#define lineColor ([UIColor colorWithRed:((240)/255.0) green:((240)/255.0) blue:((240)/255.0) alpha:(1.0)])
static NSString *cellReuseId = @"SelectClassCell";
static NSString *const headerId = @"headerId";

@interface SelectClassController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (retain,nonatomic)NSArray * selArr;

@end

@implementation SelectClassController

-(NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self recordData];
    [self buildUI];
    NSLog(@"======%@",self.selectId);
    
}

- (void)buildUI {
    
    CGFloat itemW = (ScreenW-10*2-15*2)/3;
    
    self.flowLayout.itemSize = CGSizeMake(itemW, 40);
    
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [self.collectionView headerBeginRefreshing];
}

-(void)recordData{

    NSString * selStr = [NSString stringWithFormat:@"%@,%@",self.selectId,self.selectVipId];
     self.selArr = [selStr componentsSeparatedByString:@","];
    
}

#pragma mark - Action
- (IBAction)cancelAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark -- 选择之后的确定按钮
- (IBAction)suerAction:(id)sender {
    
    if (self.completeBlock) {
        self.completeBlock([self idStringSelect],self.dataSource.count > 1 ?[self vipIdStringSelect]:nil);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSString *)idStringSelect {
    
    NSMutableArray *arr = [NSMutableArray array];
    NSArray * array ;
    if (self.dataSource != nil && self.dataSource.count != 0) {
        
        array = self.dataSource.count > 1 ? self.dataSource[1]:self.dataSource[0];
        for (ClassModel *model in array)
        {
            if (model.isSelect)
            {
                [arr addObject:model.id];
            }
            
        }
        
    }
    
    NSString *idString = [arr componentsJoinedByString:@","];
    
    return idString;
}
- (NSString *)vipIdStringSelect {
    
    NSMutableArray *arr = [NSMutableArray array];
    NSArray * array ;;
    if (self.dataSource != nil && self.dataSource.count != 0) {
        
        array = self.dataSource[0];
        for (ClassModel *model in array)
        {
            if (model.isSelect)
            {
                [arr addObject:model.id];
            }
        }
    }
    
    
    NSString *idString = [arr componentsJoinedByString:@","];
    
    return idString;
}

#pragma mark - Network
- (void)loadNewData {
    
    [ClassModel classListWithSuccess:^(NSArray *list) {
        
        [self.dataSource removeAllObjects];
        for (int j = 0; j < list.count; j ++) {
            
            NSMutableArray * array = [NSMutableArray array];
            for (ClassModel * model in list[j]) {
                
                for (int i = 0; i < self.selArr.count; i ++) {
                    
                    if ([model.id isEqualToString: self.selArr[i]]) {
                        model.select = YES;
                    }
                }
                [array addObject:model];
            }
            [self.dataSource addObject:array];
        }
        
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.collectionView headerEndRefreshing];
        
    }];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        
        
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
            
        }
        // 移除旧，新增视图
        for (UIView *all in headerView.subviews) {
            [all removeFromSuperview];
        }
        NSArray * array;
        if (self.dataSource.count == 2) {
            array = @[@"套餐",@"专科"];
            if (indexPath.section == 1) {
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenW-20, 1)];
                lineView.backgroundColor = lineColor;
                [headerView addSubview:lineView];
            }
        
        }else{
        
            array = @[@"专科"];
        }
        
        UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, indexPath.section == 0 ? 20:15, 100, 20)];
        
        [headerView addSubview:titleLable];
        titleLable.text = array[ self.dataSource.count > 2? 0 : indexPath.section];
        
        
        return headerView;
    }
    return nil;
}
#pragma mark - 返回头headerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {ScreenW,40};
    return size;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return self.dataSource.count;
}

#pragma mark - Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray * array = self.dataSource[section];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];
    NSArray * array = self.dataSource[indexPath.section];
    ClassModel *model = array[indexPath.row];
    cell.model = model;
    
    return cell;
}

@end

@interface SelectClassCell ()

@property (weak, nonatomic) IBOutlet SelectClassButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;

@end

@implementation SelectClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.chooseImageView.hidden = YES;
}

- (void)setModel:(ClassModel *)model {
    _model = model;
    
    [self.button setTitle:model.text forState:UIControlStateNormal];
    self.button.selected = model.isSelect;
    self.chooseImageView.hidden = model.isSelect ?NO:YES;
    
}


- (IBAction)buttonAction:(SelectClassButton *)button {
    button.selected = !button.selected;
    
    self.model.select = button.selected;
    self.chooseImageView.hidden = button.selected ?NO:YES;
    
}

@end

