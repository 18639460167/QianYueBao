//
//  BDHomeViewController.m
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDHomeViewController.h"

@interface BDHomeViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) NSMutableArray *finishArray;
@property (nonatomic, strong) NSMutableArray *progressArray;
@property (nonatomic, strong) NSMutableArray *failArray;

@property (nonatomic, strong) BDHomeDataView *homeDataView;
@property (nonatomic, strong) BDHomeScrollView *bottomView;

@property (nonatomic, strong) BDHomeViewModel *finishModel;
@property (nonatomic, strong) BDHomeViewModel *progressModel;
@property (nonatomic, strong) BDHomeViewModel *failModel;

@end

@implementation BDHomeViewController
@synthesize homeDataView;
@synthesize bottomView;
@synthesize finishArray;
@synthesize progressArray;
@synthesize failArray;
@synthesize finishModel;
@synthesize progressModel;
@synthesize failModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self loadData];
}

- (void)setUpUI
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginchange) name:Notification_orderChange object:nil];
    
    finishModel = [[BDHomeViewModel alloc]init];
    finishModel.tradeStatus = TradeStatus_Finish;
    progressModel = [[BDHomeViewModel alloc]init];
    progressModel.tradeStatus = TradeStatus_Process;
    failModel = [[BDHomeViewModel alloc]init];
    failModel.tradeStatus = TradeStatus_Fail;
    
    homeDataView =  [BDHomeDataView createView:self];
    
    bottomView = [BDHomeScrollView crateView:self];
    HYWeakSelf;
    bottomView.complete = ^(){
        HYStrongSelf;
        [sSelf loadData];
    };
    bottomView.checkLoadMore = ^(){
        HYStrongSelf;
        [sSelf loadMore];
    };
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(homeDataView.mas_bottom);
    }];
}
- (void)loginchange
{
    finishModel = [[BDHomeViewModel alloc]init];
    finishModel.tradeStatus = TradeStatus_Finish;
    progressModel = [[BDHomeViewModel alloc]init];
    progressModel.tradeStatus = TradeStatus_Process;
    failModel = [[BDHomeViewModel alloc]init];
    failModel.tradeStatus = TradeStatus_Fail;
    
    [finishArray removeAllObjects];
    [progressArray removeAllObjects];
    [failArray removeAllObjects];
    
    [homeDataView bindData:finishModel.total_count weekSale:finishModel.week_sale sign:finishModel.currency_sign];
    for (int i=0; i<3; i++)
    {
        UITableView *tableview = (UITableView *)[bottomView.scrollview viewWithTag:i+100];
        [tableview reloadData];
    }
}
- (void)loadData
{
    UITableView *tableview = (UITableView*)[bottomView.scrollview viewWithTag:bottomView.currentIndex+99];
    HYWeakSelf;
    [BDStyle showLoading:@"" rootView:self.view];
    switch (bottomView.currentIndex)
    {
        case 1:
        {
            [finishModel loadNewSignList:^(id value) {
                HYStrongSelf;
                [tableview.mj_header endRefreshing];
                [sSelf.homeDataView bindData:sSelf.finishModel.total_count weekSale:sSelf.finishModel.week_sale sign:sSelf.finishModel.currency_sign];
                sSelf.finishArray = sSelf.finishModel.signListArray;
                [tableview reloadData];
                [BDStyle handlerDataError:value currentVC:self handler:^{
                    [sSelf loadData];
                }];
            }];
        }
            break;
        case 2:
        {
            [progressModel loadNewSignList:^(id value) {
                HYStrongSelf;
                [tableview.mj_header endRefreshing];
                sSelf.progressArray = sSelf.progressModel.signListArray;
                [tableview reloadData];
                [BDStyle handlerDataError:value currentVC:self handler:^{
                    [sSelf loadData];
                }];
            }];
        }
            break;
        case 3:
        {
            [failModel loadNewSignList:^(id value) {
                HYStrongSelf;
                [tableview.mj_header endRefreshing];
                sSelf.failArray = sSelf.failModel.signListArray;
                [failModel loadFmdbDataWithArray:sSelf.failArray];
                [tableview reloadData];
                [BDStyle handlerDataError:value currentVC:self handler:^{
                    [sSelf loadData];
                }];
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)loadMore
{
    HYWeakSelf;
    UITableView *tableview = (UITableView*)[bottomView.scrollview viewWithTag:bottomView.currentIndex+99];
    switch (bottomView.currentIndex)
    {
        case 1:
        {
            [BDStyle showLoading:@"" rootView:self.view];
            [finishModel loadMoreSignList:^(id value) {
                HYStrongSelf;
                [tableview.mj_footer endRefreshing];
                if ([value isEqualToString:REQUEST_SUCCESS])
                {
                    finishArray = finishModel.signListArray;
                    [tableview reloadData];
                }
                [BDStyle handlerDataError:value currentVC:self handler:^{
                    [sSelf loadData];
                }];
            }];
        }
            break;
        case 2:
        {
            [BDStyle showLoading:@"" rootView:self.view];
            [progressModel loadMoreSignList:^(id value) {
                HYStrongSelf;
                [tableview.mj_footer endRefreshing];
                if ([value isEqualToString:REQUEST_SUCCESS])
                {
                    progressArray = progressModel.signListArray;
                    [tableview reloadData];
                }
                [BDStyle handlerDataError:value currentVC:self handler:^{
                    [sSelf loadData];
                }];
            }];        }
            break;
        case 3:
        {
            [BDStyle showLoading:@"" rootView:self.view];
            [failModel loadMoreSignList:^(id value) {
                HYStrongSelf;
                [tableview.mj_footer endRefreshing];
                if ([value isEqualToString:REQUEST_SUCCESS])
                {
                    failArray = failModel.signListArray;
                    [failModel loadFmdbDataWithArray:failArray];
                    [tableview reloadData];
                }
                [BDStyle handlerDataError:value currentVC:self handler:^{
                    [sSelf loadData];
                }];
            }];        }
            break;
        default:
            break;
    }
}
#pragma mark -tableview datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag)
    {
        case 100:
        {
            return finishArray.count;
        }
            break;
        case 101:
        {
            return progressArray.count;
        }
            break;
        case 102:
        {
            return failArray.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HScale*64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDTradeTableViewCell *cell = [BDTradeTableViewCell createTableCell:tableView];
    BDSignListModel *model = [[BDSignListModel alloc]init];
    switch (tableView.tag)
    {
        case 100:
        {
            model = finishArray[indexPath.row];
        }
            break;
        case 101:
        {
            model = progressArray[indexPath.row];
        }
            
            break;
        case 102:
        {
            model = failArray[indexPath.row];
        }
            
            break;
            
        default:
            break;
    }
    cell.signModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDTradeTableViewCell *cell = (BDTradeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell cellAction:self];
}

#pragma mark - EmptyDataSet delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    switch (scrollView.tag)
    {
        case 100:
        {
            NSString *imageName = @"no_data";
            if (finishModel.RequestFail)
            {
                imageName = @"no_internet";
            }
            UIImage *noData =[UIImage imageNamed:imageName];
            noData = [noData imageByScalingToSize:CGSizeMake(WScale*120,75.0/90.0*WScale*120)];
            return noData;
        }
            break;
        case 101:
        {
            NSString *imageName = @"no_data";
            if (progressModel.RequestFail)
            {
                imageName = @"no_internet";
            }
            UIImage *noData =[UIImage imageNamed:imageName];
            noData = [noData imageByScalingToSize:CGSizeMake(WScale*120,75.0/90.0*WScale*120)];
            return noData;
        }
            break;
        case 102:
        {
            NSString *imageName = @"no_data";
            if (failModel.RequestFail)
            {
                imageName = @"no_internet";
            }
            UIImage *noData =[UIImage imageNamed:imageName];
            noData = [noData imageByScalingToSize:CGSizeMake(WScale*120,75.0/90.0*WScale*120)];
            return noData;
        }
            break;
        
        default:
            break;
    }
    return nil;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    switch (scrollView.tag)
    {
        case 100:
        {
            if (finishModel.RequestFail)
            {
                [self loadData];
            }
        }
            break;
        case 101:
        {
            if (progressModel.RequestFail)
            {
                [self loadData];
            }
        }
            break;
        case 102:
        {
            if (failModel.RequestFail)
            {
                [self loadData];
            }
        }
            break;
            
        default:
            break;
    }
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
