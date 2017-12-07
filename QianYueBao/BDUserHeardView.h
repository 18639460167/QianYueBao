//
//  BDUserHeardView.h
//  QianYueBao
//
//  Created by Black on 17/4/19.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDUserHeardView : UIView

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UIViewController *currentVC;
+ (instancetype)crateHeardView:(UIViewController *)vc;

@end
