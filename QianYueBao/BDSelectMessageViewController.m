//
//  BDSelectMessageViewController.m
//  QianYueBao
//
//  Created by Black on 17/5/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSelectMessageViewController.h"

@interface BDSelectMessageViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) BDCategoryMenuView *menuView;

@property (nonatomic, strong) BDSignCategoryModel *signModel;

@property (nonatomic, strong) NSArray *modelArray;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, assign) BOOL isRequestFail;
@end

@implementation BDSelectMessageViewController
@synthesize tableview;
@synthesize titleArray;
@synthesize menuView;
@synthesize isRequestFail;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self loadData];
}

- (void)setUpUI
{
    HYWeakSelf;
    self.title = LS(@"Belong_Category");
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Normal title:self.title didBackAction:nil];
    titleArray = [NSMutableArray new];
    menuView = [BDCategoryMenuView createView:self.view];
    menuView.backIndexHandler = ^(NSInteger index){
        
        HYStrongSelf;
        if (index <sSelf.titleArray.count)
        {
            [sSelf.titleArray removeObjectsInRange:NSMakeRange(index, sSelf.titleArray.count-index)];
            [sSelf.selectArray removeObjectsInRange:NSMakeRange(index-1, sSelf.titleArray.count-index+1)];
            [sSelf.menuView reloadData:sSelf.titleArray];
        }
        
        for (int i=0; i<index; i++)
        {
            if (i==0)
            {
                sSelf.dataArray = sSelf.modelArray;
            }
            else
            {
                if (sSelf.selectArray.count>i-1)
                {
                    int a = [sSelf.selectArray[i-1] intValue];
                    BDSignCategoryModel *model = sSelf.dataArray[a];
                    sSelf.dataArray = model.categoryArray;
                }
            }
             [sSelf.tableview reloadData];
        }
    };
    [titleArray addObject:self.title];
    [menuView reloadData:titleArray];
    
    tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
    tableview.backgroundColor = [WHITE_COLOR colorWithAlphaComponent:0];
    tableview.emptyDataSetDelegate = self;
    tableview.emptyDataSetSource = self;
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(menuView.mas_bottom);
    }];
}

- (void)loadData
{
    self.selectArray = [NSMutableArray new];
    
    [BDStyle showLoading:@"" rootView:self.view];
    [BDCommonVieModel getMerchantCategory:^(NSString *status, NSArray *titlArray) {
        if ([status isEqualToString:REQUEST_SUCCESS])
        {
            isRequestFail = NO;
        }
        else
        {
            isRequestFail = YES;
        }
        self.dataArray = titlArray;
        self.modelArray = titlArray;
        [tableview reloadData];
        if (self.dataArray.count>0)
        {
            self.signModel = self.dataArray[0];
        }
        [BDStyle handlerDataError:status currentVC:self handler:^{
            [titleArray removeAllObjects];
            [titleArray addObject:self.title];
            [menuView reloadData:titleArray];
            [self loadData];
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
    return HScale*50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDSelectCategoryTableViewCell *cell = [BDSelectCategoryTableViewCell createTableCell:tableview];
    BDSignCategoryModel *model = self.dataArray[indexPath.row];
    [cell bindData:model.title];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BDSignCategoryModel *model = self.dataArray[indexPath.row];
//    [titleArray addObject:model.title];
//    self.signModel = model;
//    self.dataArray  = model.categoryArray;
//    NSString *index = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//    [self.selectArray addObject:index];
//    NSLog(@"==%@",self.selectArray);
//    [menuView reloadData:titleArray];
//    [tableView reloadData];
//    return;
    if (indexPath.row<self.dataArray.count)
    {
        BDSignCategoryModel *model = self.dataArray[indexPath.row];
        self.signModel = model;
        [titleArray addObject:model.title];
        if (model.categoryArray.count == 0)
        {
            if (self.selecthandler)
            {
                if (titleArray.count>0)
                {
                    [titleArray removeObjectAtIndex:0];
                    NSString *message = @"";
                    for (int i=0; i<titleArray.count; i++)
                    {

                        NSString *str = TRIM(titleArray[i]);
                        if (i == 0)
                        {
                            message = str;
                        }
                        else
                        {
                            message = [NSString stringWithFormat:@"%@ > %@",message,str];
                        }
                    }
                    self.selecthandler(model.category_id,message);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
        else
        {
            self.dataArray  = model.categoryArray;
            NSString *index = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            [self.selectArray addObject:index];
            [menuView reloadData:titleArray];
            [tableView reloadData];
        }
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
