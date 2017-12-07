//
//  BDAddOwnerTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/5/4.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDAddOwnerTableViewCell.h"

@implementation BDAddOwnerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *addView = [BDStyle createView:WHITE_COLOR];
        [self addSubview:addView];
        [addView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.equalTo(self);
            make.height.mas_equalTo(HScale*32+WScale*18);
        }];
        
        UIImageView *addImage = [UIImageView createImage:@"create_owner"];
        [addView addSubview:addImage];
        [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(addView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(HScale*27, HScale*27));
            make.top.equalTo(addView);
        }];
       
        UILabel *titleLbl = [UILabel createLbl:LS(@"Add_Owner_Message") font:15 textColor: [UIColor nineSixColor]];
        [addView addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(addView);
            make.height.mas_equalTo(WScale*18);
            make.centerX.mas_equalTo(addView.mas_centerX);
            make.left.equalTo(addView).offset(WScale*8);
        }];
        
        UIButton *actionBtn = [UIButton buttonWithType:0];
        [actionBtn addTarget:self action:@selector(addOwnerAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionBtn];
        [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self);
        }];
    }
    return self;
}

- (void)addOwnerAction
{
    if (self.signVC)
    {
        BDAddOwnerViewController *vc = [[BDAddOwnerViewController alloc]init];
        vc.pushNumber = self.signVC.pushNumber;
        [self.signVC pushAction:vc];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
