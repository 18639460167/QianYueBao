//
//  BDSelectCategoryTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/5/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDSelectCategoryTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;

- (void)bindData:(NSString *)title;
@end
