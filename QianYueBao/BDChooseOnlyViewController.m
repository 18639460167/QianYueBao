//
//  BDChooseOnlyViewController.m
//  QianYueBao
//
//  Created by Black on 17/5/11.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDChooseOnlyViewController.h"

@interface BDChooseOnlyViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *bottombtn;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) BOOL isRequestFail;

@end

@implementation BDChooseOnlyViewController
@synthesize tableview;
@synthesize bottombtn;
@synthesize selectIndex;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self loadData];
}

- (void)setUpUI
{
    selectIndex = -1;
    [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Normal title:self.title didBackAction:nil];
    
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
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
    if (self.isSex)
    {
        [self setBottom];
        self.dataArray = [NSMutableArray new];
        for (int i=0; i<2; i++)
        {
            if (i == 0)
            {
                BDCountryModel *model = [[BDCountryModel alloc]initWithDic:@{@"country_code":@"10",@"country_name":@"男",@"phone_code":@"10",}];
                [self.dataArray addObject:model];
            }
            else
            {
                BDCountryModel *model = [[BDCountryModel alloc]initWithDic:@{@"country_code":@"10",@"country_name":@"女",@"phone_code":@"10",}];
                [self.dataArray addObject:model];
            }
        }
        for (int i=0;i<self.dataArray.count;i++)
        {
            BDCountryModel *model = self.dataArray[i];
            if ([model.name isEqualToString:self.country])
            {
                model.isSelect = !model.isSelect;
                selectIndex = i;
                continue;
            }
        }
        [tableview reloadData];
    }
    else
    {
        [BDStyle showLoading:@"" rootView:self.view];
        [BDCommonVieModel getMerchantCountry:^(NSString *status, NSMutableArray *countaryArray) {
            if ([status isEqualToString:REQUEST_SUCCESS])
            {
                self.isRequestFail = NO;
                if (countaryArray.count>1)
                {
                    [self setBottom];
                }
                self.dataArray = [countaryArray mutableCopy];
                for (int i=0;i<self.dataArray.count;i++)
                {
                    BDCountryModel *model = self.dataArray[i];
                    if ([model.name isEqualToString:self.country])
                    {
                        model.isSelect = !model.isSelect;
                        selectIndex = i;
                        continue;
                    }
                }
                [self.tableview reloadData];
            }
            else
            {
                self.isRequestFail = YES;
                selectIndex = -1;
                [self.dataArray removeAllObjects];
                [tableview reloadData];
            }
            [BDStyle handlerDataError:status currentVC:self handler:^{
                [self loadData];
            }];
        }];
    }
}
- (void)setBottom
{
    HYWeakSelf;
    bottombtn = [UIButton createBtn:LS(@"Determine") bgColor:[UIColor subjectColor] titleColor:WHITE_COLOR font:16 complete:^{
        HYStrongSelf;
        if (sSelf.backhandler)
        {
            if (selectIndex!=-1 && selectIndex<sSelf.dataArray.count)
            {
                BDCountryModel *model = sSelf.dataArray[selectIndex];
                sSelf.backhandler(model.name,model.code);
                [sSelf.navigationController popViewControllerAnimated:YES];
            }
        }
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

#pragma mark - tableview datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
    if (selectIndex != -1 && self.dataArray.count>selectIndex)
    {
        BDCountryModel *model = self.dataArray[selectIndex];
        [heardView bindData:self.title model:model.name];
    }
    else
    {
        [heardView bindData:self.title model:self.country];
    }
    return heardView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDMoreChooseTableViewCell *cell = [BDMoreChooseTableViewCell createTableCell:tableview];
    [cell bindData:self.dataArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectIndex == indexPath.row)
    {
        return;
    }
    if (selectIndex==-1)
    {
        BDCountryModel *model = self.dataArray[indexPath.row];
        model.isSelect = YES;
        selectIndex = indexPath.row;
        [tableview reloadData];
    }
    else
    {
        if (selectIndex<self.dataArray.count)
        {
            if (selectIndex == indexPath.row)
            {
                BDCountryModel *model = self.dataArray[selectIndex];
                model.isSelect = !model.isSelect;
                selectIndex = -1;
            }
            else
            {
                BDCountryModel *model = self.dataArray[selectIndex];
                model.isSelect = !model.isSelect;
                BDCountryModel *sModel = self.dataArray[indexPath.row];
                sModel.isSelect = !sModel.isSelect;
                selectIndex = indexPath.row;
            }
        }
        else
        {
            return;
        }
    }
     [tableview reloadData];
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
