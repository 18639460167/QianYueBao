//
//  BDTransActionFlowViewController.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDTransActionFlowViewController.h"

@interface BDTransActionFlowViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) BDTranctionViewModel *viewModel;

@end

@implementation BDTransActionFlowViewController
@synthesize tableview;
@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

- (void)setUpUI
{
    viewModel = [[BDTranctionViewModel alloc]init];
    // 交易流水
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    [tableview setTableviewFootAction:@selector(loadMore) target:self];
    [tableview setTableviewHeardAction:@selector(loadData) target:self];
    tableview.emptyDataSetSource = self;
    tableview.emptyDataSetDelegate = self;
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

- (void)loadData
{
    HYWeakSelf;
    [BDStyle showLoading:@"" rootView:self.finishVC.view];
    [viewModel loadNewListWithMid:self.finishVC.signModel.sign_mid handler:^(id value) {
        HYStrongSelf;
        [tableview.mj_header endRefreshing];
        [tableview reloadData];
        [BDStyle handlerDataError:value currentVC:sSelf.finishVC handler:^{
            [sSelf loadData];
        }];
    }];
    
}

- (void)loadMore
{
    [BDStyle showLoading:@"" rootView:self.finishVC.view];
    [viewModel loadMore:^(id value) {
        [tableview.mj_footer endRefreshing];
        if ([value isEqualToString:REQUEST_SUCCESS])
        {
            [tableview reloadData];
        }
        [BDStyle handlerDataError:value currentVC:self.finishVC handler:^{
            [self loadData];
        }];
    }];

}

#pragma mark -tableview datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return viewModel.tramsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HScale*72;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDOrderTableViewCell *cell = [BDOrderTableViewCell createTableCell:tableview];
    [cell binData:viewModel.tramsArray[indexPath.row] title:self.finishVC.signModel.title];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDOrderTableViewCell *cell = (BDOrderTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell cellAction:self.finishVC title:self.finishVC.signModel.title];
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
