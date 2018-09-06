//
//  NewClassifySearchViewController.h
//  MYCS
//
//  Created by yiqun on 16/3/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewClassifySearchViewController : UIViewController
/**
 *  页面标题
 */
@property (strong, nonatomic) NSString *titleString;

/**
 *  首页的type 和分类的type不同，分类的type为video course sop
 */

/**
 *  分类页面中二级分类中的cid
 */
@property (strong, nonatomic) NSString *cid;

@property (copy,nonatomic) NSString *searchStr;



@end


/*!
 @author Sky, 16-04-18 14:04:48
 
 @brief NewClassifySearchCollectionView
 
 @since 
 */
@interface NewClassifySearchCollectionView : UICollectionView

@end
