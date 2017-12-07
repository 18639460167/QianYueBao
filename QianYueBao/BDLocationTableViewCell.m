//
//  BDLocationTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/4/13.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDLocationTableViewCell.h"

@implementation LocationButton

+ (instancetype)createButton:(UIView *)fatherView
{
    LocationButton *button = [[LocationButton alloc]initWithFrame:CGRectZero];
    [fatherView addSubview:button];
    return button;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame])
    {
        UIImageView *locaImage = [UIImageView createImage:@"location"];
        [self addSubview:locaImage];
        [locaImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(HScale*22, HScale*32));
        }];
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [self addTarget:self action:@selector(scaleToSmall)
   forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault)
   forControlEvents:UIControlEventTouchDragExit];
}

- (void)scaleToSmall
{
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.3;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.values = @[[NSNumber numberWithFloat:0.8]];
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.layer removeAllAnimations];
    [self.layer addAnimation:scaleAnimation forKey:@"transform.rotate"];
}

- (void)scaleToDefault
{
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.3;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.values = @[[NSNumber numberWithFloat:1.0]];
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.layer removeAllAnimations];
    [self.layer addAnimation:scaleAnimation forKey:@"transform.rotate"];
}

- (void)scaleAnimation
{
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.3;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.3],[NSNumber numberWithFloat:1.0]];
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.layer removeAllAnimations];
    [self.layer addAnimation:scaleAnimation forKey:@"transform.rotate"];
}

@end

@implementation BDLocationTableViewCell
@synthesize locationText;
@synthesize addressText;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        UIView *topView = [BDStyle createView:WHITE_COLOR];
//        [self addSubview:topView];
//        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.left.right.equalTo(self);
//        }];
        
        UILabel *titleLbl = [UILabel createNoramlLbl:LS(@"Latitude_Longitude") font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(WScale*15);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo([BDStyle getWidthWithTitle:LS(@"Latitude_Longitude") font:15]);
        }];
        
        LocationButton *locationBtn = [LocationButton createButton:self];
        [locationBtn addTarget:self action:@selector(locaAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:locationBtn];
        [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(HScale*30, HScale*40));
            make.right.equalTo(self).offset(WScale*-15);
        }];
        
        locationText = [UITextField createText:@"" font:15 textColor:[UIColor threeTwoColor]];
        locationText.enabled = NO;
        locationText.delegate = self;
        [self addSubview:locationText];
        [locationText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(titleLbl.mas_right).offset(WScale*3);
            make.right.equalTo(locationBtn.mas_left).offset(WScale*-8);
        }];
        
        UIImageView *lineImage = [UIImageView createImageWithColor:[UIColor cEightColor]];
        [self addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self).offset(WScale*15);
        }];
    }
    return self;
}

- (void)locaAction
{
    if (self.vc)
    {
        [BDStyle showLoading:LS(@"Locationing") rootView:self.vc.view];
        [BDLocationModel getCurrentAddress:^(NSString *address, CLLocation *location, BOOL isSuccess) {
            NSString *str = LS(@"Location_Fail");
            if (isSuccess)
            {
                str = @"";
                locationText.text = [NSString stringWithFormat:@"{%f,%f}",location.coordinate.latitude,location.coordinate.longitude];
                if (self.getAddress)
                {
                    self.getAddress([NSString stringWithFormat:@"%f",location.coordinate.latitude],[NSString stringWithFormat:@"%f",location.coordinate.longitude]);
                }
            }
            [BDStyle handlerDataError:str currentVC:self.vc handler:nil];
        }];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
