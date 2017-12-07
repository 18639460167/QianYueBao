//
//  BDConsultViewController.m
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDConsultViewController.h"
#import "BDConsultView.h"

@interface BDConsultViewController ()

@end

@implementation BDConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

- (void)setUpUI
{
    [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Normal title:LS(@"Information") didBackAction:nil];
    BDConsultView *enterpriceView = [BDConsultView createView:self title:LS(@"Business_Situation")];
    [enterpriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
        make.height.mas_equalTo(HScale*50);
    }];
    
    BDConsultView *editionView = [BDConsultView createView:self title:LS(@"Version_Notification")];
    [editionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(enterpriceView.mas_bottom);
        make.height.mas_equalTo(HScale*50);
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
