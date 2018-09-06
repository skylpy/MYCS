//
//  EvalutaionTableViewCellHeight.m
//  MYCS
//
//  Created by Yell on 16/1/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "EvalutaionTableViewCellHeight.h"


#define  LabelTopViewHeight 60
#define btnViewHeight 50
#define margin 10
@implementation EvalutaionTableViewCellHeight


+(CGFloat)calculateCellHeightWithInsidersModel:(EvaluationInsidersModel *)model view:(UIView *)view andStutasType:(EvaluationStutasType)stutasType
{
 
    
    CGSize Size = [model.content boundingRectWithSize:CGSizeMake(view.width-2*margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    if (stutasType == EvaluationStutasTypeAccept)
    {
        return Size.height+LabelTopViewHeight+margin;
    }else
    {
        return Size.height+LabelTopViewHeight+margin + 25;
    }
    
}

+(CGFloat)calculateCellHeightWithOtherModel:(EvaluationOtherModel *)model view:(UIView *)view andStutasType:(EvaluationStutasType)stutasType andTargeType:(EvaluationTargetType)targeType
{
    CGSize contentSize;
    if (model.content.length>0) {
          contentSize = [model.content boundingRectWithSize:CGSizeMake(view.width-2*margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    }

    
    
    NSString *replyStr = [NSString string];
    
    NSString * targeStr;
    
    if (targeType == EvaluationTargetTypeCase)
    {
        targeStr = @"案例中心";
    }else if (targeType == EvaluationTargetTypeExchange)
    {
        targeStr = @"学术交流";
        
    }else if (targeType == EvaluationTargetTypeVideo)
    {
        targeStr = @"视频空间";
    }
    
    if(model.reply_content == nil || [model.reply_content isEqualToString:@""])
    {
        replyStr = [NSString stringWithFormat:@"@%@的%@回复",model.from_realname,targeStr];
        
    }
    else
    {
        replyStr = [NSString stringWithFormat:@"@%@的%@回复:%@",model.from_realname,targeStr,model.reply_content];
    }
    
    CGSize replySize = [replyStr boundingRectWithSize:CGSizeMake(view.width-2*margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    if (stutasType == EvaluationStutasTypeSend)
    {
        CGFloat totalHeight =contentSize.height+replySize.height+LabelTopViewHeight+margin;
        return totalHeight;
    }else
    {
      CGFloat totalHeight =contentSize.height+replySize.height+LabelTopViewHeight+btnViewHeight+margin;
        
        return totalHeight;
    }

}

@end
