//
//  BDBackButton.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/24.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDNavigationRightButton : UIButton

+ (void)createButton:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName isSame:(BOOL)isSame action:(void(^)(void))action;

+ (instancetype)createBtnTitle:(NSString *)title imageName:(NSString *)imageName isSame:(BOOL)isSame action:(void(^)(void))action;


@end

@interface BDSignButton : UIButton

+ (instancetype)button:(CGRect)frame;
@end

@interface BDBackButton : UIButton

+ (instancetype)button:(CGRect)frame;

@end

@interface BDTabHeardButton : UIView

@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong) UIImageView *arrorImage;
@property (nonatomic, strong) UILabel *messageLbl;

+ (instancetype)creatHeardBtn:(NSString *)title fatherView:(UIView *)fatherView;

@end

