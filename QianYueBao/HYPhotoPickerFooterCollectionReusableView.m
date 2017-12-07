//
//  HYPhotoPickerFooterCollectionReusableView.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerFooterCollectionReusableView.h"
#import "UIView+HYExtension.h"

@interface HYPhotoPickerFooterCollectionReusableView()

@property (nonatomic, weak) UILabel *footerLabel;

@end
@implementation HYPhotoPickerFooterCollectionReusableView

- (UILabel *)footerLabel
{
    if (!_footerLabel)
    {
        UILabel *footerLabel = [[UILabel alloc] init];
        footerLabel.frame = self.bounds;
        footerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:footerLabel];
        self.footerLabel = footerLabel;
    }
    return _footerLabel;
}

- (void)setCount:(NSInteger)count{
    _count = count;
    
    if (count > 0)
    {
        self.footerLabel.text = [NSString stringWithFormat:@"有 %ld 张图片", (long)count];
    }
}

@end
