//
//  BDTabBarViewController.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/24.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDTabBarViewController.h"

@interface BDTabBarViewController ()

@end

@implementation BDTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildVCs];
    BDTabBar *tabBar = [[BDTabBar alloc]init];
    tabBar.signAction = ^(){
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        BDSignViewController *loginVC = [[BDSignViewController alloc]init];
        UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        navigationVC.modalPresentationStyle = UIModalPresentationCustom;
        [window.rootViewController presentViewController:navigationVC animated:YES completion:nil];
//        BDSignViewController *vc = [[BDSignViewController alloc]init];
//        NavigationViewController *nvc = [[NavigationViewController alloc]initWithRootViewController:vc];
//        [wSelf presentViewController:nvc animated:YES completion:nil];
    };
    [self setValue:tabBar forKey:@"tabBar"];
}

- (void)addChildVCs
{
    BDHomeViewController *homeVC = [[BDHomeViewController alloc]init];
    [self addChildViewController:homeVC title:LS(@"Home") image:@"home_tab" selectImage:@"home_tab_sel"];
    
    BDSettingViewController *setVC = [[BDSettingViewController alloc]init];
    [self addChildViewController:setVC title:LS(@"User") image:@"set_tab" selectImage:@"set_tab_sel"];
    
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)normalImage selectImage:(NSString *)selImage
{
    childController.title = title;
    childController.view.backgroundColor = [UIColor whiteColor];
    
    childController.tabBarItem.image = [UIImage imageNamed:normalImage];
    UIImage *selectImage = [UIImage imageNamed:selImage];
    if (OS_ISVERSION7)
    {
        //  声明这张图用原图
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = selectImage;
    
    NavigationViewController *nvc = [[NavigationViewController alloc]initWithRootViewController:childController];
    [childController.navigationController.navigationBar setHidden:YES];
    [self addChildViewController:nvc];
}

+ (void)initialize
{
    //设置底部tabbar的主题样式
    UITabBarItem *appearance = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor nineSixColor],NSFontAttributeName:FONTSIZE(11/WScale)} forState:UIControlStateNormal];
    
    [appearance setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor navigationColor],NSFontAttributeName:FONTSIZE(11/WScale)} forState:UIControlStateSelected];
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
