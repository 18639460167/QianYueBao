//
//  HYPhotoPickerBrowserPhotoView.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerBrowserPhotoView.h"

@implementation HYPhotoPickerBrowserPhotoView

- (id)init
{
    if (self = [super init])
    {
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - 监听手势
- (void)addGesTure
{
    // 双击放大
    UITapGestureRecognizer *scaleBigTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    scaleBigTap.numberOfTapsRequired = 2;
    scaleBigTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:scaleBigTap];
    
    // 单击缩小
    // 单击缩小
    UITapGestureRecognizer *disMissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    disMissTap.numberOfTapsRequired = 1;
    disMissTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:disMissTap];
    // 只能有一个手势存在
    [disMissTap requireGestureRecognizerToFail:scaleBigTap];
}

- (void)handleSingleTap:(UITouch *)touch
{
    if ([self.tapDelegate respondsToSelector:@selector(view:singleTapDetected:)])
    {
        [self.tapDelegate view:self singleTapDetected:touch];
    }
}

- (void)handleDoubleTap:(UITouch *)touch
{
    if ([self.tapDelegate respondsToSelector:@selector(view:doubleTapDetected:)])
    {
        [self.tapDelegate view:self doubleTapDetected:touch];
    }
}



@end
