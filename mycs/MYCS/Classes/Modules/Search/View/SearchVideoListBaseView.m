//
//  SearchVideoListBaseView.m
//  MYCS
//
//  Created by wzyswork on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchVideoListBaseView.h"

#import "UIImageView+WebCache.h"
#import "SearchVideoListCell.h"

#import "VCSDetailViewController.h"
#import "SearchMoreVideoController.h"

#import "SearchModel.h"

@interface SearchVideoListBaseView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBtnHeight;


@end

@implementation SearchVideoListBaseView

+ (instancetype)SearchVideoListBaseView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SearchVideoListBaseView" owner:nil options:nil] lastObject];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    self.hidden = YES;
    
}

-(void)setType:(int)type
{
    _type = type;
    
    if (self.datasource.count == 3)
    {
        self.moreBtn.hidden = YES;
        self.moreBtnHeight.constant = 0.1;
        
        self.collectionView.height = 155 * 2 + 21;
        
        self.height = CGRectGetMaxY(self.collectionView.frame);
        
    }else if (self.datasource.count < 3)
    {
        self.moreBtn.hidden = YES;
        self.moreBtnHeight.constant = 0.1;
        
        self.collectionView.height = 166;
        
        self.height =CGRectGetMaxY(self.collectionView.frame);
        
    }else
    {
        self.moreBtn.hidden = NO;
        self.moreBtnHeight.constant = 50;
        
        self.collectionView.height = 155 * 2 + 21;
        
        self.height = self.moreBtn.y + self.moreBtn.height;
        
    }
    
    if (self.datasource.count > 0)
    {
        self.hidden = NO;
    }
    
    [self.collectionView reloadData];
}


#pragma mark -collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.datasource.count > 4)
    {
        return 4;
    }
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * VideoCellID = @"SearchVideoListCell";
    UINib * nib = [UINib nibWithNibName:@"SearchVideoListCell"
                                 bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:VideoCellID];
    
    SearchVideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VideoCellID forIndexPath:indexPath];
    
    if (self.type == 1)
    {
        searchAllVideoDataModel *model = self.datasource[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:PlaceHolderImage];
        cell.typeL.text = @"视频";
        [cell.playNumBtn setTitle:model.click forState:UIControlStateNormal];
        [cell.praiseNumBtn setTitle:model.up forState:UIControlStateNormal];
        cell.titleL.text = model.title;
        
    }else if (self.type == 2)
    {
        searchAllcourseDataModel *model = self.datasource[indexPath.row];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:PlaceHolderImage];
        cell.typeL.text = @"教程";
        [cell.playNumBtn setTitle:model.viewers forState:UIControlStateNormal];
        [cell.praiseNumBtn setTitle:model.up forState:UIControlStateNormal];
        cell.titleL.text = model.name;
        
        
    }else if (self.type == 3)
    {
        searchAllsopDataModel *model = self.datasource[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:PlaceHolderImage];
        cell.typeL.text = @"SOP";
        [cell.playNumBtn setTitle:model.click forState:UIControlStateNormal];
        [cell.praiseNumBtn setTitle:model.up forState:UIControlStateNormal];
        cell.titleL.text = model.name;
        
        
    }
    
    //CGSize size = [cell.praiseNumBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGSize size = [cell.praiseNumBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    cell.praiseNumBtnWidth.constant = size.width + 35;
    
    //CGSize size1 = [cell.playNumBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGSize size1 = [cell.playNumBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    cell.playNumBtnWidth.constant = size1.width + 35;
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((ScreenW - 21)/2, 155);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 7, 10, 7);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * videoId = [NSString string];
    
    VCSDetailViewController *vcsVC = [[UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil] instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];
    
    if (self.type == 1)
    {
        searchAllVideoDataModel *model = self.datasource[indexPath.row];
        videoId = model.id;
        vcsVC.type = VCSDetailTypeVideo;
        
    }else if (self.type == 2)
    {
        searchAllcourseDataModel *model = self.datasource[indexPath.row];
        videoId = model.courseId;
        vcsVC.type = VCSDetailTypeCourse;
        
    }else if (self.type == 3)
    {
        searchAllsopDataModel *model = self.datasource[indexPath.row];
        videoId = model.id;
        vcsVC.type = VCSDetailTypeSOP;
    }
    
    vcsVC.videoId = videoId;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vcsVC animated:YES];
    
    
}
- (IBAction)moreBtnAction:(id)sender
{
    
    SearchMoreVideoController * vc = [[UIStoryboard storyboardWithName:@"Search" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchMoreVideoController"];
    vc.type = self.type;
    vc.keyword = self.keyWord;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
    
    //    if (self.moreBtnClickBlock)
    //    {
    //        self.moreBtnClickBlock(self.type);
    //    }
}

@end
