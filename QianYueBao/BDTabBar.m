//
//  BDTabBar.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/24.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDTabBar.h"
@interface BDTabBar()

@property (nonatomic, strong) BDSignButton *signBtn;
@end

@implementation BDTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        HYWeakSelf;
        self.backgroundColor = WHITE_COLOR;
        self.backgroundImage = [BDStyle imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
        self.shadowImage = [BDStyle imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        lineView.backgroundColor = [UIColor lineColor];
        [self addSubview:lineView];
        
        self.signBtn = [BDSignButton button:CGRectMake(0, 0, 70, 70)];
        [[self.signBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (wSelf.signAction)
            {
                wSelf.signAction();
            }
        }];
        [self addSubview:self.signBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat centerx = self.bounds.size.width*0.5-35;
    CGFloat centery = self.bounds.size.height*0.5;
    
    self.signBtn.frame = CGRectMake(centerx, centery-42, 70, 70);
    CGFloat tabBarItemWidth = SCREEN_WIDTH/3.0;
    
    CGFloat tabBarIndex = 0;
    for (UIView *childItem in self.subviews)
    {
        if ([childItem isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            CGRect rect = childItem.frame;
            rect.size.width = tabBarItemWidth;
            rect.origin.x = tabBarItemWidth*tabBarIndex;
            childItem.frame = rect;
            tabBarIndex++;
            if (tabBarIndex == 1)
            {
                tabBarIndex ++;
            }
        }
    }
}

#pragma mark -触摸位置是否位于圆形按钮控件上

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hidden == NO)
    {
        if ([self touchPointInsideCircle:self.signBtn.center radius:35 targetPoint:point])
        {
            return self.signBtn;
        }
        else
        {
            return [super hitTest:point withEvent:event];
        }
    }
    return [super hitTest:point withEvent:event];
}

- (BOOL)touchPointInsideCircle:(CGPoint)center radius:(CGFloat)radius targetPoint:(CGPoint)point
{
    CGFloat dist = sqrtf((point.x - center.x) * (point.x - center.x) +
                         (point.y - center.y) * (point.y - center.y));
    return (dist <= radius);
}


@end
