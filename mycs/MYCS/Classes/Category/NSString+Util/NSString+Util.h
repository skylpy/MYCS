//
//  NSString+Util.h
//  GoGo
//
//  Created by GuoChengHao on 14-4-21.
//  Copyright (c) 2014年 Maxicn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChineseString.h"
#import "pinyin.h"

@interface NSString (Util)

- (bool)contains: (NSString*) substring;
/**
 去掉首尾的空格和换行
 */
- (instancetype)trimmingWhitespaceAndNewline;

/**
 判断字符串是否为空
 */
+(BOOL)isBlankString:(NSString *)string;

/**
 判断是否为可用电话号码
 */
- (BOOL)validateMobile;//:(NSString *)mobileNum;

/**
 * 把数组字典等转成json字符串
 */
+ (NSString *)toJSONString:(id)theData;

/**
 * 把json字符串转成数组或字典
 */
- (id)JSONValue;

/**
 *按拼音排序
 */
+ (NSDictionary *)getChineseStringArr:(NSArray *)dataSource  key:(NSString *)key;

/**
 *	@brief	验证登录密码
 *
 *	@param 	value 	值
 *  @param 	mobile 	账号
 *	@return	yes为通过
 */
+ (NSString *)validLoginPwd:(NSString *)value andMobile:(NSString *)mobile;

/**
 *	@brief	32位md5加密
 *
 *	@return	md5加密串
 */
- (NSString *)MD5;

/**
 *	@brief	保留小数有效位
 *
 *	@param 	stringFloat 	原数字
 *
 *	@return	去掉0后的数
 */
+ (NSString *)changeFloat:(NSString *)stringFloat;

/**
 *	@brief	id 转成字符串
 *
 *	@param 	obj 	原数字
 *
 *	@return	字符串
 */
+ (NSString *)formate:(id)obj;

//判断正则表达式
+ (NSTextCheckingResult *)matchRegularExpress:(NSString *)regularExpress inString:(NSString *)string;


@end
