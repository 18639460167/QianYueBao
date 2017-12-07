//
//  BDPageViewController.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BDSignFinishViewController;

@interface BDPageViewController : UIViewController

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) BDSignFinishViewController *finishVC;
@property (nonatomic, assign) BOOL isInitLoadData;

- (instancetype)initViewController:(UIViewController *)parentVC;

- (void)initLoadData;

- (UIViewController *)getParentViewController;

@end
