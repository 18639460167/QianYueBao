//
//  BDChooseHeardView.m
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDChooseHeardView.h"

@implementation BDChooseHeardView
@synthesize titleLbl;

+ (instancetype)createHeardView:(CGRect)frame
{
    BDChooseHeardView *heardView = [[BDChooseHeardView alloc]initWithFrame:frame];
    return heardView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = WHITE_COLOR;
        titleLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor nineSixColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        UIImageView *lineImage = [UIImageView new];
        lineImage.image = [BDStyle imageWithColor:[UIColor cEightColor] size:CGSizeMake(1, 1)];
        [self addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)bindData:(NSString *)normalTile titleArray:(NSArray *)titleArray
{
    NSString *title = [NSString stringWithFormat:@"%@：",normalTile];
    for (int i=0;i<titleArray.count;i++)
    {
        NSString *message = titleArray[i];
        //BDMoreSelectModel *model = titleArray[i];
        if (i==0)
        {
            title = [NSString stringWithFormat:@"%@%@",title,message];
        }
        else
        {
             title = [NSString stringWithFormat:@"%@/%@",title,message];
        }
    }
    titleLbl.text = title;
}

- (void)bindData:(NSString *)normalTitle model:(NSString *)name;
{
    NSString *title = [NSString stringWithFormat:@"%@：",normalTitle];
   title = [NSString stringWithFormat:@"%@%@",title,name];
    titleLbl.text = title;
}

@end
