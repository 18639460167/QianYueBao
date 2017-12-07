//
//  BDOwnerMessageTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/5/4.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDOwnerMessageTableViewCell.h"

@implementation BDOwnerMessageTableViewCell
@synthesize titleLbl;
@synthesize messageLbl;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        titleLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor nineSixColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.width.mas_equalTo(100);
        }];
        
        messageLbl = [UILabel createRightLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:messageLbl];
        [messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(self).offset(WScale*-15);
            make.left.equalTo(titleLbl.mas_right).offset(WScale*8);
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

- (void)bindData:(NSString *)title message:(NSString *)message
{
    CGFloat width = [BDStyle getWidthWithTitle:title font:15];
    [titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    titleLbl.text = title;
    messageLbl.text = message;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
