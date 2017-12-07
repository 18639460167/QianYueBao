//
//  BDTableHeardView.h
//  QianYueBao
//
//  Created by Black on 17/4/5.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BDTabHeardButton;
@interface BDAddOwnerView : UIView


+ (instancetype)createOwnerView:(CGFloat)height title:(NSString *)title handler:(noParameterBlock)complete;
/**
 *  是否有店主信息
 */
@property (nonatomic, assign) BOOL isDelete;

@property (nonatomic, strong) UIView *deleteView;

@end

#pragma mark - 是否展开
@interface BDHeardView : UIView

+ (instancetype)createView:(CGFloat)height title:(NSString *)title handler:(noParameterBlock)complete;

@property (nonatomic, strong) BDTabHeardButton *heardBtn;

@end

@interface BDTableHeardView : UIView

+ (instancetype)createView:(UIView *)fatherView title:(NSString *)title;

@end

#pragma mark - 排行头部
@interface BDChartHeardView:UIView

+ (void)createHeardView:(UIView *)fatherView;

@end
