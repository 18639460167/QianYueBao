//
//  BDMoreChooseViewController.m
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDMoreChooseViewController.h"

@interface BDMoreChooseViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, strong) NSMutableArray *IDArray;

@property (nonatomic, assign) BOOL isRequestFail;

@property (nonatomic, strong) UIButton *bottombtn;

@end

@implementation BDMoreChooseViewController
@synthesize tableview;
@synthesize selectArray;
@synthesize bottombtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self loadData];
}

- (void)setUpUI
{
    if (!self.selectArray)
    {
        self.selectArray = [NSMutableArray new];
    }
    self.IDArray = [NSMutableArray new];
    
    [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Normal title:self.title didBackAction:nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    tableview.backgroundColor = CLEAR_COLOR;
    tableview.emptyDataSetSource = self;
    tableview.emptyDataSetDelegate = self;
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
    }];
}

- (void)loadData
{
    [bottombtn removeFromSuperview];
    [tableview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    switch (self.chooseStatus)
    {
        case ChooseStatus_UnKnow:
        {
            return;
        }
            break;
        case ChooseStatus_Service:
        {
            [BDStyle showLoading:@"" rootView:self.view];
            [BDCommonVieModel getMerchantService:^(NSString *status, NSMutableArray *titleArray) {
                [self setData:status titleArray:titleArray];
            }];
        }
            break;
        case ChooseStatus_Payment:
        {
            [BDStyle showLoading:@"" rootView:self.view];
            [BDCommonVieModel getMerchantPaymentCannel:^(NSString *status, NSMutableArray *titleArray) {
               [self setData:status titleArray:titleArray];
            }];
        }
            break;
        case ChooseStatus_Platform:
        {
            [BDStyle showLoading:@"" rootView:self.view];
            [BDCommonVieModel getMerchantCompplatform:^(NSString *status, NSMutableArray *titleArray) {
               [self setData:status titleArray:titleArray];
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)setData:(NSString *)status titleArray:(NSMutableArray *)titleArray
{
    if ([status isEqualToString:REQUEST_SUCCESS])
    {
        self.isRequestFail = NO;
        if (titleArray.count>1)
        {
            [self loadBottomBtn];
        }
    }
    else
    {
        self.isRequestFail = YES;
    }
    self.modelArray = [titleArray mutableCopy];
    for (int i=0; i<self.modelArray.count; i++)
    {
        BDMoreSelectModel *mModel = self.modelArray[i];
        for (int j=0; j<self.selectArray.count; j++)
        {
            if ([mModel.title isEqualToString:selectArray[j]])
            {
                [self.IDArray addObject:mModel.dId];
                mModel.isSelect = YES;
            }
        }
    }
    [self.tableview reloadData];
    [BDStyle handlerDataError:status currentVC:self handler:^{
        [self loadData];
    }];

}

- (void)loadBottomBtn
{
    HYWeakSelf;
    bottombtn = [UIButton createBtn:LS(@"Determine") bgColor:[UIColor subjectColor] titleColor:WHITE_COLOR font:16 complete:^{
        HYStrongSelf;
        if (sSelf.backSelectHandler)
        {
            sSelf.backSelectHandler(selectArray,self.IDArray);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:bottombtn];
    [bottombtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HScale*40);
        make.left.equalTo(self.view).offset(WScale*15);
        make.bottom.equalTo(self.view).offset(HScale*-20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [tableview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(HScale*-65);
    }];
}

#pragma mark -tableview datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HScale*50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HScale*50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BDChooseHeardView *heardView = [BDChooseHeardView createHeardView:CGRectMake(0, 0, SCREEN_WIDTH, HScale*50)];
    [heardView bindData:self.title titleArray:selectArray];
    return heardView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDMoreChooseTableViewCell *cell = [BDMoreChooseTableViewCell createTableCell:tableView];
    [cell bindData:self.modelArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDMoreSelectModel *model = self.modelArray[indexPath.row];
    model.isSelect = !model.isSelect;
    NSInteger index = -1;
    if (model.isSelect)
    {
        [self.IDArray addObject:model.dId];
        [selectArray addObject:model.title];
    }
    else
    {
        for (int i=0;i<selectArray.count;i++)
        {
            NSString *message = selectArray[i];
            if ([message isEqualToString:model.title])
            {
                index = i;
                continue;
            }
        }
        if (index != -1)
        {
            [self.IDArray removeObjectAtIndex:index];
            [selectArray removeObjectAtIndex:index];
        }
    }
    [tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0)
    {
        tableview.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark -EmptyDataSet delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"no_data";
    if (self.isRequestFail)
    {
        imageName = @"no_internet";
    }
    UIImage *noData =[UIImage imageNamed:imageName];
    noData = [noData imageByScalingToSize:CGSizeMake(WScale*150,75.0/90.0*WScale*150)];
    return noData;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (self.isRequestFail)
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
