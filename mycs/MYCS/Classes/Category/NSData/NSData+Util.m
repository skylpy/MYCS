//
//  NSData+Util.m
//  MYCS
//
//  Created by AdminZhiHua on 16/3/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "NSData+Util.h"

@implementation NSData (Util)

//归档
+ (NSMutableData *)encodeWith:(id)object key:(NSString *)key {
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [encoder encodeObject:object forKey:key];
    [encoder finishEncoding];
    
    return data;
}

//解档
+ (id)decodeWith:(NSData *)data key:(NSString *)key {
    
    NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id model = [decoder decodeObjectForKey:key];
    [decoder finishDecoding];
    
    return model;
}

@end
