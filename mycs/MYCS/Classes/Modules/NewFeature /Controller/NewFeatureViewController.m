//
//  NewFeatureViewController.m
//  SWWY
//
//  Created by AdminZhiHua on 15/11/5.
//  Copyright © 2015年 GuoChenghao. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "NewFeatureViewCell.h"
#import "AppDelegate.h"

static int const count = 4;
static NSString *const reuseId = @"NewFeatureViewCell";

@interface NewFeatureViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pageControl.numberOfPages = count;
    self.pageControl.pageIndicatorTintColor = HEXRGB(0xe5e5e5);
    self.pageControl.currentPageIndicatorTintColor = HEXRGB(0x46c2a7);
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    _pageControl.currentPage = page;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewFeatureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.view.width, self.view.height);
    
}

- (IBAction)enterBtnAction:(id)sender {
    
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [ProfileFocus loadAdPic];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *mainVC = [mainStoryBoard instantiateInitialViewController];
        [AppDelegate sharedAppDelegate].window.rootViewController = mainVC;
    }
    
}


@end
