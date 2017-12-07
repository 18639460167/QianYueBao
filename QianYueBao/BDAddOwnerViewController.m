//
//  BDAddOwnerViewController.m
//  QianYueBao
//
//  Created by Black on 17/5/4.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDAddOwnerViewController.h"
#import "BDOwnerTitleView.h"

@interface BDAddOwnerViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>


@property (nonatomic, strong) NSArray *modelArray;

@property (nonatomic, strong) BDOwnerViewModel *viewModel;

@end

@implementation BDAddOwnerViewController
@synthesize tableview;
@synthesize modelArray;
@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self loadNewData];
}

- (void)setUpUI
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    modelArray = [NSArray new];
    viewModel = [[BDOwnerViewModel alloc]init];
    [BDOwnerSearchView createSearchView:self handler:^(id value) {
        viewModel.keyWord = value;
        [self loadNewData];
    }];
    
    BDOwnerTitleView *titleView = [BDOwnerTitleView createView:self.view];
    
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    tableview.emptyDataSetDelegate = self;
    tableview.emptyDataSetSource = self;
    [tableview setTableviewFootAction:@selector(loadMore) target:self];
    [tableview setTableviewHeardAction:@selector(loadNewData) target:self];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(titleView.mas_bottom);
    }];
}

- (void)loadNewData
{
    [BDStyle showLoading:@"" rootView:self.view];
    HYWeakSelf;
    [viewModel loadNewOwnerListKey:viewModel.keyWord handler:^(id value) {
        HYStrongSelf;
        [tableview.mj_header endRefreshing];
        sSelf.modelArray = viewModel.ownerListArray;
        [sSelf.tableview reloadData];
        [BDStyle handlerDataError:value currentVC:self handler:^{
            [sSelf loadNewData];
        }];
    }];
}
- (void)loadMore
{
    HYWeakSelf;
    [BDStyle showLoading:@"" rootView:self.view];
    [viewModel loadMoreOwnerList:^(id value) {
        HYStrongSelf;
        [sSelf.tableview.mj_footer endRefreshing];
        if ([value isEqualToString:REQUEST_SUCCESS])
        {
            sSelf.modelArray = viewModel.ownerListArray;
            [tableview reloadData];
        }
        [BDStyle handlerDataError:value currentVC:self handler:^{
            [sSelf loadNewData];
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
    return HScale*70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDSearchOwnerTableViewCell *cell = [BDSearchOwnerTableViewCell createTableCell:tableview];
    cell.ownerModel = modelArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDSearchOwnerTableViewCell *cell = (BDSearchOwnerTableViewCell *)[tableview cellForRowAtIndexPath:indexPath];
    [cell cellAction:self];
}

#pragma mark -EmptyDataSet delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"no_data";
    if (viewModel.isRequestFail)
    {
        imageName = @"no_internet";
    }
    UIImage *noData =[UIImage imageNamed:imageName];
    noData = [noData imageByScalingToSize:CGSizeMake(WScale*150,75.0/90.0*WScale*150)];
    return noData;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (viewModel.isRequestFail)
    {
        [self loadNewData];
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
