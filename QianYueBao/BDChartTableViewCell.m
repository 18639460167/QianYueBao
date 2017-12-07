//
//  BDChartTableViewCell.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDChartTableViewCell.h"


@implementation BDChartTableViewCell
@synthesize rankLbl;
@synthesize moneyLbl;
@synthesize nameLbl;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        rankLbl = [UILabel createLbl:@"" font:16 textColor:[UIColor colorWithHexString:@"#fd655b"]];
        [self addSubview:rankLbl];
        [rankLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.width.mas_equalTo(WScale*80);
        }];
        
        moneyLbl = [UILabel createLbl:@"9999999999" font:16 textColor:[UIColor threeTwoColor]];
        [self addSubview:moneyLbl];
        [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(WScale*-15);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo((SCREEN_WIDTH-WScale*130)/2);
        }];
        
        nameLbl = [UILabel createLbl:@"清迈测试店" font:16 textColor:[UIColor threeTwoColor]];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moneyLbl.mas_left).offset(WScale*-10);
            make.top.bottom.equalTo(self);
            make.left.equalTo(rankLbl.mas_right).offset(WScale*10);
        }];
    }
    return self;
}

- (void)bindData:(NSInteger)indexRow modle:(BDTransRankModel *)model
{
    CGFloat font = 16;
    switch (indexRow)
    {
        case 0:
        {
            font = 50;
        }
            break;
        case 1:
        {
            font = 75/2.0;
        }
            break;
        case 2:
        {
            font = 25;
        }
            break;
            
        default:
            break;
    }
    rankLbl.font = FONTSIZE(font);
    rankLbl.text = [NSString stringWithFormat:@"%ld",(long)indexRow+1];
    nameLbl.text = model.title;
    moneyLbl.text = model.total;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
