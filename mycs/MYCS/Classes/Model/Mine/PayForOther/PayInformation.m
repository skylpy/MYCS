//
//  PayInformation.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "PayInformation.h"
#import "SCBModel.h"

//#import "Order.h"
//#import "DataSigner.h"
//#import <AlipaySDK/AlipaySDK.h>

@implementation PayInformation

+ (void)makeBillWithUserID:(NSString *)userID userType:(NSString *)userType goodsID:(NSString *)goodsID goodsType:(NSString *)goodsType goodsName:(NSString *)goodsName remark:(NSString *)remark success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:REQUESTBUY_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:goodsID forKey:@"goodsId"];
    [params setObjectNilToEmptyString:goodsType forKey:@"goodsType"];
    [params setObjectNilToEmptyString:goodsName forKey:@"goodsName"];
    [params setObjectNilToEmptyString:remark forKey:@"remark"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)requestPayInformationWithUserID:(NSString *)userID userType:(NSString *)userType commentType:(NSString *)commentType buyID:(NSString *)buyID Success:(void (^)(PayInformation *payInfo))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:PAYCONFIRM_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:commentType forKey:@"comment_type"];
    [params setObjectNilToEmptyString:buyID forKey:@"buy_cid"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        PayInformation *temp = [[PayInformation alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(temp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//+ (void)creatWithOrderNo:(NSString *)orderNO orderName:(NSString *)orderName orderDescription:(NSString *)orderDescription orderPrice:(NSString *)orderPrice
//{
//    /*
//     *商户的唯一的parnter和seller。
//     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
//     */
//    
//    /*============================================================================*/
//    /*=======================需要填写商户app申请的===================================*/
//    /*============================================================================*/
//    NSString *partner = @"2088811677328371";
//    
//    NSString *seller = @"supporter@swwy.com";
//    
//    NSString *privateKey = @"MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBAO/RNZZRGkNvubgLkkaFnWaLczS4WPeHXIiWminXKug74c46vAEeSUqY17Xrv671i4TKSjWSi2qPbjUqVetHnNwvr1g0IsGX7irypIlD0O9TnmWXbbkiqGOKP44zA0NFDLVSfM0JpbeYVoBOadv0Zja/4P9GQhCLaXnI3hssJOFNAgMBAAECgYEAoR7/EMnWil5C+asUkLrugFnKgi4k39Ea003Tr663TiYFVKhTbbDqbur3amtEcojYPtQmPY4CiwpoceHKrfOEJ4IQiSR4p4+2FlGbBvBNqzKQUOlEVTz7guLWUclK3NO02nvfKOu8UvarrSsoH/LXhD3t/WGeZ+6bT9QOIltlBcUCQQD6TcFzvgFMltt5O6X5m/YKL13f46Arx6+HMOK1tfXjpM1zBhJ7DeLkrP8owsHKHONoFfYfBUqyAjgzjELTWucLAkEA9UZcPRDw3+qOzBh7UI1orvHVKniKtxHSQrbriiiwtfk+wpxM8dURClivDlqfhGnmwakS6V15UAJfmubFQBOwBwJBALMLMaj4Lfe6JW4X48aj8CAi97RyH52RbhZ3OoQej6/xr+BqZIfPTBClSrO+dF59wZEvvGk+IMsqWUdOOnLzIDcCQQDeXtkXgDlyOP0X6wY6BMqo+ZXSuJDC40RmueKYUsXLZdrRo9Va11por/ieIelHqp/MalY7/0QSFuTI0np42qCXAkEA7l6caRO2kj4iXAnqM5F5MoroMlXJaOhkR7gmAFbFqbj49RLTD28e07azN5RWzaPELFp4qmQ3Ruw5BbQWHp8V5A==";
//    /*============================================================================*/
//    /*============================================================================*/
//    /*============================================================================*/
//    
//    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.seller = seller;
//    order.tradeNO = orderNO; //订单ID（由商家自行制定）
//    order.productName = orderName; //商品标题
//    order.productDescription = orderDescription; //商品描述
//    order.amount = orderPrice; //商品价格
//    order.notifyURL =  @"http://www.swwy.com/app/apps/movePayNotify.php"; //回调URL
//    
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
//    
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"aliSWWY";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//        }];
//        
//    }
//    
//    
//}


@end
