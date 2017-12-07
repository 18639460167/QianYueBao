//
//  BDOrderDeatilViewController.m
//  QianYueBao
//
//  Created by Black on 17/5/22.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDOrderDeatilViewController.h"

@interface BDOrderDeatilViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, assign) BOOL isRequestFail;

@end

@implementation BDOrderDeatilViewController
@synthesize tableview;
@synthesize transModel;
@synthesize isRequestFail;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self loadData];
}

- (void)setUpUI
{
    isRequestFail = YES;
    [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Normal title:LS(@"Transaction_Details") didBackAction:nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];

    tableview =[UITableView createLineTableView:UITableViewStyleGrouped fatherView:self];
    tableview.backgroundColor = CLEAR_COLOR;
    [tableview setTableviewHeardAction:@selector(loadData) target:self];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
    }];
}

- (void)loadData
{
    [BDStyle showLoading:@"" rootView:self.view];
    [BDTranctionViewModel getTransDetail:transModel.trans_id handle:^(NSString *status, BDTransactionModel *model) {
        [tableview.mj_header endRefreshing];
        if ([status isEqualToString:REQUEST_SUCCESS])
        {
            isRequestFail = NO;
            model.shopName = transModel.shopName;
            transModel = model;
        }
        else
        {
            isRequestFail = YES;
        }
        [tableview reloadData];
        [BDStyle handlerDataError:status currentVC:self handler:^{
            [self loadData];
        }];
    }];
}

#pragma mark - tableview datasource delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isRequestFail)
    {
        return 0;
    }
    return [transModel transTitleArray].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [transModel transTitleArray][section];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HScale*50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HScale*10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =[BDStyle createView:[UIColor colorWithHexString:@"#f6f6f6"]];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, HScale*10);
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2)
    {
        BDOrderStatusTableViewCell *cell = [BDOrderStatusTableViewCell createTableCell:tableView];
        [cell bindData:transModel.finsh_status];
        return cell;
    }
    BDOrderDetailTableViewCell *cell = [BDOrderDetailTableViewCell createTableCell:tableView];
    if (indexPath.section==0 && (indexPath.row == 0 || indexPath.row == 1))
    {
        cell.messageLbl.font = FONTSIZE(18);
    }
    [cell bindData:[transModel transTitleArray][indexPath.section][indexPath.row] message:[transModel transMessageArray][indexPath.section][indexPath.row]];
    return cell;
}

#pragma mark -EmptyDataSet delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"no_internet";
    UIImage *noData =[UIImage imageNamed:imageName];
    noData = [noData imageByScalingToSize:CGSizeMake(WScale*150,75.0/90.0*WScale*150)];
    return noData;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
