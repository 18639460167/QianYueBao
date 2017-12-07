//
//  UIButton+BDButtonSet.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BDSignDetailModel;
@class BDOwnerModel;
@class BDContractModel;
@interface UIButton (BDButtonSet)

+ (instancetype)createBtn:(NSString *)title bgColor:(UIColor *)bgColor titleColor:(UIColor *)titColor font:(CGFloat)font complete:(void(^)(void))handler;

+ (instancetype)createBtn:(NSString *)title bgImage:(NSString *)bgName titleColor:(UIColor *)titColor font:(CGFloat)font complete:(void (^)(void))handler;

+ (instancetype)createBtn:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor complete:(void (^)(void))handler;

+ (instancetype)buttonOnlyImage:(NSString *)imageName fatherView:(UIView *)fatherView action:(noParameterBlock)handler;


/**
 *  按钮是否可点击
 */
- (void)racIsEnable:(UITextField *)nameTxt passText:(UITextField *)passText;

- (void)racIsEnableWithModel:(BDSignDetailModel *)model backColor:(UIColor *)bgColor;

/**
 *  店主信息是否完整
 *
 *  @param mode 店主model
 */
- (void)racIsEnableWithOwner:(BDOwnerModel *)model;

/**
 *  合同信息是否完整
 *
 *  @param model 合同model
 */
- (void)racIsEnableWithContract:(BDContractModel *)model;

/**
 *  基本信息是否完整
 *
 *  @param model 详情model
 */
- (void)racISEnableWithShopBasic:(BDSignDetailModel *)model;
@end
