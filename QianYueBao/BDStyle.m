//
//  BDStyle.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/24.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDStyle.h"
#import "AppDelegate.h"
#define ORIGINAL_MAX_WIDTH 640.0f

@implementation ActionSheet

- (id)initWithTitle:(NSString *)title buttonClickHandler:(AlertViewButtonClickedHandler)handler cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super initWithTitle:title==nil?nil:title delegate:self cancelButtonTitle:cancelButtonTitle==nil?nil:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle==nil?nil:destructiveButtonTitle otherButtonTitles:nil])
    {
        if (otherButtonTitles != nil)
        {
            [self addButtonWithTitle:otherButtonTitles];
            va_list args;
            va_start(args, otherButtonTitles);
            NSString *otherButton = va_arg(args, NSString*);
            while (otherButton != nil)
            {
                [self addButtonWithTitle:otherButton];
                otherButton = va_arg(args, NSString*);
            }
            va_end(args);
        }
        
        _buttonClickedHandler = [handler copy];
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_buttonClickedHandler != nil)
    {
        _buttonClickedHandler(self, buttonIndex);
    }
}

@end


@implementation BDStyle

// 自适应高度
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(CGFloat)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = FONTSIZE(font);
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}
// 自适应宽度
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(CGFloat)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = FONTSIZE(font);
    [label sizeToFit];
    return label.frame.size.width;
}


+ (UIView *)createView:(UIColor *)bgColor
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = bgColor;
    return view;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)getImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)setRigthBtnInVC:(UIViewController *)vc messge:(NSString *)message action:(void (^)(void))action
{
    CGFloat width = [BDStyle getWidthWithTitle:message font:16];
    if (width<WScale*66)
    {
        width = WScale*66;
    }
    UIButton *rigthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rigthBtn.frame = CGRectMake(0, 0, width, HScale*18);
    rigthBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [rigthBtn setTitle:message forState:0];
    [rigthBtn setTitleColor:WHITE_COLOR forState:0];
    [rigthBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    rigthBtn.titleLabel.font = FONTSIZE(16);
    [[rigthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (action)
        {
            action();
        }
    }];
    UIBarButtonItem *rigthBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rigthBtn];
    vc.navigationItem.rightBarButtonItem  = rigthBtnItem;
}

+ (CGFloat)getTagViewHeightArrcount:(NSInteger)arrCount lineTagCount:(NSInteger)count;
{
    if (arrCount==0)
    {
        return 0;
    }
//   CGFloat width = (SCREEN_WIDTH-WScale*65)/4;
      CGFloat width = (SCREEN_WIDTH-WScale*70)/3;
    NSInteger col = 0;
    if (arrCount%count==0)
    {
        col = arrCount/count;
    }
    else
    {
        col = arrCount/count+1;
    }
    return (WScale*10+(width+WScale*10)*col);
}

#pragma mark - 获取支付高度

+ (CGFloat)getPayTagHeight:(NSArray *)tagArray
{
    float upX = 0;
    float upY = HScale*5;
    for (int i=0; i<tagArray.count; i++)
    {
        BDPayWayModel *model = tagArray[i];
        float width = HScale*15+WScale*6+[BDStyle getWidthWithTitle:model.title font:14];
        if (width>SCREEN_WIDTH-WScale*30)
        {
            width = SCREEN_WIDTH-WScale*30;
        }
        if (upX>(SCREEN_WIDTH-width))
        {
            upX = 0;
            upY += HScale*35;
        }
        
        upX += width+WScale*15;
    }
    upY += HScale*20;
    return upY+HScale*80;
}

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH)
        return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height)
    {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    }
    else
    {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [BDStyle imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    NSAssert(newImage, @"Fail to clip image.");
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)BDTelPhone:(UIView *)currentView
{
    ActionSheet *sheet = [[ActionSheet alloc] initWithTitle:LS(@"Telephone") buttonClickHandler:^(UIView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            NSURL *phone_url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:88888888"]];
            [[UIApplication sharedApplication] openURL:phone_url];
        }
    } cancelButtonTitle:LS(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:@"88888888",nil];
    [sheet showInView:currentView];
}

#pragma mark - loading

+ (void)showLoading:(NSString *)message
{
    UIView *view = [BDStyle getCurrentView];
    if (view)
    {
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.labelText = message;
    }
}

+ (void)showLoading:(NSString *)message rootView:(UIView *)rootView
{
    if (rootView)
    {
        [MBProgressHUD hideAllHUDsForView:rootView animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:rootView animated:YES];
        hud.labelText = message;
    }
}

+ (void)hideLoading
{
    UIView *view = [BDStyle getCurrentView];
    if (view)
    {
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    }
}

+ (void)handlerError:(NSString *)errorMessage currentVC:(UIViewController *)vc loginHandler:(noParameterBlock)handler
{
    [BDStyle hideLoading];
    if ([errorMessage isEqualToString:NEED_LOGIN])
    {
        if (vc)
        {
            [vc presentLoginView:^{
                if (handler)
                {
                    handler();
                }
            }];
        }
    }
    else
    {
//        UIView *view = [BDStyle getCurrentView];
        if ([errorMessage isEqualToString:REQUEST_SUCCESS])
        {
            if (handler)
            {
                handler();
            }
        }
        else
        {
            if (vc)
            {
                [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabelText = errorMessage;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ErrorInfo_ShowTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:vc.view animated:YES];
                });
            }
        }
    }
}

+ (void)handlerDataError:(NSString *)errorMessage currentVC:(UIViewController *)vc handler:(noParameterBlock)handler
{
    [BDStyle hideLoading];
    [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
    if ([errorMessage isEqualToString:NEED_LOGIN])
    {
        if (vc)
        {
            
            [vc presentLoginView:^{
                if ( handler)
                {
                    handler();
                }
                
            }];
        }
        else
        {
            UIView *view = [BDStyle getCurrentView];
            [MBProgressHUD hideAllHUDsForView:view animated:YES];
        }
    }
    else
    {
        if (vc)
        {
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            if ((![errorMessage isEqualToString:REQUEST_SUCCESS]) && (![errorMessage isEqualToString:@""]))
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabelText = errorMessage;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ErrorInfo_ShowTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:vc.view animated:YES];
                });
            }
        }
    }
}

+ (UIView*)getCurrentView
{
    UIView *view = nil;
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (app.window.rootViewController.presentedViewController)
    {
        view = app.window.rootViewController.presentedViewController.view;
    }
    else
    {
        view = app.window.rootViewController.view;
    }
    return view;
}

+ (void)showLoading:(NSString *)message time:(NSInteger)delay
{
    UIView *view = [BDStyle getCurrentView];
    if (view)
    {
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = message;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:view animated:YES];
        });
    }
}

+ (void)showLoading:(NSString *)message time:(NSInteger)delay currentView:(UIView *)currentView
{
    if (currentView)
    {
        [MBProgressHUD hideAllHUDsForView:currentView animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = message;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:currentView animated:YES];
        });
    }
}

+ (void)showLoading:(NSString *)message currentView:(UIView *)currentView handler:(noParameterBlock)handler
{
    if (currentView)
    {
        [MBProgressHUD hideAllHUDsForView:currentView animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = message;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ErrorInfo_ShowTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:currentView animated:YES];
            if (handler)
            {
                handler();
            }
        });
    }
}


@end
