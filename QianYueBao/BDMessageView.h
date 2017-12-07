//
//  BDMessageView.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/27.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDMessageView : UIView

@property (nonatomic, strong) UILabel *messageLbl;

@property (nonatomic, copy) NSString *message;

+ (instancetype)createView:(NSString *)title;
@end
