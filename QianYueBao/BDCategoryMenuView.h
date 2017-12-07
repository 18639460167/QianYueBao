//
//  BDCategoryMenuView.h
//  QianYueBao
//
//  Created by Black on 17/5/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDCategoryView : UIView

@property (nonatomic, copy) noParameterBlock complete;

+ (instancetype)createViewFrame:(CGRect)frame title:(NSString *)title;

@end

@interface BDCategoryMenuView : UIView

@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, copy) void(^backIndexHandler)(NSInteger tag) ;

+ (instancetype)createView:(UIView *)fatherView;

- (void)reloadData:(NSArray *)titleArray;
@end
