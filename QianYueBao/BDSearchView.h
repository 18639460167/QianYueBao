//
//  BDSearchView.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDSearchView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *messageText;

@property (nonatomic, copy) noParameterBlock handler;

+ (instancetype)createSearchView:(UIViewController*)vc;

@end
