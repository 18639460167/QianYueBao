//
//  BDSettingViewController.m
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSettingViewController.h"
#import "BDSetActionTableViewCell.h"
#import "BDUserHeardView.h"

@interface BDSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BDUserHeardView *heardView;

@end

@implementation BDSettingViewController
@synthesize tableview;
@synthesize heardView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    heardView = [BDUserHeardView crateHeardView:self];
    
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    [tableview registerCell:[BDSetActionTableViewCell class]];
    tableview.tableHeaderView = heardView;
    tableview.scrollEnabled = NO;
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

#pragma mark -tableview datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HScale*186;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDSetActionTableViewCell *cell = [BDSetActionTableViewCell createTableCell:tableView];
    cell.VC = self;
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    heardView.nameLbl.text = READ_SHOP_SIGN(User_Name);
    heardView.logoImage.image = [UIImage getHeardImage];
    [tableview reloadData];
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
