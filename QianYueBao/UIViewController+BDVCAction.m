//
//  UIViewController+BDVCAction.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/27.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "UIViewController+BDVCAction.h"

@implementation UIViewController (BDVCAction)

- (void)pushAction:(UIViewController *)vc
{
    if (self.navigationController.viewControllers.count>0)
    {
        vc.hidesBottomBarWhenPushed = YES;
    }
//  //  vc.view.backgroundColor = WHITE_COLOR;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)presentSearchView
{
    BDSearchViewController *loginVC = [[BDSearchViewController alloc]init];
    NavigationViewController *navigationVC = [[NavigationViewController alloc] initWithRootViewController:loginVC];
    navigationVC.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:navigationVC animated:YES completion:nil];
}

- (void)popSelectOwner:(BDOwnerModel *)ownermodel type:(NSInteger)number
{
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[BDSignViewController class]] && number == 1)
        {
            BDSignViewController *signVC = (BDSignViewController *)vc;
            if (signVC.ownerBackHandler)
            {
                signVC.ownerBackHandler(ownermodel);
            }
            [self.navigationController popToViewController:signVC animated:YES];
            return;
        }
        if ([vc isKindOfClass:[BDSignDeatilViewController class]] && number == 2)
        {
            BDSignDeatilViewController *detaVC = (BDSignDeatilViewController *)vc;
            if (detaVC.ownerBackHandler)
            {
                detaVC.ownerBackHandler(ownermodel);
            }
            [self.navigationController popToViewController:detaVC animated:YES];
            return;
        }
        if ([vc isKindOfClass:[BDBasisMessageViewController class]] && number == 3)
        {
            BDBasisMessageViewController *detaVC = (BDBasisMessageViewController *)vc;
            if (detaVC.ownerBackHandler)
            {
                detaVC.ownerBackHandler(ownermodel);
            }
            [self.navigationController popToViewController:detaVC animated:YES];
            return;
        }
    }
}

- (void)presentLoginView:(noParameterBlock)loginHandler
{
    BDLoginViewController *loginVC = [[BDLoginViewController alloc]init];
    loginVC.isPresent = YES;
    loginVC.loginHandler = ^(){
        if (loginHandler)
        {
            loginHandler();
        }
    };
    NavigationViewController *navigationVC = [[NavigationViewController alloc] initWithRootViewController:loginVC];
    navigationVC.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:navigationVC animated:YES completion:nil];
    
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews)
    {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView)
        {
            return imageView;
        }
    }
    return nil;
}

#pragma mark - 返回按钮
- (void)setBackButton:(noParameterBlock)handler
{
    CGFloat width = [BDStyle getWidthWithTitle:LS(@"BACK") font:16/WScale]+20;
    if (width<80)
    {
        width = 80;
    }
    BDBackButton *backButton = [BDBackButton button:CGRectMake(0, 0, width, 49)];
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (handler)
        {
            handler();
        }
    }];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma mark - 首页滚动
- (void)scrollviewNotifice:(NSString *)message style:(NSString *)style
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Home_ScrollChange object:nil userInfo:@{@"index":style}];
    [BDStyle showLoading:message currentView:self.view handler:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
@end
