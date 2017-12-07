//
//  BDPayTagView.h
//  QianYueBao
//
//  Created by Black on 17/4/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDTagButton : UIButton

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *titleLbl;

+ (instancetype)createWithFrame:(CGRect)frame title:(NSString *)title;

@end

@interface BDPayTagView : UIView

@property (nonatomic, copy) BDHandler tagComplete;

+ (instancetype)createView:(UIView *)fatherView;

- (void)bindData:(NSArray *)dataArray;

@end
