//
//  BDBasisMessageViewController.m
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDBasisMessageViewController.h"

@interface BDBasisMessageViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>


@property (nonatomic, strong) BDLocationTableViewCell *locationCell;

@property (nonatomic, strong) BDAddOwnerTableViewCell *addOwnerCell;

@property (nonatomic, strong) BDContractPictureTableViewCell *basicMessageCell;

@property (nonatomic, strong) UIButton *changeBtn;

@end

@implementation BDBasisMessageViewController
@synthesize tableview;
@synthesize signModel;
@synthesize locationCell;
@synthesize detailModel;
@synthesize changeBtn;
@synthesize addOwnerCell;
@synthesize basicMessageCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self loadData];
}


- (void)setUpUI
{
    detailModel = [[BDSignDetailModel alloc]initWithDic:[NSDictionary new]];
    
    [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Normal title:LS(@"Basic_Message") didBackAction:nil];
    
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
    addOwnerCell = [BDAddOwnerTableViewCell createTableCell:tableview];
    basicMessageCell = [BDContractPictureTableViewCell createTableCell:tableview];
    locationCell = [BDLocationTableViewCell createTableCell:tableview];
    self.pushNumber = 3;
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

- (void)reloadView
{
    HYWeakSelf;
    changeBtn = [UIButton createBtn:LS(@"Change") bgColor:[UIColor subjectColor] titleColor:WHITE_COLOR font:16 complete:^{
        HYStrongSelf;
        [BDStyle showLoading:@"" rootView:sSelf.view];
        [BDHomeViewModel updateShopMessage:sSelf.signModel.sign_mid shop:detailModel hadnler:^(id value) {
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
    [changeBtn racISEnableWithShopBasic:detailModel];
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
    NSInteger number = [[detailModel getTitleArray] count];
    if (number >0)
    {
         number = ([[detailModel getTitleArray] count]-1);
    }
    return number;
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
        return HScale*50;
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
        ownerView.isDelete = sSelf.detailModel.haveOwner;
        return ownerView;
    }
    else
    {
        BDHeardView *oneView = [BDHeardView createView:HScale*60 title:LS(@"Shop_Message") handler:^{
            sSelf.detailModel.firstOpen = !sSelf.detailModel.firstOpen;
            sSelf.detailModel.basicModel.isChange = NO;
            [tableview reloadData];
        }];
        oneView.heardBtn.isOpen = self.detailModel.firstOpen;
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
            return self.addOwnerCell;
        }
        else
        {
            BDOwnerMessageTableViewCell *cell = [BDOwnerMessageTableViewCell createTableCell:tableView];
            [cell bindData:titleArr[indexPath.row] message:[detailModel.ownerModel detailGetMeesgae:indexPath.row]];
            return cell;
        }
    }
    else
    {
        if (indexPath.row == 1 || indexPath.row == 7 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6)
        {
            BDMessageTableViewCell *cell = [BDMessageTableViewCell createTableCell:tableView];
            [cell bindData:titleArr[indexPath.row] message:[detailModel.basicModel getMessage:indexPath.row]];
            cell.textHandler = ^(NSString *title){
                [sSelf.detailModel.basicModel setMessage:indexPath.row title:title];
            };
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
            return self.basicMessageCell;
        }
        else
        {
            BDChooseMessageTableViewCell *cell = [BDChooseMessageTableViewCell createTableCell:tableView];
            [cell bindData:titleArr[indexPath.row] message:[detailModel.basicModel getMessage:indexPath.row]];
            return cell;
        }
    }
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

@end
