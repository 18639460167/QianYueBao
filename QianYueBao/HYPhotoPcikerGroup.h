//
//  HYPhotoPcikerGroup.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface HYPhotoPcikerGroup : NSObject

/**
 *  组名字
 */
@property (nonatomic, copy) NSString *groupName;

/**
 *  缩略图
 */
@property (nonatomic, strong) UIImage *thumbImage;

/**
 *  组里面的图片个数
 */
@property (nonatomic, assign) NSInteger assetsCount;

/**
 *  类型：Save Photos
 */
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) ALAssetsGroup *group;

@property (nonatomic, assign) BOOL isVideo;

@end
