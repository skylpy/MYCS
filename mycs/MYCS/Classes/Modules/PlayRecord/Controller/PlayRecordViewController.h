//
//  PlayRecordViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PlayRecordType) {
    PlayRecordTypeNetwork,
    PlayRecordTypeLocal
};

@interface PlayRecordViewController : UIViewController

//@property (nonatomic,assign) PlayRecordType recordType;

@end

@class PlayRecordModel;
@interface PlayRecordCell : UICollectionViewCell

@property (nonatomic,strong) PlayRecordModel *model;

@end
