//
//  BDChooseMessageTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/4/14.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BDSignCategoryModel;

@interface BDMenuButton : UIButton

@property (nonatomic, strong) UILabel *messageLbl;

+ (instancetype)createButton:(UIView *)fatherView;

@end

@interface BDChooseMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *messageLbl;
@property (nonatomic, strong) BDMenuButton *menuBtn;
@property (nonatomic, strong) BDSignCategoryModel *model;

@property (nonatomic, copy) BDHandler complete;

- (void)bindData:(NSString *)title model:(BDSignCategoryModel *)model;

- (void)bindData:(NSString *)title message:(NSString *)message;

- (void)cellAction:(BDSuperViewController *)currentVC;

@end
