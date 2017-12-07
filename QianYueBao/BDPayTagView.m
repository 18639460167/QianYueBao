//
//  BDPayTagView.m
//  QianYueBao
//
//  Created by Black on 17/4/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDPayTagView.h"

@implementation BDTagButton
@synthesize logoImage;
@synthesize titleLbl;

+ (instancetype)createWithFrame:(CGRect)frame title:(NSString *)title
{
    BDTagButton *button = [[BDTagButton alloc]initWithFrame:frame title:title];
    return button;
}
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame])
    {
        logoImage = [UIImageView createImage:@"pay_noSelect"];
        [self addSubview:logoImage];
        [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(HScale*15, HScale*15));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.equalTo(self);
        }];
        
        titleLbl = [UILabel createNoramlLbl:title font:14 textColor:[UIColor colorWithHexString:@"#646464"]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.left.equalTo(logoImage.mas_right).offset(WScale*5);
        }];
    }
    return self;
}
- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (isSelect)
    {
        logoImage.image = IMAGE_NAME(@"pay_select");
    }
    else
    {
        logoImage.image = IMAGE_NAME(@"pay_noSelect");
    }
}

@end

@implementation BDPayTagView

+ (instancetype)createView:(UIView *)fatherView
{
    BDPayTagView *tagView = [[BDPayTagView alloc]initWithFrame:CGRectZero];
    [fatherView addSubview:tagView];
    return tagView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)bindData:(NSArray *)dataArray
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float upX = 0;
    float upY = HScale*5;
    for (int i=0; i<dataArray.count; i++)
    {
        BDPayWayModel *model = dataArray[i];
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
        BDTagButton *button = [[BDTagButton alloc]initWithFrame:CGRectMake(upX, upY, width, HScale*25) title:model.title];
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.isSelect =model.isChoose;
        button.tag = i+1;
        [self addSubview:button];
        
        upX += width+WScale*15;
    }
}

- (void)btnAction:(BDTagButton *)button
{
    button.isSelect = !button.isSelect;
//    if ([BDAccountService sharedService].payWayArray.count>button.tag-1)
//    {
//        BDPayWayModel *model = [BDAccountService sharedService].payWayArray[button.tag-1];
//        model.isChoose = button.isSelect;
//        [[BDAccountService sharedService].payWayArray replaceObjectAtIndex:button.tag-1 withObject:model];
//        if (self.tagComplete)
//        {
//            self.tagComplete(button.titleLbl.text);
//        }
//    }

    
   
}

@end
