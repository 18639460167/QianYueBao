//
//  BDChooseHeardView.h
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDChooseHeardView : UIView

@property (nonatomic, strong) UILabel *titleLbl;

+ (instancetype)createHeardView:(CGRect)frame;

- (void)bindData:(NSString *)normalTile titleArray:(NSArray *)titleArray;

- (void)bindData:(NSString *)normalTitle model:(NSString *)name;

@end
