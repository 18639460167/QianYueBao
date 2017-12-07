//
//  BDMessageTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/4/5.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDMessageTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UITextField *messageText;

@property (nonatomic, copy) BDHandler textHandler;

- (void)bindData:(NSString *)title message:(NSString *)message;
@end
