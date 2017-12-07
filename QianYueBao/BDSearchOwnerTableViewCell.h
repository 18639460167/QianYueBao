//
//  BDSearchOwnerTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/5/8.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BDOwnerModel;

@interface BDSearchOwnerTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *accountNameLbl;
@property (nonatomic, strong) UILabel *accountLbl;
@property (nonatomic, strong) BDOwnerModel *ownerModel;

- (void)cellAction:(BDSuperViewController *)vc;


@end
