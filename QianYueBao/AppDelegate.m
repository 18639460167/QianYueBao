//
//  AppDelegate.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/24.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:2];
    
    [[IQKeyboardManager sharedManager]setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    UIApplication *myApplication = [UIApplication sharedApplication];
    [myApplication setStatusBarHidden:NO];
    [myApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self showMainVC];
//    BDTabBarViewController *tab = [[BDTabBarViewController alloc]init];
//    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    [BDWelcomeView showWelcomeView:nil];
    return YES;
}
- (void)showMainVC
{
    if (![READ_SHOP_SIGN(AccessToken) isEqualToString:@""])
    {
        BDTabBarViewController *tab = [[BDTabBarViewController alloc]init];
        self.window.rootViewController = tab;
    }
    else
    {
        BDLoginViewController *loginVC = [[BDLoginViewController alloc]init];
        NavigationViewController *nav = [[NavigationViewController alloc]initWithRootViewController:loginVC];
        nav.modalPresentationStyle = UIModalPresentationCustom;
        self.window.rootViewController = nav;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
