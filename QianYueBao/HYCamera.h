//
//  HYCamera.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYCamera : NSObject

@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIImage *photoImage;

@end
