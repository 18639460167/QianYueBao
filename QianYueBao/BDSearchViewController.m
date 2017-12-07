//
//  BDSearchViewController.m
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSearchViewController.h"
#import "BDSearchView.h"

@interface BDSearchViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) BDSearchView *searchView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) BDSearchShopViewModel *model;

@end

@implementation BDSearchViewController
@synthesize tableview;
@synthesize searchView;
@synthesize model;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self loadData];
}

- (void)setUpUI
{
    self.view.backgroundColor = WHITE_COLOR;
    searchView = [BDSearchView createSearchView:self];
    HYWeakSelf;
    searchView.handler = ^(){
        HYStrongSelf;
        [sSelf loadData];
    };
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    [tableview setTableviewHeardAction:@selector(loadData) target:self];
    [tableview setTableviewFootAction:@selector(loadMore) target:self];
    tableview.emptyDataSetSource = self;
    tableview.emptyDataSetDelegate = self;
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(searchView.mas_bottom).offset(HScale*5);
    }];
}

- (void)loadData
{
    model = [[BDSearchShopViewModel alloc]init];
    [BDStyle showLoading:@"" rootView:self.view];
    HYWeakSelf;
    [model loadNewSignList:searchView.messageText.text handler:^(id value) {
        HYStrongSelf;
        [tableview.mj_header endRefreshing];
        sSelf.dataArray = model.signListArray;
        [tableview reloadData];
        [BDStyle handlerDataError:value currentVC:sSelf handler:^{
            [sSelf loadData];
        }];
    }];
}
- (void)loadMore
{
    HYWeakSelf;
    [BDStyle showLoading:@"" rootView:self.view];
    [model loadMoreSignList:^(id value) {
        HYStrongSelf;
        [tableview.mj_footer endRefreshing];
        if ([value isEqualToString:REQUEST_SUCCESS])
        {
            sSelf.dataArray = model.signListArray;
            [tableview reloadData];
        }
        [BDStyle handlerDataError:value currentVC:self handler:^{
            [sSelf loadData];
        }];
    }];

}

#pragma mark -tableview datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HScale*64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDTradeTableViewCell *cell = [BDTradeTableViewCell createTableCell:tableview];
    cell.signModel = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDTradeTableViewCell *cell = (BDTradeTableViewCell *)[tableview cellForRowAtIndexPath:indexPath];
    [cell cellAction:self];
}

#pragma mark -EmptyDataSet delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"no_data";
    if (model.isRequestFail)
    {
        imageName = @"no_internet";
    }
    UIImage *noData =[UIImage imageNamed:imageName];
    noData = [noData imageByScalingToSize:CGSizeMake(WScale*150,75.0/90.0*WScale*150)];
    return noData;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (model.isRequestFail)
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
