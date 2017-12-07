//
//  BDSignFinishViewController.m
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSignFinishViewController.h"
#import "BDSignFinishTopView.h"

@interface BDSignFinishViewController ()
{
    NSArray *vcArray;
}
@property (nonatomic, strong) BDSliderView *bdSlider;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger currentValue;
@end

@implementation BDSignFinishViewController
@synthesize currentValue;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

- (void)setUpUI
{
    currentValue = 0;
    [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Clean title:self.signModel.title didBackAction:nil];
    [BDSignFinishTopView cretaView:self];
    
    BDTransActionFlowViewController *transVC = [[BDTransActionFlowViewController alloc]init];
    transVC.finishVC = self;
    BDLiquidationViewController *liVC = [[BDLiquidationViewController alloc]init];
    liVC.finishVC = self;
    BDMaterialInformationViewController *metrailVC = [[BDMaterialInformationViewController alloc]init];
    metrailVC.finishVC = self;
    BDContractChangeViewController *contractVC = [[BDContractChangeViewController alloc]init];
    contractVC.finishVC = self;
    
    vcArray = @[transVC,liVC,metrailVC,contractVC];
    HYWeakSelf;
    self.bdSlider = [[BDSliderView alloc]initWithFrame:CGRectMake(0, HScale*190, SCREEN_WIDTH, SCREEN_HEIGHT-(HScale*190)) WithViewControllers:vcArray titleArray:@[LS(@"Trading_Water"),LS(@"Liquidation_Record"),LS(@"Material_Information"),LS(@"Contract_Change")] complete:^(NSInteger index) {
        HYStrongSelf;
        sSelf.selectIndex = index;
        [self loadData];
    }];
    [self.view addSubview:self.bdSlider];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)loadData
{
    currentValue++;
    if (currentValue == 1)
    {
        return;
    }
    if (self.selectIndex == 0)
    {
        BDTransActionFlowViewController *controller = (BDTransActionFlowViewController *)vcArray[self.selectIndex];
        [controller initLoadData];
        
    }
    else if (self.selectIndex == 1)
    {
        BDLiquidationViewController *controller = (BDLiquidationViewController *)vcArray[self.selectIndex];
        [controller initLoadData];
    }
    else if (self.selectIndex == 2)
    {
        BDMaterialInformationViewController *controller = (BDMaterialInformationViewController *)vcArray[self.selectIndex];
        [controller initLoadData];
    }
    else
    {
        BDContractChangeViewController *controller = (BDContractChangeViewController *)vcArray[self.selectIndex];
        [controller initLoadData];
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
