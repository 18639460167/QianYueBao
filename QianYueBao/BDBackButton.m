//
//  BDBackButton.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/24.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDBackButton.h"

@implementation BDNavigationRightButton

+ (void)createButton:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName isSame:(BOOL)isSame action:(void (^)(void))action
{
    CGFloat width = [BDStyle getWidthWithTitle:title font:12];
    if (width<WScale*50)
    {
        width = WScale*50;
    }
    BDNavigationRightButton *button = [[BDNavigationRightButton alloc]initWithFrame:CGRectMake(0, 0, width+WScale*5, HScale*27+WScale*14) title:title imageName:imageName action:action isSame:isSame];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.rightBarButtonItem = rightBtnItem;
}

+ (instancetype)createBtnTitle:(NSString *)title imageName:(NSString *)imageName isSame:(BOOL)isSame action:(void (^)(void))action
{
    CGFloat width = [BDStyle getWidthWithTitle:title font:12];
    if (width<WScale*50)
    {
        width = WScale*50;
    }
    BDNavigationRightButton *button = [[BDNavigationRightButton alloc]initWithFrame:CGRectMake(0, 0, width+WScale*5, HScale*27+WScale*14) title:title imageName:imageName action:action isSame:isSame];
    return button;
}


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName action:(void (^)(void))action isSame:(BOOL)isSame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *logoImage = [UIImageView createImage:imageName];
        [self addSubview:logoImage];
        [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            if (isSame)
            {
                make.size.mas_equalTo(CGSizeMake(HScale*29, HScale*25));
            }
            else
            {
               make.size.mas_equalTo(CGSizeMake(HScale*20, HScale*25));
            }
            make.top.equalTo(self);
            make.centerX.mas_equalTo(self.mas_centerX).offset(2);
        }];
        
        UILabel *titleLlb= [UILabel createLbl:title font:12 textColor:WHITE_COLOR];
        [self addSubview:titleLlb];
        [titleLlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(logoImage.mas_bottom).offset(HScale*4);
        }];
        
        [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (action)
            {
                action();
            }
        }];
        
    }
    return self;
}

@end

@implementation BDSignButton

+ (instancetype)button:(CGRect)frame
{
    BDSignButton *button = [[BDSignButton alloc]initWithFrame:frame];
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *signImage = [UIImageView createImage:@"sign_tab"];
        [self addSubview:signImage];
        [signImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self);
        }];
    }
    return self;
}

@end

@implementation BDBackButton

+ (instancetype)button:(CGRect)frame
{
    BDBackButton *backButton = [[BDBackButton alloc]initWithFrame:frame];
    return backButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *imageview= [[UIImageView alloc]initWithFrame:CGRectZero];
        imageview.image = IMAGE_NAME(@"nav_back");
        [self addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(WScale*13, WScale*19));
        }];
        
        UILabel *backLbl = [UILabel createNoramlLbl:LS(@"BACK") font:16 textColor:WHITE_COLOR];
        [self addSubview:backLbl];
        [backLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(imageview.mas_centerY);
            make.left.equalTo(imageview.mas_right).offset(WScale*5);
            make.top.equalTo(self);
            make.right.equalTo(self);
        }];

    }
    return self;
}

@end

#pragma mark -heardBtn

@implementation BDTabHeardButton
@synthesize arrorImage;
@synthesize messageLbl;

+ (instancetype)creatHeardBtn:(NSString *)title fatherView:(UIView *)fatherView
{
    BDTabHeardButton *tabBtn = [[BDTabHeardButton alloc]initWithFrame:CGRectZero creatHeardBtn:title];
    [fatherView addSubview:tabBtn];
    [tabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(fatherView);
        make.bottom.equalTo(fatherView).offset(HScale*-10);
        make.height.mas_equalTo(HScale*25);
    }];
    return tabBtn;
}

- (instancetype)initWithFrame:(CGRect)frame creatHeardBtn:(NSString *)title
{
    if (self = [super initWithFrame:frame])
    {
        CGFloat width = [BDStyle getWidthWithTitle:title font:15];
        
        UIView *leftView = [BDStyle createView:[UIColor subjectColor]];
        [self addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(width+BDHeight(10));
        }];
        
        UIView *rigthView=  [BDStyle createView:[UIColor subjectColor]];
        rigthView.layer.cornerRadius = BDHeight(12.5);
        rigthView.layer.masksToBounds = YES;
        [leftView addSubview:rigthView];
        [rigthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(leftView).offset(BDHeight(12.5));
            make.size.mas_equalTo(CGSizeMake(BDHeight(25), BDHeight(25)));
            make.top.equalTo(leftView);
        }];
        
        
        UILabel *titleLbl  = [UILabel createLbl:title font:15 textColor:WHITE_COLOR];
        titleLbl.textAlignment = NSTextAlignmentRight;
        [leftView addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(leftView);
            make.right.equalTo(leftView).offset(BDHeight(-2.5));
        }];
        
        arrorImage = [UIImageView createImage:@"arrorw_close"];
        [self addSubview:arrorImage];
        [arrorImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(WScale*-15);
            make.size.mas_equalTo(CGSizeMake(WScale*18, WScale*11));
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        messageLbl = [UILabel createRightLbl:LS(@"Close") font:12 textColor:[UIColor colorWithHexString:@"#fd655b"]];
        [self addSubview:messageLbl];
        [messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(arrorImage.mas_left).offset(-3);
            make.left.equalTo(leftView.mas_right).offset(WScale*10);
        }];
    }
    return self;
}

- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    if (_isOpen)
    {
        arrorImage.image = IMAGE_NAME(@"arrorw_open");
        messageLbl.text = LS(@"Open");
    }
    else
    {
        arrorImage.image = IMAGE_NAME(@"arrorw_close");
        messageLbl.text = LS(@"Close");
    }
}

@end
