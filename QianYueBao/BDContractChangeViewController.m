//
//  BDContractChangeViewController.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDContractChangeViewController.h"

@interface BDContractChangeViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) BDContractViewModel *viewModel;

@end

@implementation BDContractChangeViewController
@synthesize tableview;
@synthesize modelArray;
@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
   // [self loadData];
}

- (void)setUpUI
{
    viewModel = [[BDContractViewModel alloc]init];
    // 合同变更
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    [tableview setTableviewHeardAction:@selector(loadData) target:self];
    [tableview setTableviewFootAction:@selector(loadMore) target:self];
    tableview.emptyDataSetDelegate = self;
    tableview.emptyDataSetSource = self;
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

- (void)loadData
{
    [BDStyle showLoading:@"" rootView:self.finishVC.view];
    [viewModel loadNewListWithMid:self.finishVC.signModel.sign_mid handler:^(id value) {
        [tableview.mj_header endRefreshing];
        modelArray = viewModel.contractArray;
        [tableview reloadData];
        [BDStyle handlerDataError:value currentVC:self.finishVC handler:^{
            [self loadData];
        }];
    }];
}

- (void)loadMore
{
    HYWeakSelf;
    [BDStyle showLoading:@"" rootView:self.finishVC.view];
    [viewModel loadMore:^(id value) {
        HYStrongSelf;
        [tableview.mj_footer endRefreshing];
        if ([value isEqualToString:REQUEST_SUCCESS])
        {
            modelArray = viewModel.contractArray;
            [tableview reloadData];
        }
        [BDStyle handlerDataError:value currentVC:self.finishVC handler:^{
            [sSelf loadData];
        }];
    }];}


#pragma mark -tableview datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HScale*59;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDContractChangeTableViewCell *cell = [BDContractChangeTableViewCell createTableCell:tableview];
    cell.contractModel = modelArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDContractChangeTableViewCell *cell = (BDContractChangeTableViewCell *)[tableview cellForRowAtIndexPath:indexPath];
    [cell cellAction:self.finishVC];
}

#pragma mark -EmptyDataSet delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"no_data";
    if (viewModel.isRequestFial)
    {
        imageName = @"no_internet";
    }
    UIImage *noData =[UIImage imageNamed:imageName];
    noData = [noData imageByScalingToSize:CGSizeMake(WScale*150,75.0/90.0*WScale*150)];
    return noData;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (viewModel.isRequestFial)
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
