//
//  BDLocationTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/4/13.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationButton : UIButton

+ (instancetype)createButton:(UIView*)fatherView;

@end

@interface BDLocationTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *locationText;
@property (nonatomic, strong) UITextField *addressText;

@property (nonatomic, strong) UIViewController *vc;

@property (nonatomic, copy) void (^getAddress)(NSString *longitude,NSString*latitue);

@end
