//
//  BDOrderStatusTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/5/23.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDTransactionModel.h"

@interface BDOrderStatusTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *statusLbl;

- (void)bindData:(BDTranscationStatus )status;

@end
