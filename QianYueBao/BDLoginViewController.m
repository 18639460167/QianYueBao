//
//  BDLoginViewController.m
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDLoginViewController.h"
#import "BDLoginTextView.h"

@interface BDLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) BDLoginTextView *nameTextView;
@property (nonatomic, strong) BDLoginTextView *passTextView;

@end

@implementation BDLoginViewController
@synthesize nameTextView;
@synthesize passTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}


- (void)setUpUI
{
    UIImageView *bgImage = [UIImageView createImage:@"login_bg"];
    [self.view addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    
    UIImageView *bearImage = [UIImageView createImage:@"bear"];
    [self.view addSubview:bearImage];
    [bearImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(HScale*45, HScale*50));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).offset(HScale *120);
    }];
    
    UILabel *nameLbl = [UILabel createLbl:@"Super Sign" font:18 textColor:WHITE_COLOR];
    [self.view addSubview:nameLbl];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(WScale *21);
        make.top.equalTo(bearImage.mas_bottom).offset(HScale*15);
    }];
    
    UILabel *titLbl = [UILabel createLbl:@"huanyouji" font:12 textColor:[UIColor colorWithHexString:@"#788096"]];
    [self.view addSubview:titLbl];
    [titLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(HScale *15);
        make.bottom.equalTo(self.view).offset(HScale*-20);
    }];
    HYWeakSelf;
    UIButton *loginBtn = [UIButton createBtn:LS(@"Login") bgImage:@"login_button" titleColor:WHITE_COLOR font:18 complete:^{
        HYStrongSelf;
        [sSelf loginAction];
    }];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(WScale*50);
        make.height.mas_equalTo(HScale*40);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(titLbl.mas_top).offset(HScale*-98);
    }];
    
    UIView *textView = [BDStyle createView:CLEAR_COLOR];
    textView.frame = CGRectMake(0, HScale*380, SCREEN_WIDTH, HScale*92.5);
    [self.view addSubview:textView];
    
    nameTextView = [BDLoginTextView createView:CGRectZero leftName:@"txt_name"];
    nameTextView.messageText.delegate = self;
    [textView addSubview:nameTextView];
    [nameTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(textView);
        make.height.mas_equalTo(HScale*40);
    }];
    
    passTextView = [BDLoginTextView createView:CGRectZero leftName:@"txt_pass"];
    [passTextView.messageText setSecureTextEntry:YES];
    passTextView.messageText.delegate = self;
    [textView addSubview:passTextView];
    [passTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(textView);
        make.height.mas_equalTo(HScale*40);
    }];
    [loginBtn racIsEnable:nameTextView.messageText passText:passTextView.messageText];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == nameTextView.messageText)
    {
        [passTextView.messageText becomeFirstResponder];
    }
    if (textField == passTextView.messageText)
    {
        [textField resignFirstResponder];
        [self loginAction];
    }
    return YES;
}

- (void)loginAction
{
    [BDStyle showLoading:@"" rootView:self.view];
    [BDLoginViewModel loginWithUserName:nameTextView.messageText.text password:passTextView.messageText.text complete:^(id obj) {
        [BDStyle handlerError:obj currentVC:self loginHandler:^{
            if (self.isPresent)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_orderChange object:self];
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.loginHandler)
                    {
                        self.loginHandler();
                    }
                }];
            }
            else
            {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                BDTabBarViewController *tab = [[BDTabBarViewController alloc]init];
                window.rootViewController = tab;
            }
            
        }];
    }];
    

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
