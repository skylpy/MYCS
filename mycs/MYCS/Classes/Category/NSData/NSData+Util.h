//
//  NSData+Util.h
//  MYCS
//
//  Created by AdminZhiHua on 16/3/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Util)

//归档
+ (NSMutableData *)encodeWith:(id)object key:(NSString *)key;

//解档
+ (id)decodeWith:(NSData *)data key:(NSString *)key;

@end
