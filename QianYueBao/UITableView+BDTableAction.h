//
//  UITableView+BDTableAction.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (BDTableAction)

/**
 *  创建tableview
 */
+ (UITableView *)createTableview:(UITableViewStyle)style fatherView:(id)vc;

+ (UITableView *)createLineTableView:(UITableViewStyle)style fatherView:(id)vc;

- (void)registerCell:(Class)className;

- (void)reloadIndex:(NSInteger)section row:(NSInteger)row;

/**
 *  刷新
 */
- (void)setTableviewFootAction:(SEL)action target:(id)target;

- (void)setTableviewHeardAction:(SEL)action target:(id)target;


@end
