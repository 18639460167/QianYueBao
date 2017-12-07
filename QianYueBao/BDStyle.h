//
//  BDStyle.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/24.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AlertViewButtonClickedHandler)(UIView *alertView, NSInteger buttonIndex);

@interface ActionSheet : UIActionSheet <UIActionSheetDelegate>
{
}

- (id)initWithTitle:(NSString *)title buttonClickHandler:(AlertViewButtonClickedHandler)handler cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, copy) AlertViewButtonClickedHandler buttonClickedHandler;

@end

typedef void (^noParameterBlock)(void);

typedef void (^BDHandler)(id value);

@interface BDStyle : NSObject

/**
 *  宽度固定，lable自适应高度
 *
 *  @param width lable宽度
 *  @param title 文本
 *  @param font  字体大小
 *
 *  @return 文本高度
 */
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(CGFloat)font;

/**
 *  根据文本，lable宽度自适应
 *
 *  @param title 文本
 *  @param font  字体大小
 *
 *  @return 文本宽度
 */
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(CGFloat)font;


+ (UIImage *)getImageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIView *)createView:(UIColor *)bgColor;

+ (void)setRigthBtnInVC:(UIViewController *)vc messge:(NSString *)message action:(void (^)(void))action;

+ (CGFloat)getTagViewHeightArrcount:(NSInteger)arrCount lineTagCount:(NSInteger)count;

+ (CGFloat)getPayTagHeight:(NSArray *)tagArray;

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;

/**
 *  咨询热线
 *
 *  @param currentView 当前视图
 */
+ (void)BDTelPhone:(UIView *)currentView;


#pragma mark - 加载loading
+ (void)showLoading:(NSString *)message;

+ (void)showLoading:(NSString *)message rootView:(UIView *)rootView;

+ (void)hideLoading;

+ (void)handlerError:(NSString *)errorMessage currentVC:(UIViewController *)vc loginHandler:(noParameterBlock)handler;

+ (void)handlerDataError:(NSString *)errorMessage currentVC:(UIViewController *)vc handler:(noParameterBlock)handler;

+ (void)showLoading:(NSString *)message time:(NSInteger)delay;
+ (void)showLoading:(NSString *)message time:(NSInteger)delay currentView:(UIView *)currentView;

+ (void)showLoading:(NSString *)message currentView:(UIView *)currentView handler:(noParameterBlock)handler;
@end
