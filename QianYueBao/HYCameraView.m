//
//  HYCameraView.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYCameraView.h"
#define HYCameraViewWidth 60

@interface HYCameraView ()

@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) BOOL isPlayerEnd;

@end

@implementation HYCameraView

- (CADisplayLink *)link
{
    if (!_link)
    {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshView:)];
    }
    return _link;
}

- (void)refreshView:(CADisplayLink *)link
{
    [self setNeedsDisplay];
    self.time ++;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isPlayerEnd)
    {
        return;
    }
    self.isPlayerEnd = YES;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    self.point = point;
    
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    if ([self.delegate respondsToSelector:@selector(cameraDidSlected:)])
    {
        [self.delegate cameraDidSlected:self];
    }
}

/**
 *  重新绘制
 *
 */
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.isPlayerEnd)
    {
        CGFloat rectValue = HYCameraViewWidth - self.time%HYCameraViewWidth;
        
        CGRect rectangle  =CGRectMake(self.point.x-rectValue/2.0, self.point.y-rectValue/2.0, rectValue, rectValue);
        
        // 获得上下文句柄
        CGContextRef currentContext = UIGraphicsGetCurrentContext()
        ;
        if (rectValue<=30)
        {
            self.isPlayerEnd = NO;
            [self.link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            self.link = nil;
            self.time = 0;
            CGContextClearRect(currentContext, rectangle);
        }
        else
        {
            // 创建图形路径句柄
            CGMutablePathRef path = CGPathCreateMutable();
            // 设置矩形边界
            CGPathAddRect(path, NULL, rectangle);
            // 添加路径到上下文中
            CGContextAddPath(currentContext, path);
            
            // 填充颜色
            [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:0] setFill];
            // 设置画笔颜色
            [[UIColor yellowColor] setStroke];
            // 设置边框线条宽度
            CGContextSetLineWidth(currentContext, 1.0f);
            // 画图
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            /**
             *  释放路径
             */
            CGPathRelease(path);
        }
    }
}
@end
