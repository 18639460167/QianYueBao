//
//  HYPhotoPickerImageView.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerImageView.h"
#import "UIImage+HYPhotoLib.h"

@interface HYPhotoPickerImageView()

@property (nonatomic , strong) UIView *maskView;
@property (nonatomic , strong) UIButton *tickImageView;
@property (nonatomic , strong) UIImageView *videoView;

@end

@implementation HYPhotoPickerImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (UIView *)maskView
{
    if (!_maskView)
    {
        _maskView = [[UIView alloc] init];
        _maskView.frame = self.bounds;
        _maskView.backgroundColor = [UIColor whiteColor];
        _maskView.alpha = 0.5;
        [self addSubview:_maskView];
    }
    return _maskView;
}

- (UIImageView *)videoView{
    if (!_videoView)
    {
        _videoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height - 40, 30, 30)];
        _videoView.image = [UIImage ml_imageFormBundleNamed:@"video"];
        _videoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_videoView];
    }
    return _videoView;
}

- (UIButton *)tickImageView{
    if (!_tickImageView)
    {
        _tickImageView = [[UIButton alloc] init];
        _tickImageView.frame = CGRectMake(self.bounds.size.width - 28, 5, 21, 21);
        //        [tickImageView addTarget:self action:@selector(clickTick) forControlEvents:UIControlEventTouchUpInside];
        [_tickImageView setImage:[UIImage ml_imageFormBundleNamed:@"icon_image_no"] forState:UIControlStateNormal];
        [self addSubview:_tickImageView];
    }
    return _tickImageView;
}

- (void)setIsVideoType:(BOOL)isVideoType
{
    _isVideoType = isVideoType;
    self.videoView.hidden = !(isVideoType);
}

- (void)setMaskViewFlag:(BOOL)maskViewFlag
{
    _maskViewFlag = maskViewFlag;
    self.animationRightTick = maskViewFlag;
}

- (void)setMaskViewColor:(UIColor *)maskViewColor
{
    _maskViewColor = maskViewColor;
    self.maskView.backgroundColor = maskViewColor;
}

- (void)setMaskViewAlpha:(CGFloat)maskViewAlpha
{
    _maskViewAlpha = maskViewAlpha;
    self.maskView.alpha = maskViewAlpha;
}

- (void)setAnimationRightTick:(BOOL)animationRightTick
{
    _animationRightTick = animationRightTick;
    if (animationRightTick)
    {
        [self.tickImageView setImage:[UIImage ml_imageFormBundleNamed:@"icon_image_yes"] forState:UIControlStateNormal];
    }
    else
    {
         [self.tickImageView setImage:[UIImage ml_imageFormBundleNamed:@"icon_image_no"] forState:UIControlStateNormal];
    }
    
    if (!self.isClickHaveAnimation)
    {
        return;
    }
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.25;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    if (self.isVideoType)
    {
        [self.videoView.layer removeAllAnimations];
        [self.videoView.layer addAnimation:scaleAnimation forKey:@"transform.rotate"];
    }
    else
    {
        [self.tickImageView.layer removeAllAnimations];
        [self.tickImageView.layer addAnimation:scaleAnimation forKey:@"transform.rotate"];
    }
    
}

@end
