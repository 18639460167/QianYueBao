//
//  BDChangeContractViewController.m
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDChangeContractViewController.h"
@interface BDChangeContractViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIButton *changeBtn;

@property (nonatomic, strong) BDContractPictureTableViewCell *contractMessageCell;

@property (nonatomic, assign) BOOL enable;

@end

@implementation BDChangeContractViewController
@synthesize signModel;
@synthesize tableview;
@synthesize changeBtn;
@synthesize detailModel;
@synthesize enable;
@synthesize contractMessageCell;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self loadData];
}

- (void)setUpUI
{
    NSString *message = LS(@"Contract_Change");
//    if (detailModel)
//    {
//        message = [detailModel.contractModel statusMessage:detailModel.contractModel.contract_status];
//    }
    [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Normal title:message didBackAction:nil];
    
    UIImageView *topImage = [UIImageView createImage:@"wave"];
    [self.view addSubview:topImage];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
        make.height.mas_equalTo(HScale*55);
    }];
    
    
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    tableview.emptyDataSetDelegate = self;
    tableview.emptyDataSetSource = self;
    contractMessageCell = [BDContractPictureTableViewCell createTableCell:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage.mas_bottom).offset(HScale*-15);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)loadData
{
    if (detailModel)
    {
        [self reloadView];
        [self.tableview reloadData];
    }
    else
    {
        [changeBtn removeFromSuperview];
        [tableview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
        [BDStyle showLoading:@"" rootView:self.view];
        [BDHomeViewModel merchantShopDetail:self.signModel.sign_mid handler:^(NSString *status, BDSignDetailModel *model) {
            self.detailModel = model;
            if ([status isEqualToString:REQUEST_SUCCESS])
            {
                [self reloadView];
                detailModel.requestSuccess = YES;
            }
            [self.tableview reloadData];
            [BDStyle handlerDataError:status currentVC:self handler:^{
                detailModel.requestSuccess = NO;
                [self loadData];
            }];
        }];
    }
}

- (void)reloadView
{
    HYWeakSelf;
    changeBtn = [UIButton createBtn:LS(@"Change") bgColor:[UIColor colorWithHexString:@"#fc6c72"] titleColor:WHITE_COLOR font:16 complete:^{
        HYStrongSelf;
        [BDStyle showLoading:@"" rootView:sSelf.view];
        NSString *mid = signModel.sign_mid;
        if (detailModel)
        {
            mid = detailModel.contractModel.mid;
        }
        [BDContractViewModel updateContract:mid contractModel:detailModel.contractModel handler:^(id value) {
            if ([value isEqualToString:REQUEST_SUCCESS])
            {
                [BDStyle showLoading:LS(@"Change_Success") currentView:sSelf.view handler:^{
                    [sSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
            else
            {
               [BDStyle handlerDataError:value currentVC:sSelf handler:nil]; 
            }
        }];
    }];
    if (detailModel.contractModel.contract_status == TradeStatus_Process)
    {
        changeBtn.backgroundColor = [UIColor colorWithHexString:@"#b4b4b4"];
        changeBtn.enabled = NO;
        enable = NO;
        [changeBtn setTitle:LS(@"Under_Review") forState:UIControlStateNormal];
    }
    else
    {
        enable = YES;
        [changeBtn racIsEnableWithContract:detailModel.contractModel];
    }
    [self.view addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HScale*40);
        make.left.equalTo(self.view).offset(WScale*15);
        make.bottom.equalTo(self.view).offset(HScale*-10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [tableview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(HScale-55);
    }];
}
#pragma mark -tableview datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (detailModel)
    {
        NSInteger number = [[detailModel getTitleArray] count];
        if (number >0)
        {
            number = ([[detailModel getTitleArray] count]-2);
        }
        return number;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [detailModel getRowCount:2];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [detailModel getRowHeight:2 indexRow:indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return HScale*35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BDAddOwnerView *ownerView = [BDAddOwnerView createOwnerView:HScale*35 title:LS(@"Contract_Message") handler:nil];
    ownerView.isDelete = NO;
    return ownerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYWeakSelf;
    HYStrongSelf;
    NSArray *titleArr = [detailModel getTitleArray][2];
    
    if (indexPath.row ==1)
    {
        self.contractMessageCell.contractImage = ^(NSArray *picArray){
            sSelf.detailModel.contractModel.isChange = NO;
            sSelf.detailModel.contractModel.contract_image = picArray;
            [tableView reloadData];
        };
        [self.contractMessageCell bindTitle:titleArr[indexPath.row] currentVC:self];
        if (!detailModel.contractModel.isChange)
        {
            [self.contractMessageCell bindData:detailModel.contractModel.contract_image];
        }
        detailModel.contractModel.isChange = YES;
        self.contractMessageCell.canEdit = !enable;
        return self.contractMessageCell;
    }
    else if (indexPath.row == 2)
    {
        BDChooseMessageTableViewCell *cell = [BDChooseMessageTableViewCell createTableCell:tableview];
        [cell bindData:titleArr[indexPath.row] message:[detailModel.contractModel getChangeContactMessage:indexPath.row]];
        cell.userInteractionEnabled = enable;
        return cell;
    }
    else
    {
        BDMessageTableViewCell *cell = [BDMessageTableViewCell createTableCell:tableview];
        [cell bindData:titleArr[indexPath.row] message:[detailModel.contractModel getChangeContactMessage:indexPath.row]];
        cell.textHandler = ^(NSString *text){
            [sSelf.detailModel.contractModel setMessage:indexPath.row message:text];
        };
        cell.userInteractionEnabled = enable;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        
        BDMoreChooseViewController *vc = [BDMoreChooseViewController new];
        vc.title = LS(@"Payment_Interface");
        vc.chooseStatus = ChooseStatus_Payment;
        vc.selectArray = [NSMutableArray arrayWithArray:detailModel.contractModel.payment_channel_val];
        
        vc.backSelectHandler = ^(NSArray *messageArray,NSArray *selectArray){
            detailModel.contractModel.payment_channel = selectArray;
            detailModel.contractModel.payment_channel_val = messageArray;
            [tableview reloadIndex:indexPath.section row:indexPath.row];
        };
        [self pushAction:vc];
    }
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