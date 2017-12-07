//
//  BDMoreChooseTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDMoreChooseTableViewCell.h"

@implementation BDMoreChooseTableViewCell
@synthesize selectImage;
@synthesize titleLbl;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = WHITE_COLOR;
        
        selectImage = [UIImageView createImage:@"pay_noSelect"];
        [self addSubview:selectImage];
        [selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(WScale*16, WScale*16));
            make.right.equalTo(self).offset(WScale*-15);
        }];
        
        titleLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.right.equalTo(selectImage.mas_left).offset(WScale*-8);
        }];
        
        UIView *lineView = [BDStyle createView:[UIColor cEightColor]];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)bindData:(id)model
{
    if ([model isKindOfClass:[BDMoreSelectModel class]])
    {
        BDMoreSelectModel *sModel = (BDMoreSelectModel*)model;
        titleLbl.text = sModel.title;
        
        if (sModel.isSelect)
        {
            selectImage.image = IMAGE_NAME(@"pay_select");
        }
        else
        {
            selectImage.image = IMAGE_NAME(@"pay_noSelect");
        }
    }
    else if([model isKindOfClass:[BDCountryModel class]])
    {
        BDCountryModel *cModel = (BDCountryModel *)model;
        titleLbl.text = cModel.name;
        if (cModel.isSelect)
        {
            selectImage.image = IMAGE_NAME(@"pay_select");
        }
        else
        {
            selectImage.image = IMAGE_NAME(@"pay_noSelect");
        }
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
