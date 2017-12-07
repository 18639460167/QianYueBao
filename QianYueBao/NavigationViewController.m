//
//  NavigationViewController.m
//  QianHongXian
//
//  Created by tenpastnine-ios-dev on 16/5/16.
//  Copyright © 2016年 coolZ. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#fc6c72"];
    self.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    NSDictionary *attributes = @{NSFontAttributeName:FONTSIZE(18/WScale),NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationBar setTitleTextAttributes:attributes];
    [[UIBarButtonItem appearanceWhenContainedIn:NavigationViewController.class, nil] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    __weak NavigationViewController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        CGFloat width = [BDStyle getWidthWithTitle:LS(@"BACK") font:16/WScale]+20;
        if (width<80)
        {
            width = 80;
        }
        BDBackButton *backButton = [BDBackButton button:CGRectMake(0, 0, width, 44)];
        [backButton addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        [viewController.navigationItem setLeftBarButtonItem:backItem];
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    
    [super pushViewController:viewController animated:animated];
}

- (void)btnBackClicked:(id)sender
{
    [self popViewControllerAnimated:YES];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = YES;
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
