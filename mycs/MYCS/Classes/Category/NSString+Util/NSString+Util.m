//
//  NSString+Util.m
//  GoGo
//
//  Created by GuoChengHao on 14-4-21.
//  Copyright (c) 2014年 Maxicn. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Util)

- (bool)contains: (NSString*) substring {
    NSRange range = [self rangeOfString:substring];
    return range.location != NSNotFound;
}

- (instancetype)trimmingWhitespaceAndNewline {
    NSString *newStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return newStr;
}

+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (NSTextCheckingResult *)matchRegularExpress:(NSString *)regularExpress inString:(NSString *)string{
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regularExpress options:0 error:nil];
    
    NSTextCheckingResult *match = [regular firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    
    return match;
}

- (BOOL)validateMobile//:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    //NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *MOBILE = @"^(1)\\d{10}$";
    
    //    /**
    //     10         * 中国移动：China Mobile
    //     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    //     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //    /**
    //     15         * 中国联通：China Unicom
    //     16         * 130,131,132,152,155,156,185,186
    //     17         */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //    /**
    //     20         * 中国电信：China Telecom
    //     21         * 133,1349,153,180,189
    //     22         */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    //    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})-\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:self] == YES))
        //        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        //        || ([regextestct evaluateWithObject:mobileNum] == YES)
        //        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        //        || ([regextestphs evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)toJSONString:(id)theData {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }else{
        return nil;
    }
}

- (id)JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

+ (NSDictionary *)getChineseStringArr:(NSArray *)dataSource  key:(NSString *)key{
    NSMutableArray *sectionHeadsKeysList = [[NSMutableArray alloc]init];
    NSMutableArray *chineseStringsArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < [dataSource count]; i++) {
        NSDictionary *dicData = [dataSource objectAtIndex:i];
        
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=[NSString stringWithString:[dicData valueForKey:key]];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        chineseString.index = i;
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr;
        if (strchar.length>0) {
            sr = [strchar substringToIndex:1];
        }else{
            sr = @"";
        }
        //        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![sectionHeadsKeysList containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [sectionHeadsKeysList addObject:[sr uppercaseString]];
            
            // 修改数组的警告3.4
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:[NSNull null], nil];
            checkValueAtIndex = NO;
        }
        if([sectionHeadsKeysList containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO && [TempArrForGrouping count]>0)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:sectionHeadsKeysList, @"sectionHeads", arrayForArrays, @"chineseStrings", nil];
    
    return dic;
}

+(NSString *)validLoginPwd:(NSString *)value andMobile:(NSString *)mobile{

    // 6-20 个字符
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^.{6,20}$"] evaluateWithObject:value]){
        return @"登录密码必须6至20位字母、数字或者符号组合";
    }
    // 不能是纯数字
    if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d+$"] evaluateWithObject:value]){
        return @"登录密码不能是纯数字、纯字母或者纯符号";
    }
    // 不能是纯字母
    if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-z]+$"] evaluateWithObject:value]){
        return @"登录密码不能是纯数字、纯字母或者纯符号";
    }
    // 不能是纯符号
    if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[\\W_]+$"] evaluateWithObject:value]){
        return @"登录密码不能是纯数字、纯字母或者纯符号";
    }
    // 登录密码首尾不能为空格
//    if ([value hasPrefix:@" "] || [value hasSuffix:@" "]){
//        return @"登录密码首尾不能为空格";
//    }
    // 登录密码不能包含空格
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[^\\s]+$"] evaluateWithObject:value]) {
        return @"登录密码不能包含空格";
    }
    // 密码中不能包含有连续四位及以上重复字符，字母不区分大小写；（如：8888、AAAA、$$$$等）
    if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @".*(.)\\1{3,}.*"] evaluateWithObject:[value lowercaseString]]){
        return @"登录密码不能包含四位重复数字、字母或符号";
    }
    // 不能将帐号名作为密码的一部分存在于密码，帐号密码也不能一样
    if ([value isEqualToString:mobile] || ([value rangeOfString:mobile].location != NSNotFound)) {
        return @"登录密码不能包含账号信息";
    }
//    // 常用禁忌词不区分大小写不能作为密码的一部分存在于密码中
//    if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @".*(admin|pass).*"] evaluateWithObject:value]){
//        return @"";
//    }

    // 不能包含有连续四位及以上顺序(或逆序)数字或字母；（如：1234、abcd等）
    int asc = 1;
    int desc = 1;
    int lastChar = [value characterAtIndex:0];
    for (int i = 1; i < value.length - 1 ; i++) {
        int currentChar = [value characterAtIndex:i];
        if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9]+$"] evaluateWithObject:[value substringWithRange:NSMakeRange(i, 1)]]) {
            asc = 0;
            desc = 0;
        } else if (lastChar == currentChar - 1) {
            asc++;
            desc = 1;
        } else if (lastChar == currentChar + 1) {
            desc++;
            asc = 1;
        } else {
            asc = 1;
            desc = 1;
        }
        
        if (asc >= 4 || desc >= 4) {
            return @"登录密码不能包含四位连续数字、字母或符号";
        }
        lastChar = currentChar;
    }
    
    
    return nil;
}

//32位MD5加密方式
- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr,(CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

//保留小数有效位
+ (NSString *)changeFloat:(NSString *)stringFloat
{
    const char *floatChars = [stringFloat UTF8String];
    NSInteger length = [stringFloat length];
    NSInteger zeroLength = 0;
    NSInteger i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}

+ (NSString *)formate:(id)obj{
    return [NSString stringWithFormat:@"%@",obj];
}

//+ (NSTextCheckingResult *)matchRegularExpress:(NSString *)regularExpress inString:(NSString*)string{
//    
//    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regularExpress options:0 error:nil];
//    
//    NSTextCheckingResult *match = [regular firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
//    
//    return match;
//}

@end
