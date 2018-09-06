//
//  NSDate+Util.m
//  SFPay
//
//  Created by ssf-2 on 14-11-13.
//  Copyright (c) 2014年 SF. All rights reserved.
//

#import "NSDate+Util.h"
#import "NSString+Util.h"

@implementation NSDate (Util)

+ (NSDate *)dateWithString:(NSString *)str format:(NSString *)formating
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formating];
    return [dateFormatter dateFromString:str];
}

+ (NSString *)dateToString:(NSDate *)date format:(NSString *)formating
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formating];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateWithTimeInterval:(NSTimeInterval)interval format:(NSString *)formating
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formating];
    return [dateFormatter stringFromDate:date];
}

+ (NSTimeInterval)timeIntervalWithString:(NSString *)str format:(NSString *)formating
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formating];
    NSDate *date = [dateFormatter dateFromString:str];
    return [date timeIntervalSince1970];
}

+ (NSDate *)dateWithStringMuitiform:(NSString *)str
{
    NSDate *time = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    time = [dateFormatter dateFromString:str];
    if (time == nil) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        time = [dateFormatter dateFromString:str];
    }
    if (time == nil) {
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        time = [dateFormatter dateFromString:str];
    }
    if (time == nil) {
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        time = [dateFormatter dateFromString:str];
    }
    if (time == nil) {
        [dateFormatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
        time = [dateFormatter dateFromString:str];
    }
    if (time == nil) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        time = [dateFormatter dateFromString:str];
    }
    if (time == nil) {
        [dateFormatter setDateFormat:@"MMdd"];
        time = [dateFormatter dateFromString:str];
    }
    return time;
}

+(NSString *)dateToSpecialTime:(NSDate *)time{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
    [inputFormatter setDateStyle:NSDateFormatterMediumStyle];
    [inputFormatter setTimeStyle:NSDateFormatterShortStyle];
    [inputFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSDateComponents *nowCom = [calendar components:unitFlags fromDate:nowDate];
    NSDateComponents *comCom = [calendar components:unitFlags fromDate:time];
    
    NSString *returnStr =@"";
    
    //如果为同一天
    if (([nowCom day] == [comCom day]) && ([nowCom month] == [comCom month]) && ([nowCom year]  == [comCom year])) {
        [inputFormatter setDateFormat:@"HH:mm"];
        returnStr = [inputFormatter stringFromDate:time];
    }else if(([nowCom year]  == [comCom year]) && ([nowCom day] == [comCom day] -1) && ([nowCom month] == [comCom month])){
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        returnStr = [inputFormatter stringFromDate:time];
    }else if(([nowCom year]  == [comCom year])){
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        returnStr = [inputFormatter stringFromDate:time];
    }else{
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        returnStr = [inputFormatter stringFromDate:time];

    }
    return returnStr;
}

+ (NSString *)timeWithSec:(int)totalSeconds format:(NSString*)format{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if (format.length == 0) {
        return @"00:00:00";
    }else{
        if ([format isEqualToString:@"HH:mm:ss"]) {
            return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
        }else if ([format isEqualToString:@"mm:ss"]){
            return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        }
    }
    return @"00:00:00";
}


@end
