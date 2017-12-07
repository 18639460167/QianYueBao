//
//  BDMoreChooseTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDMoreChooseTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *selectImage;

- (void)bindData:(id)model;

@end
