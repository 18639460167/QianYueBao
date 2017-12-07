//
//  BDTradeTableViewCell.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BDSignMessageModel.h"
#import "BDSignListModel.h"

@interface BDLabelView : UIView

@property (nonatomic, assign) CGFloat labelWidth;
+ (instancetype)createView;

- (CGFloat)reloadData:(NSArray *)labelArray tradeStatus:(TradeStatus)status;

@end

@interface BDTradeTableViewCell : UITableViewCell

@property (nonatomic, strong) BDSignListModel *signModel;

- (void)cellAction:(UIViewController *)vc;

@end
