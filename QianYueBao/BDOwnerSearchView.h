//
//  BDOwnerSearchView.h
//  QianYueBao
//
//  Created by Black on 17/5/4.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDOwnerSearchView : UIView<UITextFieldDelegate>

@property (nonatomic, copy) BDHandler handler;

+ (void)createSearchView:(UIViewController *)vc handler:(BDHandler)complete;


@end
