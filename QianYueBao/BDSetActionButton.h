//
//  BDSetActionButton.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDSetActionButton : UIButton

+ (instancetype)createButton:(NSString *)title imageName:(NSString *)imageName isSame:(BOOL)isSame;

@end
