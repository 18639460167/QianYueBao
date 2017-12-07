//
//  BDSliderView.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/6.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^sliderBlock)(NSInteger index);

@interface BDSliderView : UIView

- (instancetype)initWithFrame:(CGRect)frame WithViewControllers:(NSArray *)viewControllers titleArray:(NSArray *)titleArray complete:(sliderBlock)complete;

//+ (void)createView:(UIViewController *)fVC;



@end
