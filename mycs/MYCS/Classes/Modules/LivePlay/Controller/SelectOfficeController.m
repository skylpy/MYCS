//
//  SelectOfficeController.m
//  MYCS
//
//  Created by GuiHua on 16/8/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SelectOfficeController.h"
#import "VideoSpaceModel.h"
#import "SelectClassButton.h"
#import "MJRefresh.h"

@interface SelectOfficeController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation SelectOfficeController

static NSString * const reuseIdentifier = @"SelectOfficeCell";

-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat itemW = (ScreenW-10*2-15*2)/3;
    
    self.flowLayout.itemSize = CGSizeMake(itemW, 40);
    
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.collectionView headerBeginRefreshing];
}
-(void)setSelectID:(NSString *)selectID
{
    _selectID = selectID;
}
#pragma mark - Network
- (void)loadNewData {
    
    [ClassModel classOfficeListWithSuccess:^(NSArray *list) {
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[self selectModel:list]];
        
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.collectionView headerEndRefreshing];
        [self showError:error];
    }];
}
-(NSArray *)selectModel:(NSArray *)list
{
    for (ClassModel * model in list) {
        
        if ([model.id isEqualToString:self.selectID])
        {
            model.select = YES;
        }
        
    }
    
    return list;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectOfficeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ClassModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    
    __weak typeof(self)weakSetf = self;
    cell.selectCellBackBlock = ^(NSString *strName,NSString *strID)
    {
        if (self.selectBackBlock)
        {
            weakSetf.selectBackBlock(model.text,model.id);
            [weakSetf.navigationController popViewControllerAnimated:YES];
        }
    };
    
    return cell;
}

@end

@interface SelectOfficeCell ()

@property (weak, nonatomic) IBOutlet SelectClassButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;

@end

@implementation SelectOfficeCell

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
    
    if (self.selectCellBackBlock)
    {
        self.selectCellBackBlock(self.model.text,self.model.id);
    }
}
@end
