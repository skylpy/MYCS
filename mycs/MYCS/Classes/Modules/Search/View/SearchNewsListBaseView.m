
//
//  SearchNewsListBaseView.m
//  MYCS
//
//  Created by wzyswork on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchNewsListBaseView.h"

#import "SearchModel.h"

#import "InformationCell.h"
#import "UIImageView+WebCache.h"

#import "SearchMoreOtherController.h"
#import "WebViewDetailController.h"

@interface SearchNewsListBaseView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBtnHeight;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SearchNewsListBaseView

+ (instancetype)searchNewsListBaseView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SearchNewsListBaseView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.hidden = YES;
    
}

-(void)reflesh
{
    
    if (self.datasource.count < 4)
    {
        self.moreBtn.hidden = YES;
        
        self.moreBtnHeight.constant = 0.1;
        
        self.height = 40 + self.datasource.count * 86;
        
    }else
    {
        self.moreBtn.hidden = NO;
        
        self.moreBtnHeight.constant = 50;
        
        self.height = CGRectGetMaxY(self.moreBtn.frame);
    }
    
    if (self.datasource.count > 0)
    {
        self.hidden = NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark -tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datasource.count > 4)
    {
        return 4;
    }
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *NewsCellID = @"InformationCell";
    UINib * nib = [UINib nibWithNibName:@"InformationCell"
                                 bundle: [NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:NewsCellID];
    
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCellID];
    
    searchAllNewsDataModel * model = self.datasource[indexPath.row];
    
    [cell.ImageView sd_setBlurImageWithURL:[NSURL URLWithString:model.titlePic] placeholderImage:PlaceHolderImage];
    
    cell.TitleL.text = model.title;
    
    cell.ContentL.text = model.detail;
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    searchAllNewsDataModel * model = self.datasource[indexPath.row];
    
    WebViewDetailController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewDetailController"];
    
    webVC.urlStr = model.linkURL;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:webVC animated:YES];
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (IBAction)moreBtnAction:(id)sender
{
    
    SearchMoreOtherController * vc = [[UIStoryboard storyboardWithName:@"Search" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchMoreOtherController"];
    
    vc.keyword = self.keyWord;
    vc.type = 5;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
 
}



@end
