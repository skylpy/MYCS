//
//  DiseaseClassController.m
//  MYCS
//
//  Created by GuiHua on 16/7/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "DiseaseClassController.h"
#import "UICollectionView+NoDataTips.h"

@interface DiseaseClassController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation DiseaseClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [NSMutableArray array];
    
}
- (void)addConstraints
{
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.automaticallyAdjustsScrollViewInsets                     = NO;
    
    id collectionView = self.collectionView;
    id topLayoutGuide = self.topLayoutGuide;
    
    NSString *hVFL = @"H:|-(0)-[collectionView]-(0)-|";
    
    NSString *vVFL = @"V:|-(0)-[topLayoutGuide]-(0)-[collectionView]-(0)-|";
    
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLayoutGuide, collectionView)];
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLayoutGuide, collectionView)];
    
    [self.view addConstraints:hConsts];
    [self.view addConstraints:vConsts];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self addConstraints];
}
#pragma mark - 选中类别ID
-(void)setSelectId:(NSString *)selectId
{
    _selectId = selectId;
    
    [self getData];
}
#pragma mark - 设置选中类别的isSelect为Yes
-(NSArray *)setSelectTrueWith:(NSArray *)list
{

    for (DoctorsHealthClass *model in list)
    {
        if ([model.disease_category_id isEqualToString:self.selectId])
        {
            model.isSelect = [NSNumber numberWithInt:1];
        }else{
            model.isSelect = [NSNumber numberWithInt:0];;
        }
    }
    
    return list;
}
#pragma mark - 获取类别数据
-(void)getData
{
    [self showLoadingView:64];
    [DoctorsHealthList getDoctorsHealthClassWithSuccess:^(NSArray *lists) {
        
        [self.dataArr addObjectsFromArray:[self setSelectTrueWith:lists]];
        [self.collectionView reloadData];
        [self.collectionView removeNoDataTipsView];
        
        if (lists.count == 0)
        {
            [self.collectionView setNoDataTipsView:0];
        }
        
        [self dismissLoadingView];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        [self dismissLoadingView];
        
    }];
}
#pragma mark - *** collectionView Delegate ***
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DiseaseClassCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"DiseaseClassCell" forIndexPath:indexPath];
    
    DoctorsHealthClass *model = self.dataArr[indexPath.row];
    
    cell.model = model;
    
    cell.CellClickblock = ^(NSString *name,NSString *idStr)
    {
        if (self.DiseaseClassCellClickblock)
        {
            self.DiseaseClassCellClickblock(name,idStr);
            self.title = name;
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((ScreenW - 20)/ 3, 50);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5,5,5,5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

@interface DiseaseClassCell ()

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *chooseImagView;

@end

@implementation DiseaseClassCell

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.typeBtn.layer.borderWidth = 0.5;
    self.typeBtn.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    
}

-(void)setModel:(DoctorsHealthClass *)model
{

    _model = model;
    [self.typeBtn setTitle:model.category_name forState:UIControlStateNormal];
    self.typeBtn.selected = model.isSelect.intValue==1?YES:NO;
    self.chooseImagView.hidden = !self.typeBtn.selected;
    
}

- (IBAction)buttonAction:(UIButton *)sender
{
    [sender setBackgroundColor:HEXRGB(0xeeeeee)];
    if (self.CellClickblock)
    {
        self.CellClickblock(sender.titleLabel.text,self.model.disease_category_id);
    }
}

@end














