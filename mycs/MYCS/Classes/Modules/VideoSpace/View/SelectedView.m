//
//  SelectedView.m
//  MYCS
//
//  Created by AdminZhiHua on 16/2/1.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SelectedView.h"
#import "SopDetail.h"
#import "CourseDetail.h"
#import "CoursePackModel.h"

#define tableViewWidth (0.65 * ScreenH)
static NSString *const reuseId = @"SelectedViewCell";

@interface SelectedView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewWithConstraint;

@property (nonatomic,strong) SopDetail *sopDetail;
@property (nonatomic,strong) CourseDetail *courseDetail;
@property (nonatomic,strong) ChapterModel *chapster;

//课程视频数组
@property (nonatomic,strong) NSArray * coursePackArray;

@end

@implementation SelectedView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self.tableView registerClass:[SelectedViewCell class] forCellReuseIdentifier:reuseId];
    self.tableViewWithConstraint.constant = tableViewWidth;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableViewWidth, 20)];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.alpha = 0.7;
    
    self.tableView.transform = CGAffineTransformTranslate(self.tableView.transform, tableViewWidth, 0);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tableView.transform = CGAffineTransformIdentity;
        
    }];
    
    [self showAndFade];
}
-(void)setSOPDetail:(SopDetail *)sopDetail CourseDeatil:(CourseDetail *)courseDetail chapter:(ChapterModel *)chapter coursePackArray:(NSArray *)coursePackArray
{
    self.sopDetail = sopDetail;
    self.courseDetail = courseDetail;
    self.chapster = chapter;
    self.coursePackArray = coursePackArray;
    [self findSelectChapter];
}
- (void)cancelDelayedHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissWithBlock:) object:nil];
    [self showAndFade];
}

- (void)showAndFade {
    
    [self performSelector:@selector(dismissWithBlock:) withObject:nil afterDelay:10];
    
}

+(instancetype)showInView:(UIView *)superView and:(void (^)())block
{
    SelectedView *selectedView = [[[NSBundle mainBundle] loadNibNamed:@"MediaControl" owner:nil options:nil] lastObject];
    selectedView.block = block;
    selectedView.frame = superView.bounds;
    [superView addSubview:selectedView];
    
    return selectedView;
}

-(void)findSelectChapter
{
    
    if (self.sopDetail)
    {
        for (SopCourseModel *sopCourse in self.sopDetail.sopCourse)
        {
            for (ChapterModel * obj in sopCourse.chapters)
            {
                if ([obj isEqual:self.chapster])
                {
                    sopCourse.isOpen = YES;
                    break;
                }else
                {
                    sopCourse.isOpen = NO;
                }
            }
        }
    }
    else if(self.courseDetail)
    {
        for (ChapterModel *obj in self.courseDetail.chapters)
        {
            if ([obj isEqual:self.chapster])
            {
                self.courseDetail.isSelect = @"1";
                break;
            }else
            {
                self.courseDetail.isSelect = @"0";
            }
        }
    }
    else if (self.coursePackArray)
    {
        for (CoursePackModel * model in self.coursePackArray)
        {
            for (CoursePackChapter *obj in model.coursePackChapters)
            {
                if (obj.isSelect.integerValue == 1)
                {
                    model.isSelect = @"1";
                    break;
                }else
                {
                    model.isSelect = @"0";
                }
            }
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.courseDetail)
    {
        return 1;
    }
    else if (self.coursePackArray.count > 0)
    {
        return self.coursePackArray.count;
    }
    
    return self.sopDetail.sopCourse.count;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissWithBlock:nil];
    
}
- (void)dismissWithBlock:(void (^)())block {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tableView.transform = CGAffineTransformMakeTranslation(200, 0);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.block)
        {
            self.block();
        }
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.courseDetail)
    {
        if (self.courseDetail.isSelect.integerValue == 1)
        {
            return self.courseDetail.chapters.count;
        }
        return 0;
    }
    else if (self.coursePackArray.count > 0)
    {
        
        CoursePackModel * model = self.coursePackArray[section];
        if (model.isSelect.integerValue == 1)
        {
            return model.coursePackChapters.count;
        }
        return 0;
    }
    else
    {
        SopCourseModel *sopCourse = self.sopDetail.sopCourse[section];
        if (sopCourse.isOpen)
        {
            return sopCourse.chapters.count;
        }
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    //不让选集点击
    //    cell.userInteractionEnabled = NO;
    
    if (self.coursePackArray.count > 0)
    {
        
        CoursePackModel * packModel = self.coursePackArray[indexPath.section];
        CoursePackChapter * model = packModel.coursePackChapters[indexPath.row];
        
        [cell setCoursePackChapter: model andIndex:indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        cell.buttonCoursePackChapterBlock = ^(CoursePackChapter *model) {
            
            if (weakSelf.cellCoursePackChapterBlock)
            {
                weakSelf.cellCoursePackChapterBlock(model);
            }
            
            [self cancelCourseSelect];
            
            model.isSelect = @"1";
            
            [weakSelf dismissWithBlock:nil];
        };
        
        if (model.isSelect.integerValue == 1)
        {
            [cell setButtonSelected:YES];
        }
        else
        {
            [cell setButtonSelected:NO];
        }
        
        return cell;
    }
    else
    {
        
        ChapterModel *chapter;
        if (self.sopDetail)
        {
            SopCourseModel *course = self.sopDetail.sopCourse[indexPath.section];
            chapter = course.chapters[indexPath.row];
        }
        else
        {
            chapter = self.courseDetail.chapters[indexPath.row];
        }
        
        [cell setChapter:chapter andIndex:indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        cell.buttonBlock = ^(ChapterModel *chapter) {
            
            if (weakSelf.cellBlock)
            {
                weakSelf.cellBlock(chapter);
            }
            
            self.chapster = chapter;
            
            [weakSelf dismissWithBlock:nil];
        };
        
        if ([chapter isEqual:self.chapster])
        {
            [cell setButtonSelected:YES];
        }
        else
        {
            [cell setButtonSelected:NO];
        }
        
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [UIView new];
    
    headerView.backgroundColor = HEXRGB(0x262626);
    
    UILabel *titleLabel = ({
        
        UILabel *label = [UILabel new];
        [headerView addSubview:label];
        
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.font = [UIFont systemFontOfSize:14];
        
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = HEXRGB(0xaaaaaa);
        
        label;
    });
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = section;
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(0, 0, tableViewWidth, 35);
    [button setImage:[UIImage imageNamed:@"arrows_shrink"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"arrows_unfold"] forState:UIControlStateSelected];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:self action:@selector(headViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableViewWidth, 1)];
    lineView.backgroundColor = HEXRGB(0x333333);
    [headerView addSubview:lineView];
    
    if (self.courseDetail)
    {
        
        titleLabel.text = [NSString stringWithFormat:@"  第%ld章 %@",(unsigned long)section+1,self.courseDetail.name];
        button.selected = self.courseDetail.isSelect.integerValue == 1?YES:NO;
    }
    else if (self.coursePackArray.count > 0)
    {
        CoursePackModel * packModel = self.coursePackArray[section];
        button.selected = packModel.isSelect.integerValue == 1?YES:NO;
        titleLabel.text = [NSString stringWithFormat:@"  第%ld章 %@",(unsigned long)section+1,packModel.directoryName];
    }
    else
    {
        SopCourseModel *sopCourse = self.sopDetail.sopCourse[section];
        button.selected = sopCourse.isOpen;
        titleLabel.text = [NSString stringWithFormat:@"  第%ld章 %@",(unsigned long)section+1,sopCourse.courseName];
    }
    
    //添加约束
    NSString *hVFL = @"H:|-(0)-[titleLabel]-(30)-|";
    NSString *vVFL = @"V:|-(0)-[titleLabel]-(0)-|";
    
    NSArray *hConst = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)];
    NSArray *vConst = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)];
    
    [headerView addConstraints:hConst];
    [headerView addConstraints:vConst];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

-(void)headViewClick:(UIButton *)button
{
    
    [self cancelDelayedHide];
    
    button.selected = !button.selected;
    
    NSInteger tag = button.tag;
    
    if (self.courseDetail)
    {
        if (button.selected)
        {
            self.courseDetail.isSelect = @"1";
            
        }else
        {
            self.courseDetail.isSelect = @"0";
        }
    }
    else if (self.coursePackArray.count > 0)
    {
        
        CoursePackModel * model = self.coursePackArray[tag];
        if (button.selected)
        {
            model.isSelect = @"1";
            
        }else
        {
            model.isSelect = @"0";
        }
    }
    else
    {
        SopCourseModel *sopCourse = self.sopDetail.sopCourse[tag];
        sopCourse.isOpen = button.selected;
        
    }
    
    [self.tableView reloadData];
    
}

-(void)cancelCourseSelect
{
    
    for (CoursePackModel *packModel in self.coursePackArray)
    {
        for (CoursePackChapter *packChapter in packModel.coursePackChapters)
        {
            packChapter.isSelect = @"0";
        }
    }
    
}

@end


@interface SelectedViewCell ()

@property (nonatomic,strong) SelectedChapterButton *chapterBtn;

@end

@implementation SelectedViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addSubview:self.chapterBtn];
        [self addConst];
        self.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

//添加约束
- (void)addConst {
    
    UIButton *button = self.chapterBtn;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hVFL = @"H:|-(15)-[button]-(5)-|";
    NSString *vVFL = @"V:|-(2)-[button]-(2)-|";
    
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
    
    [self addConstraints:hConsts];
    [self addConstraints:vConsts];
    
}

- (void)buttonAction:(SelectedChapterButton *)button {
    
    
    if (self.coursePackChapter)
    {
        if (self.buttonCoursePackChapterBlock)
        {
            self.buttonCoursePackChapterBlock(self.coursePackChapter);
        }
    }else
    {
        if (self.buttonBlock)
        {
            self.buttonBlock(self.chapter);
        }
    }
}

- (void)setButtonSelected:(BOOL)selected {
    self.chapterBtn.selected = selected;
}

- (SelectedChapterButton *)chapterBtn {
    if (!_chapterBtn)
    {
        SelectedChapterButton *button = [SelectedChapterButton buttonWithType:UIButtonTypeCustom];
        
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        
        [button setTitleColor:HEXRGB(0xaaaaaa) forState:UIControlStateNormal];
        [button setTitleColor:HEXRGB(0x47c1a8) forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"select_play_min"] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _chapterBtn = button;
    }
    return _chapterBtn;
}

- (void)setChapter:(ChapterModel *)chapter andIndex:(NSInteger)index {
    _chapter = chapter;
    
    [self.chapterBtn setTitle:[NSString stringWithFormat:@"%ld、 %@",(unsigned long)index+1,chapter.name] forState:UIControlStateNormal];
    [self.chapterBtn setTitle:[NSString stringWithFormat:@" %@",chapter.name] forState:UIControlStateSelected];
}

-(void)setCoursePackChapter:(CoursePackChapter *)chapter andIndex:(NSInteger)index
{
    _coursePackChapter = chapter;
    
    [self.chapterBtn setTitle:[NSString stringWithFormat:@"%ld、 %@",(unsigned long)index+1,chapter.chapterName] forState:UIControlStateNormal];
    [self.chapterBtn setTitle:[NSString stringWithFormat:@" %@",chapter.chapterName] forState:UIControlStateSelected];
}

@end

@implementation SelectedChapterButton

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}

@end
