//
//  RelateVideoView.m
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "RelateVideoView.h"
#import "RelateVideoCell.h"
#import "DoctorsHealthList.h"

@implementation RelateVideoView

+ (instancetype)relateVideoView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"RelateVideoView" owner:nil options:nil] lastObject];
}


-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

-(void)setNumb:(NSInteger)numb
{
    _numb = numb;
    NSInteger count = numb / 2 + numb % 2;
    self.height = 0.4*ScreenW*count + 51 + 7*(count +1);

    [self.collectionView reloadData];
}

-(void)setDataArr:(NSArray *)dataArr
{
    
    _dataArr = dataArr;
    self.numb = dataArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.numb;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * VideoCellID = @"RelateVideoCell";
    UINib * nib = [UINib nibWithNibName:@"RelateVideoCell"
                                 bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:VideoCellID];
    
    RelateVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VideoCellID forIndexPath:indexPath];
    
    DoctorsHealthRelate *model = self.dataArr[indexPath.row];
    
    cell.model = model;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DoctorsHealthRelate *model = self.dataArr[indexPath.row];
    if (self.cellClickblock)
    {
        self.cellClickblock(model.des_id);
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((ScreenW - 21)/2, 0.4*ScreenW);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(7, 7, 7, 7);
    
}
@end

