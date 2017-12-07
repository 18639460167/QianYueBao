//
//  BDPageViewController.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDPageViewController.h"

@interface BDPageViewController ()
{
    
    UIViewController *parentViewController;
}

@end

@implementation BDPageViewController
@synthesize isInitLoadData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WHITE_COLOR;
}

- (instancetype)initViewController:(UIViewController *)parentVC
{
    if (parentVC && (self = [super init]))
    {
        parentViewController = parentVC;
    }
    return self;
}

- (void)initLoadData {
     [self loadData];
//    if (!isInitLoadData && [self isViewLoaded])
//    {
//        isInitLoadData = YES;
//        [self loadData];
//    }
}

- (UIViewController *)getParentViewController {
    return parentViewController;
}

- (void)loadData {
    
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
