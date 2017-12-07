//
//  BDWithdrawDetailViewController.m
//  QianYueBao
//
//  Created by Black on 17/5/19.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDWithdrawDetailViewController.h"

@interface BDWithdrawDetailViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, assign) BOOL isRequest;

@property (nonatomic, strong) NSArray *modelArray;

@end

@implementation BDWithdrawDetailViewController
@synthesize tableview;
@synthesize modelArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self loadData];
}

- (void)setUpUI
{
    [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Normal title:LS(@"Liquidation_Record") didBackAction:nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    
    self.tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    self.tableview.emptyDataSetDelegate = self;
    self.tableview.emptyDataSetSource = self;
    [tableview setTableviewHeardAction:@selector(loadData) target:self];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
    }];
    
}

- (void)loadData
{
    [BDStyle showLoading:@"" rootView:self.view];
    [BDSettleMentViewModel getSettleDeatil:self.setModel.settlement_id handler:^(NSString *status, NSArray *dataArray) {
        [tableview.mj_header endRefreshing];
        if ([status isEqualToString:REQUEST_SUCCESS])
        {
            self.isRequest = NO;
        }
        else
        {
            self.isRequest = YES;
        }
        modelArray = dataArray;
        [tableview reloadData];
        [BDStyle handlerDataError:status currentVC:self handler:^{
            [self loadData];
        }];
    }];
}

#pragma mark - tableview datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HScale*72;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDOrderTableViewCell *cell = [BDOrderTableViewCell createTableCell:tableview];
    [cell binData:modelArray[indexPath.row] title:self.title];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDOrderTableViewCell *cell = (BDOrderTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell cellAction:self title:self.title];
}

#pragma mark -EmptyDataSet delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"no_data";
    if (self.isRequest)
    {
        imageName = @"no_internet";
    }
    UIImage *noData =[UIImage imageNamed:imageName];
    noData = [noData imageByScalingToSize:CGSizeMake(WScale*150,75.0/90.0*WScale*150)];
    return noData;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (self.isRequest)
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
