//
//  BDUserViewController.m
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDUserViewController.h"
#import "BDUserLogoView.h"

@interface BDUserViewController ()

@property (nonatomic, strong) BDMessageView *nameView;
@property (nonatomic, strong) BDMessageView *emailView;
@property (nonatomic, strong) BDUserLogoView *heardView;

@end

@implementation BDUserViewController
@synthesize nameView;
@synthesize emailView;
@synthesize heardView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

- (void)setUpUI
{
    [self loadHaveLeftBtn:YES navStyle:BDNavitionStyle_Normal title:LS(@"Personal_Information") didBackAction:nil];
    
    heardView = [BDUserLogoView createLogoView:self];
    
    nameView = [BDMessageView createView:LS(@"Nickname")];
    nameView.message = READ_SHOP_SIGN(User_Name);
    [self.view addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(heardView.mas_bottom);
        make.height.mas_equalTo(HScale*50);
    }];
    
    emailView = [BDMessageView createView:LS(@"Email")];
    emailView.message = @"";
    [self.view addSubview:emailView];
    [emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(nameView.mas_bottom);
        make.height.mas_equalTo(HScale*50);
    }];
    
    UIButton *quitBtn = [UIButton createBtn:LS(@"Sign_Out") bgColor:[UIColor subjectColor] titleColor:WHITE_COLOR font:16 complete:^{
        [BDStyle showLoading:@""];
        [BDLoginViewModel logoutHandler:^(id obj) {
            emailView.message = @"";
            nameView.message = @"";
            heardView.heardImage.image = IMAGE_NAME(@"head");
            [BDStyle handlerError:NEED_LOGIN currentVC:self loginHandler:^{
                emailView.message = @"";
                nameView.message = READ_SHOP_SIGN(User_Name);
                heardView.heardImage.image = [UIImage getHeardImage];
            }];
        }];
    }];
    [self.view addSubview:quitBtn];
    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HScale*40);
        make.left.equalTo(self.view).offset(WScale*15);
        make.bottom.equalTo(self.view).offset(HScale*-20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    heardView.heardImage.image = [UIImage getHeardImage];
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
