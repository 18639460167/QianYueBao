//
//  BDSignViewController.m
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSignViewController.h"

#define tableName @"student1"

@interface BDSignViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BDLocationTableViewCell *locationCell;
@property (nonatomic, strong) BDAddOwnerTableViewCell *addOwnerCell;
@property (nonatomic, strong) BDContractPictureTableViewCell *basicMessageCell;
@property (nonatomic, strong) BDContractPictureTableViewCell *contractMessageCell;

@end

@implementation BDSignViewController
@synthesize tableview;
@synthesize locationCell;
@synthesize addOwnerCell;
@synthesize detailModel;
@synthesize basicMessageCell;
@synthesize contractMessageCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

- (void)setUpUI
{
    HYWeakSelf;
    HYStrongSelf;
    [self LoadNavigation:[BDNavigationRightButton createBtnTitle:LS(@"Save") imageName:@"sign_save" isSame:YES action:^{
        [BDStyle showLoading:@"" rootView:self.view];
        [BDFmdbModel saveDetailModel:detailModel complete:^(id value) {
            if ([value isEqualToString:REQUEST_SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:Home_ScrollChange object:nil userInfo:@{@"index":@"3"}];
                [BDStyle showLoading:LS(@"Save_Success") currentView:sSelf.view handler:^{
                    [sSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                }];
            }
            else
            {
               [BDStyle handlerDataError:value currentVC:self handler:nil];
            }
        }];
        
    }] navStyle:BDNavitionStyle_Normal title:LS(@"Information_Collection") didBackAction:^{
        [sSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    detailModel = [[BDSignDetailModel alloc]initWithDic:[NSDictionary new]];
    detailModel.requestSuccess = YES;
    detailModel.haveOwner = NO;
    
    UIImageView *topImage = [UIImageView createImage:@"wave"];
    [self.view addSubview:topImage];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
        make.height.mas_equalTo(HScale*55);
    }];
    
    UIButton *submitBtn = [UIButton createBtn:LS(@"Submit") bgColor:[UIColor subjectColor] titleColor:WHITE_COLOR font:16 complete:^{
        [BDStyle showLoading:@"" rootView:self.view];
        [BDHomeViewModel merchantCreateShop:self.detailModel status:TradeStatus_Wait handler:^(id value) {
            if ([value isEqualToString:REQUEST_SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:Home_ScrollChange object:nil userInfo:@{@"index":@"2"}];
                [BDStyle showLoading:LS(@"Submit_Success") currentView:sSelf.view handler:^{
                    [sSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                }];
            }
            else
            {
                [BDStyle handlerDataError:value currentVC:self handler:nil];
            }
        }];
    }];
    
    [submitBtn racIsEnableWithModel:detailModel backColor:[UIColor subjectColor]];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HScale*40);
        make.left.equalTo(self.view).offset(WScale*15);
        make.bottom.equalTo(self.view).offset(HScale*-10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    tableview.backgroundColor = [WHITE_COLOR colorWithAlphaComponent:0];
    locationCell = [BDLocationTableViewCell createTableCell:tableview];
    basicMessageCell = [BDContractPictureTableViewCell createTableCell:tableview];
    contractMessageCell = [BDContractPictureTableViewCell createTableCell:tableview];
    addOwnerCell = [BDAddOwnerTableViewCell createTableCell:tableview];
    self.pushNumber = 1;
    addOwnerCell.signVC = self;
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage.mas_bottom).offset(HScale*-15);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(submitBtn.mas_top).offset(HScale*-5);
    }];
    
    self.ownerBackHandler = ^(id value){
        HYStrongSelf;
        sSelf.detailModel.haveOwner = YES;
        sSelf.detailModel.ownerModel=  (BDOwnerModel *)value;
        [sSelf.tableview reloadData];
    };
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
        ownerView.isDelete = self.detailModel.haveOwner;
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
        BDHeardView *oneView = [BDHeardView createView:HScale*60 title:LS(@"Contract_Change") handler:^{
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
           return self.addOwnerCell;
        }
        else
        {
            BDOwnerMessageTableViewCell *cell = [BDOwnerMessageTableViewCell createTableCell:tableView];
            [cell bindData:titleArr[indexPath.row] message:[detailModel.ownerModel detailGetMeesgae:indexPath.row]];
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
                  self.locationCell.locationText.text = [NSString stringWithFormat:@"{%@,%@}",detailModel.basicModel.geo_lat,detailModel.basicModel.geo_lng];
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
            return self.contractMessageCell;
        }
        else if (indexPath.row == 2)
        {
            BDChooseMessageTableViewCell *cell = [BDChooseMessageTableViewCell createTableCell:tableview];
            [cell bindData:titleArr[indexPath.row] message:[detailModel.contractModel getChangeContactMessage:indexPath.row]];
            return cell;
        }
        else
        {
            BDMessageTableViewCell *cell = [BDMessageTableViewCell createTableCell:tableview];
            [cell bindData:titleArr[indexPath.row] message:[detailModel.contractModel getChangeContactMessage:indexPath.row]];
            cell.textHandler = ^(NSString *text){
                [sSelf.detailModel.contractModel setMessage:indexPath.row message:text];
            };
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
        [mCell cellAction:self ];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0)
    {
        tableview.contentOffset = CGPointMake(0, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
