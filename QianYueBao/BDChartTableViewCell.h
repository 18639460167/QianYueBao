//
//  BDChartTableViewCell.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BDTransRankModel;

@interface BDChartTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *rankLbl;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *moneyLbl;

- (void)bindData:(NSInteger)indexRow modle:(BDTransRankModel *)model;
@end
