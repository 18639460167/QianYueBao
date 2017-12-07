//
//  BDSearchOwnerTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/5/8.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSearchOwnerTableViewCell.h"

@implementation BDSearchOwnerTableViewCell
@synthesize nameLbl;
@synthesize accountLbl;
@synthesize accountNameLbl;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *arrorImage = [UIImageView createImage:@"owner_arrorw"];
        [self addSubview:arrorImage];
        [arrorImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(WScale*-15);
            make.size.mas_equalTo(CGSizeMake(HScale*15, HScale*25));
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        CGFloat width = (SCREEN_WIDTH-WScale*54-HScale*15)/3;
        nameLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.width.mas_equalTo(width);
        }];
        
        accountLbl = [UILabel createRightLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:accountLbl];
        [accountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(arrorImage.mas_left).offset(WScale*-8);
            make.width.mas_equalTo(width);
        }];
        
        accountNameLbl = [UILabel createLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:accountNameLbl];
        [accountNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(width);
            make.left.equalTo(nameLbl.mas_right).offset(WScale*8);
        }];
        
        UIImageView *lineImage = [UIImageView new];
        lineImage.image = [BDStyle imageWithColor:[UIColor cEightColor] size:CGSizeMake(1, 1)];
        [self addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.equalTo(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setOwnerModel:(BDOwnerModel *)ownerModel
{
    if (ownerModel)
    {
        nameLbl.text = ownerModel.ownerName;
        accountNameLbl.text = ownerModel.account_name;
        accountLbl.text = ownerModel.account;
        
    }
    _ownerModel = ownerModel;
}

- (void)cellAction:(BDSuperViewController *)vc
{
    if (vc)
    {
        [vc popSelectOwner:_ownerModel type:vc.pushNumber];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
