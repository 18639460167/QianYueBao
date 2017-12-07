//
//  BDPopOverMenu.h
//  QianYueBao
//
//  Created by Black on 17/4/14.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BDPopOverMenuDoneBlock)(NSInteger selectIndex);

typedef void (^BDPopOverMenuDismissBlock)();

@interface BDPopOverMenuCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;

- (void)bindData:(NSString *)title;

@end

@interface BDPopOverMenuView : UIControl

@end

#pragma mark -BDPopOverMenu
@interface BDPopOverMenu : NSObject


/**
 *  show method with sender without images
 *
 *  @param sender        sender
 *  @param currentIndex  当前选中索引
 *  @param menuArray
 *  @param doneBlock     选中回调
 *  @param dissmissBlock 消失回调
 */
+ (void)showForSender:(UIView *)sender
            withIndex:(NSInteger)currentIndex
             withMenu:(NSArray<NSString*>*)menuArray
            doneBlock:(BDPopOverMenuDoneBlock)doneBlock
        dissmissBlock:(BDPopOverMenuDismissBlock)dissmissBlock;


@end
