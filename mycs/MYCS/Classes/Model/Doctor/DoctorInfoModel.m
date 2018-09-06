//
//  DoctorInfoModel.m
//  SWWY
//
//  Created by zhihua on 15/6/27.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "DoctorInfoModel.h"
#import "SCBModel.h"
#import "MJExtension.h"

@implementation ExtraInfo

@end

@implementation Treatise

@end

@implementation Education

@end

@implementation Honour


@end

@implementation DoctorInfoModel

+ (void)doctorInfoWithDoctorUid:(NSString *)uid success:(void (^)(DoctorInfoModel *doctorInfo))success failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"doctorIndex";
    param[@"doctorUid"] = uid;
    [param setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    
    NSString *path = [HOST_URL stringByAppendingString:DOCTOR_PATH];
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        DoctorInfoModel *doctorInfo = [DoctorInfoModel objectWithKeyValues:model.data];
        
        NSArray *educationArr = [Education objectArrayWithKeyValuesArray:model.data[@"eduList"]];
        doctorInfo.eduList = educationArr;
        
        NSArray *honourArr = [Honour objectArrayWithKeyValuesArray:model.data[@"honourList"]];
        doctorInfo.honourList = honourArr;
        
        NSArray *treatiseArr = [Treatise objectArrayWithKeyValuesArray: model.data[@"treatiseList"]];
        doctorInfo.treatiseList = treatiseArr;
        
        if (success) {
            success(doctorInfo);
        }
                
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}

@end
