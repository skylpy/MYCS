//
//  SpolightHelper.m
//  test
//
//  Created by AdminZhiHua on 15/11/4.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "SpolightHelper.h"
#import <CoreSpotlight/CoreSpotlight.h>

@implementation SpolightModel

- (void)setImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 1);
    self.imageData = data;
}

- (NSString *)domain {
    if (!_domain) {
        _domain = @"cn.mycs";
    }
    return _domain;
}

@end

@implementation SpolightHelper

+ (void)addSearchItem:(SpolightModel *)model {
    
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@""];
    attributeSet.title = model.title;
    attributeSet.contentDescription = model.desc;
    attributeSet.phoneNumbers = model.phoneNumbers;
    attributeSet.thumbnailData = model.imageData;
    
    CSSearchableItem *item = [[CSSearchableItem alloc]initWithUniqueIdentifier:model.identify domainIdentifier:model.domain attributeSet:attributeSet];
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:nil];
}

+ (void)deleteAllSearchItems{
    
    [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:nil];
    
}

+ (void)deleteSearchItemByDomain:(NSString *)domain {
    
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithDomainIdentifiers:@[domain] completionHandler:nil];

}

+ (void)deleteSearchItemById:(NSString *)identify {
    
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:@[identify] completionHandler:nil];

}

@end
