//
//  SelectPickView.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/15.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "SelectPickView.h"
#import "AreaModel.h"
#import "IndustryModel.h"
#import "OfficeModel.h"
#import "PositionModel.h"
#import "JobTitleModel.h"
#import "MajorModel.h"

@interface SelectPickView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) AreaModel *areaModel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *toolBarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickViewBottomConst;

@property (nonatomic,assign) NSInteger provinceIndex;
@property (nonatomic,assign) NSInteger cityIndex;
@property (nonatomic,assign) NSInteger areaIndex;

///所属行业
@property (nonatomic,strong) NSArray *industryArr;
@property (nonatomic,assign) NSInteger industryIndex;

///所属科室
@property (nonatomic,strong) NSArray *officeArr;
@property (nonatomic,assign) NSInteger officeIndex;

///行政职位
@property (nonatomic,strong) NSArray *positionArr;
@property (nonatomic,assign) NSInteger positionIndex;

///职称
@property (nonatomic,strong) NSArray *jobArr;
@property (nonatomic,assign) NSInteger jobIndex;

///专业
@property (nonatomic,strong) NSArray *majorArr;
@property (nonatomic,assign) NSInteger majorIndex;

@property (nonatomic,assign) NSInteger majorChildIndex;


@end

@implementation SelectPickView

#pragma mark – life cycle
- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.bgView.alpha = 0;
    self.pickViewBottomConst.constant = -251;
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:1 animations:^{
        
        self.bgView.alpha = 0.4;
        self.pickViewBottomConst.constant = 0;
        [self layoutIfNeeded];
        
    }];
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [control addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:control];
    
}

+(instancetype)selectPickView
{
    
    return[[[NSBundle mainBundle] loadNibNamed:@"SelectPickView" owner:nil options:nil]lastObject];
}

-(void)selectWith:(NSString *)prov andCity:(NSString *)city andArea:(NSString *)area
{
    
    self.frame = [UIScreen mainScreen].bounds;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    for (Province *proModel in self.areaModel.provinceArr)
    {
        if ([proModel.text isEqualToString:prov])
        {
            [self.pickView selectRow:[self.areaModel.provinceArr indexOfObject:proModel] inComponent:0 animated:NO];
            
            self.provinceIndex = [self.areaModel.provinceArr indexOfObject:proModel];
            //部份刷新
            [self.pickView reloadComponent:1];
            [self.pickView reloadComponent:2];
            
            [self.pickView selectRow:0 inComponent:1 animated:YES];
            [self.pickView selectRow:0 inComponent:2 animated:YES];
            
            for (City *cityModel in proModel.children)
            {
                if ([cityModel.text isEqualToString:city])
                {
                    
                    [self.pickView selectRow:[proModel.children indexOfObject:cityModel] inComponent:1 animated:NO];
                    
                    self.cityIndex = [proModel.children indexOfObject:cityModel];
                    
                    [self.pickView reloadComponent:2];
                    
                    [self.pickView selectRow:0 inComponent:2 animated:YES];
                    
                    
                    for (Area *areaModel in cityModel.children)
                    {
                        if ([areaModel.text isEqualToString:area])
                        {
                            
                            [self.pickView selectRow:[cityModel.children indexOfObject:areaModel] inComponent:2 animated:NO];
                            
                            self.areaIndex = [cityModel.children indexOfObject:areaModel];
                        }
                    }
                }
            }
        }
    }
    
}

- (void)showWithBlock:(void (^)(SelectPickView *, NSString *, NSString *, NSString *, NSString *, NSString *))completeBlock {
    
    self.actionBlock = completeBlock;
}

+ (void)showWithType:(SelectPickViewType)type complete:(void (^)(SelectPickView *, NSString *, NSString *, NSString *, NSString *, NSString *))completeBlock {
    
    SelectPickView *pickView = [[[NSBundle mainBundle] loadNibNamed:@"SelectPickView" owner:nil options:nil]lastObject];
    
    pickView.type = type;
    pickView.actionBlock = completeBlock;
    
    pickView.frame = [UIScreen mainScreen].bounds;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:pickView];
    
}


#pragma mark – Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    if (self.type == SelectPickViewTypeArea)
    {
        return 3;
    }else if(self.type == SelectPickViewTypeMajor)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (self.type == SelectPickViewTypeArea) {
        
        AreaModel *model = self.areaModel;
        
        if (component == 0)
        {
            return model.provinceArr.count;
        }
        else if (component == 1)
        {
            Province *province = model.provinceArr[self.provinceIndex];
            return province.children.count;
        }
        else if (component == 2)
        {
            Province *province = model.provinceArr[self.provinceIndex];
            City *city = province.children[self.cityIndex];
            return city.children.count;
        }
        
    }
    else if (self.type == SelectPickViewTypeIndustry)
    {
        return self.industryArr.count;
    }
    else if (self.type == SelectPickViewTypeOffice)
    {
        return self.officeArr.count;
    }
    else if (self.type == SelectPickViewTypeAdminPostion)
    {
        return self.positionArr.count;
    }
    else if (self.type == SelectPickViewTypePosition)
    {
        return self.jobArr.count;
    }
    else if (self.type == SelectPickViewTypeMajor)
    {
        if (component == 0) {
            return self.majorArr.count;
        }else if (component == 1)
        {
            MajorModel *model = self.majorArr[self.majorIndex];
            
            return model.children.count;
        }
    }
    
    return 1;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.type == SelectPickViewTypeArea) {
        
        AreaModel *model = self.areaModel;
        
        if (component == 0)
        {
            Province *province = model.provinceArr[row];
            return province.text;
        }
        else if (component == 1)
        {
            Province *province = model.provinceArr[self.provinceIndex];
            City *city = province.children[row];
            
            return city.text;
        }
        else if (component == 2)
        {
            Province *province = model.provinceArr[self.provinceIndex];
            City *city = province.children[self.cityIndex];
            Area *area = city.children[row];
            return area.text;
        }
        
    }
    else if (self.type == SelectPickViewTypeIndustry)
    {
        IndustryModel *model = self.industryArr[row];
        return model.name;
    }
    else if (self.type == SelectPickViewTypeOffice)
    {
        OfficeModel *model = self.officeArr[row];
        return model.industryName;
    }
    else if (self.type == SelectPickViewTypeAdminPostion)
    {
        PositionModel *model = self.positionArr[row];
        return model.name;
    }
    else if (self.type == SelectPickViewTypePosition)
    {
        JobTitleModel *model = self.jobArr[row];
        return model.name;
    }
    else if (self.type == SelectPickViewTypeMajor)
    {
        if (component == 0)
        {
            MajorModel *major = self.majorArr[row];
            
            return major.label;
        }
        else if (component == 1)
        {
            MajorModel *major = self.majorArr[self.majorIndex];
            MajorModel *childMajor = major.children[row];
            
            return childMajor.label;
        }
        
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        pickerLabel.font = [UIFont systemFontOfSize:14];
    }
    
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (self.type == SelectPickViewTypeArea) {
        if (component == 0)
        {
            self.provinceIndex = row;
            
            self.cityIndex = 0;
            
            self.areaIndex = 0;
            //部份刷新
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        else if (component == 1)
        {
            self.cityIndex = row;
            
            self.areaIndex = 0;
            
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        else if (component == 2)
        {
            self.areaIndex = row;
        }
    }
    else if (self.type == SelectPickViewTypeIndustry)
    {
        self.industryIndex = row;
    }
    else if (self.type == SelectPickViewTypeOffice)
    {
        self.officeIndex = row;
    }
    else if (self.type == SelectPickViewTypeAdminPostion)
    {
        self.positionIndex = row;
    }
    else if (self.type == SelectPickViewTypePosition)
    {
        self.jobIndex = row;
    }
    else if (self.type == SelectPickViewTypeMajor)
    {
        if (component == 0)
        {
            self.majorIndex = row;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
        else if (component == 1)
        {
            self.majorChildIndex = row;
        }
    }
}

#pragma mark – CustomDelegate



#pragma mark – Event
- (IBAction)cancelAction:(UIButton *)sender {
    
    [self dismissAction];
    
}

- (IBAction)sureAction:(UIButton *)sender {
    
    if (self.actionBlock) {
        
        if (self.type == SelectPickViewTypeArea) {
            
            Province *province = self.areaModel.provinceArr[self.provinceIndex];
            City *city = province.children[self.cityIndex];
            Area *area = city.children[self.areaIndex];
            
            NSString *selectStr = [NSString stringWithFormat:@"%@%@%@",province.text,city.text,area.text];
            
            self.actionBlock(self,selectStr,province.id,city.id,area.id,nil);
        }
        else if (self.type == SelectPickViewTypeIndustry)
        {
            
            IndustryModel *model = self.industryArr[self.industryIndex];
            
            self.actionBlock(self,model.name,nil,nil,nil,model.modelID);
            
        }
        else if (self.type == SelectPickViewTypeOffice)
        {
            OfficeModel *model = self.officeArr[self.officeIndex];
            
            self.actionBlock(self,model.industryName,nil,nil,nil,model.industryId);
        }
        else if (self.type == SelectPickViewTypeAdminPostion)
        {
            PositionModel *model = self.positionArr[self.positionIndex];
            self.actionBlock(self,model.name,nil,nil,nil,model.id);
        }
        else if (self.type == SelectPickViewTypePosition)
        {
            JobTitleModel *model = self.jobArr[self.jobIndex];
            self.actionBlock(self,model.name,nil,nil,nil,model.id);
        }
        else if (self.type == SelectPickViewTypeMajor)
        {
            MajorModel *major = self.majorArr[self.majorIndex];
            MajorModel *childMajor = major.children[self.majorChildIndex];
            NSString *select = [NSString stringWithFormat:@"%@/%@",major.label,childMajor.label];
            NSString *key = [NSString stringWithFormat:@"%@#%@",major.modelID,childMajor.modelID];
            
            self.actionBlock(self,select,nil,nil,nil,key);
        }
    }
    
    [self dismissAction];
}

- (void)dismissAction {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0;
        self.pickViewBottomConst.constant = -251;
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark - Network



#pragma mark – Private



#pragma mark – Getter/Setter
- (void)setType:(SelectPickViewType)type {
    _type = type;
    
    if (type == SelectPickViewTypeArea) {
        AreaModel *model = [AreaModel getAreaInfo];
        self.areaModel = model;
    }
    else if (type == SelectPickViewTypeIndustry)
    {
        self.industryArr = [self makeIndustryDB];
    }
    else if (type == SelectPickViewTypeOffice)
    {
        [OfficeModel getOfficeListSuccess:^(NSArray *list) {
            
            self.officeArr = list;
            [self.pickView reloadAllComponents];
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    else if (type == SelectPickViewTypeAdminPostion)
    {
        [PositionModel requestPositionSuccess:^(NSArray *list) {
            
            self.positionArr = list;
            [self.pickView reloadAllComponents];
            
        } failure:^(NSError *error) {
            
        }];
    }
    else if (type == SelectPickViewTypePosition)
    {
        [JobTitleModel requestJobsTitleSuccess:^(NSArray *list) {
            
            self.jobArr = list;
            [self.pickView reloadAllComponents];
            
        } failure:^(NSError *error) {
            
        }];
    }
    else if (type == SelectPickViewTypeMajor)
    {
        [MajorModel requestMajorSuccess:^(NSArray *list) {
            
            self.majorArr = list;
            
            [self.pickView reloadAllComponents];
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (NSArray *)makeIndustryDB
{
    IndustryModel *m0 = [[IndustryModel alloc] init];
    m0.modelID = @"1";
    m0.name = @"计算机/IT/互联网";
    
    IndustryModel *m1 = [[IndustryModel alloc] init];
    m1.modelID = @"71";
    m1.name = @"电子商务";
    
    IndustryModel *m2 = [[IndustryModel alloc] init];
    m2.modelID = @"26";
    m2.name = @"生物制药/医疗器械";
    
    IndustryModel *m3 = [[IndustryModel alloc] init];
    m3.modelID = @"30";
    m3.name = @"广告/设计/创意";
    
    IndustryModel *m4 = [[IndustryModel alloc] init];
    m4.modelID = @"49";
    m4.name = @"餐饮/酒店/旅游";
    
    IndustryModel *m5 = [[IndustryModel alloc] init];
    m5.modelID = @"16";
    m5.name = @"生产/加工/制造";
    
    IndustryModel *m6 = [[IndustryModel alloc] init];
    m6.modelID = @"64";
    m6.name = @"其它行业";
    
    NSArray *arr = [NSArray arrayWithObjects:m0, m1, m2, m3, m4, m5, m6, nil];
    
    return arr;
    
}


@end
