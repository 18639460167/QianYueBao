//
//  BDContractChangeTableViewCell.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/30.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BDContractModel;
@class BDSignFinishViewController;

@interface BDContractChangeTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) UIImageView *statusImage;

@property (nonatomic, strong) BDContractModel *contractModel;

- (void)cellAction:(BDSignFinishViewController *)vc;

@end
