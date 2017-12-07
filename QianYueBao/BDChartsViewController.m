//
//  BDChartsViewController.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDChartsViewController.h"

@interface BDChartsViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) NSArray *modelArray;

@property (nonatomic, assign) BOOL isRequestFail;

@end

@implementation BDChartsViewController
@synthesize tableview;
@synthesize isRequestFail;
@synthesize modelArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    [self loadData];
}

- (void)setUpUI
{
    [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Normal title:LS(@"Merchant_Trade_Charts") didBackAction:nil];
    [BDChartHeardView createHeardView:self.view];
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    tableview.emptyDataSetDelegate = self;
    tableview.emptyDataSetSource = self;
    [tableview setTableviewHeardAction:@selector(loadData) target:self];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(HScale*60+64);
    }];
}

- (void)loadData
{
    [BDStyle showLoading:@"" rootView:self.view];
    [BDTranctionViewModel getTransRankHandler:^(NSString *status, NSArray *dataArray) {
        [tableview.mj_header endRefreshing];
        if ([status isEqualToString:REQUEST_SUCCESS])
        {
            isRequestFail = NO;
        }
        else
        {
            isRequestFail = YES;
        }
        modelArray = dataArray;
        [tableview reloadData];
        [BDStyle handlerDataError:status currentVC:self handler:^{
            [self loadData];
        }];
    }];
}

#pragma mark -tableview datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HScale*60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDChartTableViewCell *cell = [BDChartTableViewCell createTableCell:tableview];
    [cell bindData:indexPath.row modle:modelArray[indexPath.row]];
    return cell;
}

#pragma mark -EmptyDataSet delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"no_data";
    if (isRequestFail)
    {
        imageName = @"no_internet";
    }
    UIImage *noData =[UIImage imageNamed:imageName];
    noData = [noData imageByScalingToSize:CGSizeMake(WScale*150,75.0/90.0*WScale*150)];
    return noData;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (isRequestFail)
    {
        [self loadData];
    }
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
