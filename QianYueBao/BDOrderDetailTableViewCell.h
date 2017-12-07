//
//  BDOrderDetailTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/5/23.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDOrderDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *messageLbl;

- (void)bindData:(NSString *)title message:(NSString *)message;

@end
