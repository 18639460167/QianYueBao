//
//  BDSuperViewController.h
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDCustomNavitionView.h"
@class BDSignDetailModel;
@interface BDSuperViewController : UIViewController

@property (nonatomic, strong) BDCustomNavitionView *navBarView;

@property (nonatomic, strong) BDSignDetailModel *detailModel;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, copy) BDHandler ownerBackHandler;

/**
 *  那个vcpush 1，2，3
 */
@property (nonatomic, assign) NSInteger pushNumber;

/*!
 *  设置是否关闭侧滑手势
 */
@property (nonatomic,assign,readwrite)BOOL interactivePopGestureState;

@property (nonatomic, assign) CGFloat distanceTop; // 距离头部


@end

@interface BDSuperViewController(NavVarStyle)

- (void)LoadNavigation:(UIButton *)leftBtn
              navStyle:(BDNavitionStyle)style
                 title:(NSString *)title
         didBackAction:(noParameterBlock)handler;

- (void)loadHaveLeftBtn:(BOOL)isShowRight
             navStyle:(BDNavitionStyle)style
                title:(NSString *)title
        didBackAction:(noParameterBlock)handler;


@end
