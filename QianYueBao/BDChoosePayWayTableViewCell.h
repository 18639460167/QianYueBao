//
//  BDChoosePayWayTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/4/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BDPayWayView;
@class BDPayTagView;

@interface BDChoosePayWayTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *lineImage;

@property (nonatomic, strong) NSMutableArray *chooseTagArray;

@property (nonatomic, copy) noParameterBlock cellHandler;

@property (nonatomic, copy) BDHandler payWayHandler;

@property (nonatomic, strong) BDPayWayView *payWayView;

@property (nonatomic, strong) BDPayTagView *tagWayView;

- (void)bindData:(NSArray *)tagArray isHide:(BOOL)isHide isFirst:(BOOL)isFrist;

@end
