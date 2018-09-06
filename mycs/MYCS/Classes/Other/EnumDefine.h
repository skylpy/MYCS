//
//  EnumDefine.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/15.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#ifndef EnumDefine_h
#define EnumDefine_h

typedef enum {
    
    ///实验室注册
    UserRegisterTypeLab,
    ///企业注册
    UserRegisterTypeEnterprise,
    ///医院注册
    UserRegisterTypeHospital,
    ///科室注册
    UserRegisterTypeOffice,
    ///个人注册
    UserRegisterTypePerson
    
}UserRegisterType;

typedef enum {
    
    ///所在城市
    SelectPickViewTypeArea,
    ///所属行业
    SelectPickViewTypeIndustry,
    ///所属科室
    SelectPickViewTypeOffice,
    ///行政职位
    SelectPickViewTypeAdminPostion,
    ///职称
    SelectPickViewTypePosition,
    ///专业
    SelectPickViewTypeMajor
    
}SelectPickViewType;

typedef enum {
    
    ///医务工作者
    PersonRegistTypeMedicalWorker,
    ///药学、生物行业从业人员
    PersonRegistTypePharmaceuticalWorker,
    ///药学企业市场、销售人员
    PersonRegistTypePharmaceuticalSaler,
    ///想了解医疗知识的大众用户
    PersonRegistTypeMassUser
    
}PersonRegistType;

/**
 *  专属平台类型, 要与服务器同步
 */
typedef NS_ENUM(NSInteger, PlatformType){
    /**
     *  企业
     */
    platform_company    = 5,
    /**
     *  科室
     */
    platform_office     = 185,
    /**
     *  医院
     */
    platform_hospital   = 183,
    /**
     *  实验室
     */
    platform_laboratory = 187
};

/**
 *  会员状态
 */
typedef NS_ENUM(NSInteger, ApplyStatus){
    
    /**
     *  未申请
     */
    applyStatus_no = -1,
    /**
     *  审核中
     */
    applyStatus_ing    = 0,
    /**
     *  审核通过
     */
    applyStatus_cross    = 1,
    /**
     *  已拒绝
     */
    applyStatus_reject   = 2,
    /**
     *  已过期
     */
    applyStatus_overdue = 3
};

typedef enum {
    TaskReleaseRecruitment,    // 发布招聘
    TaskReleaseTraining,       // 发布内训
    TaskReleaseMemberTask,     // 会员任务
}TaskReleaseType;

typedef enum {
    TaskVideoTypeCommon = 1,
    TaskVideoTypeSop ,
}TaskVideoType;


typedef enum {
    FromTypeAll = 0,   // 全部
    FromTypeMe = 1,    // 自制
    FromTypeBuy = 2,   // 购买
}FromType;

typedef enum {
    PaperAll = 0,      // 全部
    PaperNone = 1,     // 无考题
    PaperHas = 2,      // 有考题
}Paper;

typedef enum {
    IntPermAll = 0,      // 全部
    IntPermPublic = 2,   // 内部公开
    IntPermForhiden = 1, // 内部不公开
    
}IntPerm;

typedef enum {
    ExtPermAll = 0,            // 全部
    ExtPermPublic = 1,         // 外部公开
    ExtPermForhiden = 2,       // 外部不公开
    ExtPermPayPublic = 3,      // 外部付费公开
    ExtPermValidatePublic = 4, // 外部验证公开
}ExtPerm;



#endif /* EnumDefine_h */
