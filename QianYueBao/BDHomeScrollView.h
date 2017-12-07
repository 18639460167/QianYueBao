//
//  BDHomeScrollView.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDHomeScrollView : UIView

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) noParameterBlock complete;
@property (nonatomic, copy) noParameterBlock checkLoadData;
@property (nonatomic, copy) noParameterBlock checkLoadMore;

+ (instancetype)crateView:(UIViewController *)vc;

@end
