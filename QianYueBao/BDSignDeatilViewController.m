//
//  BDSignDeatilViewController.m
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSignDeatilViewController.h"

@interface BDSignDeatilViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) BDLocationTableViewCell *locationCell;

@property (nonatomic, strong) BDAddOwnerTableViewCell *addOwnerCell;

@property (nonatomic, strong) BDContractPictureTableViewCell *basicMessageCell;

@property (nonatomic, strong) BDContractPictureTableViewCell *contractMessageCell;

@property (nonatomic, strong) BDBottomView *submitBtn;

@property (nonatomic, strong) BDNavigationRightButton *rigthBtn;

@property (nonatomic, assign) BOOL enable;

@end

@implementation BDSignDeatilViewController
@synthesize tableview;
@synthesize locationCell;
@synthesize detailModel;
@synthesize submitBtn;
@synthesize addOwnerCell;
@synthesize enable;
@synthesize basicMessageCell;
@synthesize contractMessageCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self loadData];
}

- (void)setUpUI
{
    detailModel = [BDSignDetailModel new];
    enable = YES;
    switch (self.listModel.contract_status)
    {
        case TradeStatus_Process:
        {
            self.title = LS(@"Under_Review");
            enable = NO;
        }
            break;
        case TradeStatus_Fail:
        {
            self.title = LS(@"Review_Fail");
            if (self.listModel.isFmdb)
            {
                detailModel = self.listModel.detailModel;
                detailModel.contractModel.isChange = NO;
                detailModel.basicModel.isChange = NO;
            }
        }
            break;
        case TradeStatus_Wait:
        {
            self.title = LS(@"Message_Draft");
            detailModel = self.listModel.detailModel;
            detailModel.contractModel.isChange = NO;
            detailModel.basicModel.isChange = NO;
        }
            break;
            
        default:
            break;
    }
    if (self.listModel.contract_status == TradeStatus_Process)
    {
        [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Normal title:self.title didBackAction:nil];
    }
    else
    {
        HYWeakSelf;
        self.rigthBtn = [BDNavigationRightButton createBtnTitle:LS(@"Save") imageName:@"sign_save" isSame:YES action:^{
            HYStrongSelf;
            [BDFmdbModel updateDetailModel:detailModel id:sSelf.listModel currentVC:self complete:nil];
        }];
        [self LoadNavigation:self.rigthBtn navStyle:BDNavitionStyle_Normal title:self.title didBackAction:nil];
        self.rigthBtn.hidden = YES;
        if (self.listModel.contract_status == TradeStatus_Wait || self.listModel.isFmdb == YES)
        {
            self.rigthBtn.hidden = NO;
        }
    }
    
    UIImageView *topImage = [UIImageView createImage:@"wave"];
    [self.view addSubview:topImage];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
        make.height.mas_equalTo(HScale*55);
    }];
    
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    tableview.backgroundColor = [WHITE_COLOR colorWithAlphaComponent:0];
    tableview.emptyDataSetDelegate = self;
    tableview.emptyDataSetSource = self;
    addOwnerCell = [BDAddOwnerTableViewCell createTableCell:tableview];
    locationCell = [BDLocationTableViewCell createTableCell:tableview];
    basicMessageCell = [BDContractPictureTableViewCell createTableCell:tableview];
    contractMessageCell = [BDContractPictureTableViewCell createTableCell:tableview];
    self.pushNumber = 2;
    addOwnerCell.signVC = self;
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage.mas_bottom).offset(HScale*-15);
        make.left.right.bottom.equalTo(self.view);
    }];
    HYWeakSelf;
    self.ownerBackHandler = ^(id value){
        HYStrongSelf;
        sSelf.detailModel.haveOwner = YES;
        sSelf.detailModel.ownerModel=  (BDOwnerModel *)value;
        [sSelf.tableview reloadData];
    };
}

- (void)loadData
{
    [submitBtn removeFromSuperview];
    [tableview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    if ((self.listModel.contract_status == TradeStatus_Wait && self.listModel.detailModel) || self.listModel.isFmdb == YES)
    {
        [self reloadView];
    }
    else
    {
        [BDStyle showLoading:@"" rootView:self.view];
        [BDHomeViewModel merchantShopDetail:self.listModel.sign_mid handler:^(NSString *status, BDSignDetailModel *model) {
            self.detailModel = model;
            if ([status isEqualToString:REQUEST_SUCCESS])
            {
                [self reloadView];
                detailModel.requestSuccess = YES;
                self.rigthBtn.hidden = NO;
            }
            else
            {
                self.rigthBtn.hidden = YES;
            }
            [self.tableview reloadData];
            [BDStyle handlerDataError:status currentVC:self handler:^{
                detailModel.requestSuccess = NO;
                self.rigthBtn.hidden = YES;
                [self loadData];
            }];
        }];
    }
}

- (void)reloadView
{
    HYWeakSelf;
    submitBtn = [BDBottomView createBottomView:self.listModel.contract_status fathView:self.view handler:^{
        HYStrongSelf;
        [BDHomeViewModel merchantCreateShop:self.detailModel status:self.listModel.contract_status handler:^(id value) {
            if ([value isEqualToString:REQUEST_SUCCESS])
            {
                [[BDFmdbModel shareInstance] deleteWithTableName:READ_SHOP_SIGN(User_ID) where:@[@"id",@"=",[NSString trimNSNullASDefault:sSelf.listModel.detailID andDefault:@"-1"]]];
                [sSelf scrollviewNotifice:LS(@"Submit_Success") style:@"2"];
            }
            else
            {
                [BDStyle handlerDataError:value currentVC:sSelf handler:nil];
            }
        }];
    }];
    if (self.listModel.contract_status != TradeStatus_Process)
    {
        [submitBtn.bottomBtn racIsEnableWithModel:detailModel backColor:[UIColor subjectColor]];
    }
    [tableview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(submitBtn.height+HScale*5));
    }];
}
#pragma mark - tableview datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[detailModel getTitleArray] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [detailModel getRowCount:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [detailModel getRowHeight:indexPath.section indexRow:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return HScale*35;
    }
    else
    {
        return HScale*60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HYWeakSelf;
    HYStrongSelf;
    if (section == 0)
    {
        BDAddOwnerView *ownerView = [BDAddOwnerView createOwnerView:HScale*35 title:LS(@"Owner_Message") handler:^{
            sSelf.detailModel.haveOwner = NO;
            [sSelf.tableview reloadData];
        }];
        if (self.listModel.contract_status == TradeStatus_Process)
        {
            ownerView.isDelete = NO;
        }
        else
        {
            ownerView.isDelete = sSelf.detailModel.haveOwner;
        }
        return ownerView;
    }
    else if (section == 1)
    {
        BDHeardView *oneView = [BDHeardView createView:HScale*60 title:LS(@"Shop_Message") handler:^{
            sSelf.detailModel.firstOpen = !sSelf.detailModel.firstOpen;
            detailModel.basicModel.isChange = NO;
            [tableview reloadData];
        }];
        oneView.heardBtn.isOpen = self.detailModel.firstOpen;
        return oneView;
    }
    else
    {
        BDHeardView *oneView = [BDHeardView createView:HScale*60 title:LS(@"Contract_Message") handler:^{
            sSelf.detailModel.twoOpen = !sSelf.detailModel.twoOpen;
            detailModel.contractModel.isChange = NO;
            [tableview reloadData];
        }];
        oneView.heardBtn.isOpen = self.detailModel.twoOpen;
        return oneView;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYWeakSelf;
    HYStrongSelf;
    NSArray *titleArr = [detailModel getTitleArray][indexPath.section];
    if (indexPath.section == 0)
    {
        if (!detailModel.haveOwner)
        {
            self.addOwnerCell.userInteractionEnabled = enable;
            return self.addOwnerCell;
        }
        else
        {
            BDOwnerMessageTableViewCell *cell = [BDOwnerMessageTableViewCell createTableCell:tableView];
            [cell bindData:titleArr[indexPath.row] message:[detailModel.ownerModel detailGetMeesgae:indexPath.row]];
            cell.userInteractionEnabled = enable;
            return cell;
        }
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 1 || indexPath.row == 7 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6)
        {
            BDMessageTableViewCell *cell = [BDMessageTableViewCell createTableCell:tableView];
            [cell bindData:titleArr[indexPath.row] message:[detailModel.basicModel getMessage:indexPath.row]];
            cell.textHandler = ^(NSString *title){
                [sSelf.detailModel.basicModel setMessage:indexPath.row title:title];
            };
            cell.userInteractionEnabled = enable;
            return cell;
        }
        else if (indexPath.row == 0)
        {
            BDShopLogoTableViewCell *cell = [BDShopLogoTableViewCell createTableCell:tableView];
            cell.vc = self;
            [cell bindMessage:titleArr[indexPath.row] message:[detailModel.basicModel getMessage:indexPath.row]];
            cell.logoUrlHandler = ^(NSString *logoUrl){
                [sSelf.detailModel.basicModel setMessage:indexPath.row title:logoUrl];
                [tableView reloadIndex:indexPath.section row:indexPath.row];
            };
            cell.userInteractionEnabled = enable;
            return cell;
        }
        else if (indexPath.row == 2)
        {
            if (detailModel.basicModel.geo_lng && (![detailModel.basicModel.geo_lng isEqualToString:@""]))
            {
                self.locationCell.locationText.text = [NSString stringWithFormat:@"{%@,%@}",detailModel.basicModel.geo_lng,detailModel.basicModel.geo_lat];
            }
            self.locationCell.getAddress = ^(NSString *location,NSString *address)
            {
                sSelf.detailModel.basicModel.geo_lat = location;
                sSelf.detailModel.basicModel.geo_lng = address;
            };
            self.locationCell.userInteractionEnabled = enable;
            self.locationCell.vc = self;
            return locationCell;
        }
        else if (indexPath.row == 11)
        {
            self.basicMessageCell.contractImage = ^(NSArray *picArray){
                sSelf.detailModel.basicModel.isChange = NO;
                sSelf.detailModel.basicModel.thumbnails = picArray;
                [tableView reloadData];
            };
            [self.basicMessageCell bindTitle:titleArr[indexPath.row] currentVC:self];
            if (!detailModel.basicModel.isChange)
            {
                [self.basicMessageCell bindData:detailModel.basicModel.thumbnails];
            }
            detailModel.basicModel.isChange = YES;
            self.basicMessageCell.canEdit = !enable;
            return self.basicMessageCell;
        }
        else
        {
            BDChooseMessageTableViewCell *cell = [BDChooseMessageTableViewCell createTableCell:tableView];
            [cell bindData:titleArr[indexPath.row] message:[detailModel.basicModel getMessage:indexPath.row]];
            cell.userInteractionEnabled = enable;
            return cell;
        }
    }
    else
    {
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
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableview cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[BDChooseMessageTableViewCell class]])
    {
        BDChooseMessageTableViewCell *mCell = (BDChooseMessageTableViewCell *)cell;
        [mCell cellAction:self];
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
