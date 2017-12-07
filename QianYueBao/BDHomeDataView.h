//
//  BDHomeDataView.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDChartsButton : UIButton

+ (instancetype)createButton;

@end

@interface BDSearchButton : UIButton

+ (instancetype)createButton;

@end

@interface BDHomeDataView : UIView

@property (nonatomic, strong) UILabel *unitLbl;
@property (nonatomic, strong) UILabel *numberLbl;
@property (nonatomic, strong) UILabel *moneyLbl;

+ (instancetype)createView:(UIViewController *)vc;

- (void)bindData:(NSString *)number weekSale:(NSString *)sale sign:(NSString *)sign;

@end
