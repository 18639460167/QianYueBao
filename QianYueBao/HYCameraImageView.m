//
//  HYCameraImageView.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYCameraImageView.h"
#import "UIView+HYExtension.h"
#import "UIImage+HYPhotoLib.m"

@interface HYCameraImageView()

@property (nonatomic, strong) UIImageView *deleBjView;

@end
@implementation HYCameraImageView

- (UIImageView*)deleBjView
{
    if (!_deleBjView)
    {
        _deleBjView = [[UIImageView alloc]init];
        _deleBjView.image = [UIImage ml_imageFormBundleNamed:@"X"];
        _deleBjView.hy_width = 25;
        _deleBjView.hy_height = 25;
        _deleBjView.hidden = YES;
        _deleBjView.hy_x = 50;
        _deleBjView.hy_y = 3;
        _deleBjView.userInteractionEnabled = YES;
        [_deleBjView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleImage:)]];
        [self addSubview:_deleBjView];
    }
    return _deleBjView;
}

- (void)setEdit:(BOOL)edit
{
    self.deleBjView.hidden = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - 删除照片
- (void)deleImage:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(deleteImageView:)])
    {
        [self.delegate deleteImageView:self];
    }
}

@end
