//
//  BDOrderTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/4/19.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BDTransactionModel;
@interface BDOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *monthLbl;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *moneyLbl;
@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) UILabel *dishLbl;

@property (nonatomic, strong) BDTransactionModel *model;

- (void)binData:(BDTransactionModel *)bModel title:(NSString *)title;

- (void)cellAction:(BDSuperViewController *)vc title:(NSString *)title;

@end
