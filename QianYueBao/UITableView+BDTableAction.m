//
//  UITableView+BDTableAction.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "UITableView+BDTableAction.h"

@implementation UITableView (BDTableAction)

+ (UITableView *)createTableview:(UITableViewStyle)style fatherView:(id)vc
{
    UITableView *tableview =[[UITableView alloc]initWithFrame:CGRectZero style:style];
    tableview.dataSource = vc;
    tableview.delegate = vc;
    tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.estimatedRowHeight = 0;
    if ([vc isKindOfClass:[UIViewController class]])
    {
        UIViewController *mVc = (UIViewController *)vc;
        [mVc.view addSubview:tableview];
    }
    else
    {
        [vc addSubview:tableview];
    }
    return tableview;
}

+ (UITableView *)createLineTableView:(UITableViewStyle)style fatherView:(id)vc
{
    UITableView *tableview =[[UITableView alloc]initWithFrame:CGRectZero style:style];
    tableview.dataSource = vc;
    tableview.delegate = vc;
    tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    tableview.emptyDataSetSource = vc;
    tableview.emptyDataSetDelegate = vc;
    tableview.estimatedRowHeight = 0;
    if ([vc isKindOfClass:[UIViewController class]])
    {
        UIViewController *mVc = (UIViewController *)vc;
        [mVc.view addSubview:tableview];
    }
    else
    {
        [vc addSubview:tableview];
    }
    return tableview;
}

- (void)registerCell:(Class)className
{
    [self registerClass:[className class] forCellReuseIdentifier:NSStringFromClass(className)];
}

- (void)reloadIndex:(NSInteger)section row:(NSInteger)row
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:section];
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 设置刷新和加载
- (void)setTableviewFootAction:(SEL)action target:(id)target
{
    if (self.mj_footer == nil)
    {
        MJRefreshAutoFooter *footer=[MJRefreshAutoFooter footerWithRefreshingTarget:target refreshingAction:action];
        self.mj_footer = footer;
    }
}

- (void)setTableviewHeardAction:(SEL)action target:(id)target
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    NSMutableArray *idleImages=[[NSMutableArray alloc]init];
    NSMutableArray *pullingImages=[[NSMutableArray alloc]init];
    NSMutableArray *refreshingImages=[[NSMutableArray alloc]init];
    for (int i=0; i<8; i++) {
        [idleImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh%d",8]]];
        [pullingImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh%d",1]]];
        [refreshingImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refresh%d",i+1]]];
        
    }
    [header setTitle:LS(@"Pull to refresh...") forState:MJRefreshStateIdle];
    [header setTitle:LS(@"Release to refresh...") forState:MJRefreshStatePulling];
    [header setTitle:LS(@"Loading...") forState:MJRefreshStateRefreshing];
    
    // 设置普通状态的动画图片
    [header setImages:idleImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    // 设置header
    self.mj_header = header;
}


@end
