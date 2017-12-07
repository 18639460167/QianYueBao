//
//  BDOwnerMessageViewController.m
//  QianYueBao
//
//  Created by Black on 17/5/3.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDOwnerMessageViewController.h"

@interface BDOwnerMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BDOwnerModel *ownerModel;

@end

@implementation BDOwnerMessageViewController
@synthesize ownerModel;
@synthesize tableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

- (void)setUpUI
{
    ownerModel = [[BDOwnerModel alloc]initWithDic:[NSDictionary new]];
    [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Normal title:LS(@"Owner_Message") didBackAction:nil];
    UIImageView *topImage = [UIImageView createImage:@"wave"];
    [self.view addSubview:topImage];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
        make.height.mas_equalTo(HScale*55);
    }];
    
    UIButton *submitBtn = [UIButton createBtn:LS(@"Submit") bgColor:[UIColor colorWithHexString:@"#fc6c72"] titleColor:WHITE_COLOR font:16 complete:^{
//        if ([ownerModel.sex isEqualToString:@""])
//        {
//            [BDStyle handlerDataError:@"请选择性别" currentVC:self handler:nil];
//            return ;
//        }
        [BDStyle showLoading:@"" rootView:self.view];
        [BDOwnerViewModel createOwner:ownerModel handler:^(id value) {
            [BDStyle handlerDataError:value currentVC:self handler:nil];
            if ([value isEqualToString:REQUEST_SUCCESS])
            {
                [self popSelectOwner:ownerModel type:self.pushNumber];
            }
        }];
    }];
    [submitBtn racIsEnableWithOwner:ownerModel];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HScale*40);
        make.left.equalTo(self.view).offset(WScale*15);
        make.bottom.equalTo(self.view).offset(HScale*-10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    [tableview registerCell:[BDMessageTableViewCell class]];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(topImage.mas_bottom);
        make.bottom.equalTo(submitBtn.mas_top).offset(HScale*-5);
    }];
}

#pragma mark -tableview datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (ownerModel.isOpen)
    {
        return 0;
    }
    return [BDOwnerModel getTitleArray].count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HScale*50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HScale*35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BDHeardView *oneView = [BDHeardView createView:HScale*35 title:LS(@"Basic_Message") handler:^{
        ownerModel.isOpen = !ownerModel.isOpen;
        [tableview reloadData];
    }];
    oneView.heardBtn.isOpen = ownerModel.isOpen;
    return oneView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        BDChooseMessageTableViewCell *cell = [BDChooseMessageTableViewCell createTableCell:tableView];
        [cell bindData:[BDOwnerModel getTitleArray][indexPath.row] message:[ownerModel getOwnerMessage:indexPath.row]];
        return cell;
    }
    BDMessageTableViewCell *cell = [BDMessageTableViewCell createTableCell:tableview];
    [cell bindData:[BDOwnerModel getTitleArray][indexPath.row] message:[ownerModel getOwnerMessage:indexPath.row]];
    HYWeakSelf;
    cell.textHandler = ^(NSString *text){
        HYStrongSelf;
        [sSelf.ownerModel saveMessage:indexPath.row message:text];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        HYWeakSelf;
        BDChooseOnlyViewController *vc =[BDChooseOnlyViewController new];
        vc.title = LS(@"Country");
        vc.country = ownerModel.country;
        vc.backhandler = ^(NSString *title,NSString *code)
        {
            HYStrongSelf;
            sSelf.ownerModel.country = title;
            sSelf.ownerModel.countey_code = code;
            [sSelf.tableview reloadIndex:indexPath.section row:indexPath.row];
        };
        [self pushAction:vc];
    }
//    if (indexPath.row == 2)
//    {
//        HYWeakSelf;
//        BDChooseOnlyViewController *vc =[BDChooseOnlyViewController new];
//        vc.title = @"性别";
//        vc.country = ownerModel.sex;
//        vc.isSex = YES;
//        vc.backhandler = ^(NSString *title,NSString *code)
//        {
//            HYStrongSelf;
//            sSelf.ownerModel.sex = title;
//            [sSelf.tableview reloadIndex:indexPath.section row:indexPath.row];
//        };
//        [self pushAction:vc];
//    }
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
