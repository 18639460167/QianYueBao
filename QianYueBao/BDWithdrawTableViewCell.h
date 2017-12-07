//
//  BDWithdrawTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/4/1.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BDSignFinishViewController;
@class BDSettleMentModel;
@interface BDWithdrawTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *monthLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *moneyLbl;
@property (nonatomic, strong) UIImageView *statusImage;

@property (nonatomic, strong) BDSettleMentModel *settleModel;

- (void)cellAction:(BDSignFinishViewController *)vc;
@end
