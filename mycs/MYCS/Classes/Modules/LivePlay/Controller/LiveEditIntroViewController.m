//
//  LiveEditIntroViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/4/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "LiveEditIntroViewController.h"
#import "NSString+Util.h"

@interface LiveEditIntroViewController ()

@property (weak, nonatomic) IBOutlet UITextView *introTextView;

@end

@implementation LiveEditIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.introTextView.text = self.content;
}

-(void)setContent:(NSString *)content
{
    _content = content;
}

- (IBAction)saveButtonAction:(id)sender {
    //校验格式
    if (![self validateTextLength]) return;

    if (self.saveBlock)
    {
        NSString *introString = [self.introTextView.text trimmingWhitespaceAndNewline];

        self.saveBlock(introString);
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validateTextLength
{
    NSString *introString = [self.introTextView.text trimmingWhitespaceAndNewline];

    if (introString.length >= 10 && introString.length <= 140)
    {
        return YES;
    }

    if (introString.length < 10)
    {
        [self showErrorMessage:@"直播简介长度不少于10"];
    }

    if (introString.length > 140)
    {
        [self showErrorMessage:@"直播简介长度不大于140"];
    }

    return NO;
}


@end
