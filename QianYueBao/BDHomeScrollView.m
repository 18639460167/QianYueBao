//
//  BDHomeScrollView.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDHomeScrollView.h"

@interface BDHomeScrollView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIViewController *currentVC;
@end

@implementation BDHomeScrollView
@synthesize scrollview;
@synthesize lineView;
@synthesize selectBtn;
@synthesize currentVC;

+ (instancetype)crateView:(UIViewController *)vc
{
    BDHomeScrollView *scrollView = [[BDHomeScrollView alloc]initWithFrame:CGRectZero crateView:vc];
    [vc.view addSubview:scrollView];
    return scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame crateView:(id)vc
{
    if (self = [super initWithFrame:frame])
    {
        currentVC = vc;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollChange:) name:Home_ScrollChange object:nil];
        self.currentIndex = 1;
        self.backgroundColor = CLEAR_COLOR;
        
        NSArray *array = @[LS(@"Has_Been_Signed"),LS(@"Under_Review"),LS(@"Wait_Submit")];
        float width = SCREEN_WIDTH/3;
        for (int i=0; i<array.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(width*i, HScale*25, width, HScale*18);
            [button setTitle:array[i] forState:0];
            button.titleLabel.font = FONTSIZE(15);
            [button setTitleColor:[UIColor nineSixColor] forState:0];
            [button setTitleColor:[UIColor navigationColor] forState:UIControlStateSelected];
            button.tag = i+1;
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if (selectBtn==button)
                {
                    return;
                }
                else
                {
                    selectBtn.selected=NO;
                    selectBtn=button;
                    button.selected=YES;
                    [UIView animateWithDuration:0.3 animations:^{
                        lineView.center=CGPointMake(button.center.x, button.center.y+HScale*13);
                        scrollview.contentOffset=CGPointMake(SCREEN_WIDTH*i, 0);
                    }completion:^(BOOL finished) {
                        self.currentIndex = selectBtn.tag;
                        if (self.complete)
                        {
                            self.complete();
                        }
                    }];
                }
            }];
            if (i==0)
            {
                button.selected = YES;
                selectBtn = button;
            }
            [self addSubview:button];
        }
        lineView = [BDStyle createView:[UIColor navigationColor]];
        lineView.frame = CGRectMake(WScale*7.5, CGRectGetMaxY(selectBtn.frame)+HScale*3.5, width-WScale*20, 1.5);
        [self addSubview:lineView];
        scrollview=[[UIScrollView alloc]initWithFrame:CGRectZero];
        scrollview.bounces=NO;
        scrollview.pagingEnabled=YES;
        scrollview.delegate=self;
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.contentSize=CGSizeMake(SCREEN_WIDTH*3, 0);
        [self addSubview:scrollview];
        [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(lineView.mas_bottom).offset(HScale*10);
        }];
       
        for (int i=0; i<array.count; i++)
        {
            CGFloat heigth = (SCREEN_HEIGHT-HScale*230-69);
            heigth = heigth-(CGRectGetMaxY(lineView.frame))-HScale*10;
            UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, heigth) style:UITableViewStylePlain];
            tableview.tag = 100+i;
            tableview.dataSource = vc;
            tableview.delegate  =vc;
            tableview.backgroundColor = [UIColor clearColor];
            tableview.tableFooterView = [UIView new];
            tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableview setTableviewFootAction:@selector(loadMore) target:self];
            [tableview setTableviewHeardAction:@selector(loadData) target:self];
            tableview.emptyDataSetDelegate = vc;
            tableview.emptyDataSetSource = vc;
            [scrollview addSubview:tableview];
        }

    }
    return self;
}

- (void)loadData
{
    if (self.complete)
    {
        self.complete();
    }
}
- (void)loadMore
{
    if (self.checkLoadMore)
    {
        self.checkLoadMore();
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == scrollview)
    {
        float value = 1/3.0;
        lineView.frame=CGRectMake(WScale*7.5+(scrollview.contentOffset.x*value),HScale*46.5, SCREEN_WIDTH/3-WScale*20, 1.5);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==scrollview)
    {
        int tag = scrollView.contentOffset.x/SCREEN_WIDTH;
        if (tag+1 == selectBtn.tag)
        {
            return;
        }
        UIButton *button=(UIButton *)[self  viewWithTag:tag+1];
        selectBtn.selected=NO;
        selectBtn = button;
        button.selected=YES;
        self.currentIndex = selectBtn.tag;
        if (self.complete)
        {
            self.complete();
        }
    }
    
}

- (void)scrollChange:(NSNotification*)notification
{
    if (currentVC.tabBarController.selectedIndex != 0)
    {
        currentVC.tabBarController.selectedIndex = 0;
        [((UINavigationController*)currentVC.tabBarController.selectedViewController) popToRootViewControllerAnimated:YES];
    }
    NSDictionary *dic = [notification userInfo];
    NSString *str = [NSString trimNSNullASDefault:[dic objectForKey:@"index"] andDefault:@"-1"];
    if ([str isEqualToString:@"-1"])
    {
        return;
    }
    NSInteger index = [str integerValue];
    self.currentIndex = index;
    if (selectBtn.tag == index)
    {
        if (self.complete)
        {
            self.complete();
        }
        return;
    }
    UIButton *button = (UIButton *)[self viewWithTag:index];
    selectBtn.selected = NO;
    button.selected = YES;
    selectBtn = button;
    [UIView animateWithDuration:0.3 animations:^{
        lineView.center=CGPointMake(selectBtn.center.x, selectBtn.center.y+HScale*13);
        scrollview.contentOffset=CGPointMake(SCREEN_WIDTH*(selectBtn.tag-1), 0);
    }completion:^(BOOL finished) {
        self.currentIndex = selectBtn.tag;
        if (self.complete)
        {
            self.complete();
        }
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
