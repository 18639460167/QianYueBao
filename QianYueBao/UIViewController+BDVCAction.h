//
//  UIViewController+BDVCAction.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/27.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BDOwnerModel;

@interface UIViewController (BDVCAction)

- (void)pushAction:(UIViewController *)vc;

- (void)presentSearchView;

- (void)popSelectOwner:(BDOwnerModel *)ownermodel type:(NSInteger)number;

- (void)presentLoginView:(noParameterBlock)loginHandler;


- (UIImageView *)findHairlineImageViewUnder:(UIView *)view;

- (void)setBackButton:(noParameterBlock)handler;


/**
 *  通知滑动
 *
 *  @param message 提示信息
 *  @param style   滚动索引
 */
- (void)scrollviewNotifice:(NSString *)message style:(NSString *)style;


@end
