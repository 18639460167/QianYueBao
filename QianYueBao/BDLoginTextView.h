//
//  BDLoginTextView.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDLoginTextView : UIView

@property (nonatomic, strong) UITextField *messageText;

+ (instancetype)createView:(CGRect)frame leftName:(NSString *)leftName;

@end
