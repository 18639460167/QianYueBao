//
//  BDMaterialInformationViewController.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDMaterialInformationViewController.h"

@interface BDMaterialInformationViewController ()
{
    UIScrollView *scrollView;
    NSInteger currentIndex;
}
    

@end

@implementation BDMaterialInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBgView];
}
- (void)setBgView
{
    UIImageView *bgImage = [UIImageView createImage:@"no_data"];
    [self.view addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(BDWidth(150));
        make.height.mas_equalTo(75.0/90.0*WScale*150);
    }];
}

- (void)setUpUI
{
    CGFloat width = HScale*170+WScale*30;
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    scrollView.scrollEnabled = NO;
    scrollView.bounces=NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize=CGSizeMake(width*5, 0);
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).offset(HScale*60);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
    
    for (int i=0; i<5; i++)
    {
        BDCodeView *codeView = [[BDCodeView alloc]initWithFrame:CGRectMake(width*i, 0, width, width)];
        codeView.tag = i+1;
        codeView.numberLbl.text = [NSString stringWithFormat:@"%d/5",i+1];
        [scrollView addSubview:codeView];
    }
    
    UIButton *leftBtn = [UIButton buttonOnlyImage:@"code_left" fatherView:self.view action:^{
        if (currentIndex==0)
        {
            return ;
        }
        else
        {
            currentIndex --;
            scrollView.contentOffset=CGPointMake(width*currentIndex, 0);
        }
    }];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(scrollView.mas_centerY);
        make.right.equalTo(scrollView.mas_left).offset(WScale*-15);
        make.size.mas_equalTo(CGSizeMake(HScale*30, HScale*45));
    }];
    
    UIButton *rightBtn = [UIButton buttonOnlyImage:@"code_right" fatherView:self.view action:^{
        if (currentIndex==4)
        {
            return ;
        }
        else
        {
            currentIndex ++;
            scrollView.contentOffset=CGPointMake(width*currentIndex, 0);
        }
    }];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(scrollView.mas_centerY);
        make.left.equalTo(scrollView.mas_right).offset(WScale*15);
        make.size.mas_equalTo(CGSizeMake(HScale*30, HScale*45));
    }];
    
    UILabel *titleLbl = [UILabel createLbl:LS(@"Change_Qr") font:12 textColor:[UIColor colorWithHexString:@"#969696"]];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(scrollView.mas_bottom).offset(HScale*17);
        make.height.mas_equalTo(HScale*14);
    }];
   
    UIButton *button = [UIButton buttonWithType:0];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor navigationColor].CGColor;
    [button setTitleColor:[UIColor navigationColor] forState:0];
    button.titleLabel.font = FONTSIZE(18);
    button.layer.cornerRadius = HScale*20;
    [button setTitle:LS(@"Save_Photo") forState:0];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view).offset(WScale*50);
        make.height.mas_equalTo(HScale*40);
        make.top.equalTo(titleLbl.mas_bottom).offset(HScale*30);
    }];

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
