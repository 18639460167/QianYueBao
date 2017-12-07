//
//  BDWithdrawTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/4/1.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDWithdrawTableViewCell.h"

@implementation BDWithdrawTableViewCell
@synthesize statusImage;
@synthesize moneyLbl;
@synthesize timeLbl;
@synthesize monthLbl;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        statusImage = [UIImageView createImage:@"withdraw_success"];
        [self addSubview:statusImage];
        [statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(HScale*35, HScale*35));
            make.left.equalTo(self).offset(WScale*25);
        }];
        
        CGFloat width = [BDStyle getWidthWithTitle:LS(@"Settle_Finish") font:15];
        UILabel *alertLbl = [UILabel createNoramlLbl:LS(@"Settlf_Fail") font:15 textColor:BLACK_COLOR];
        [self addSubview:alertLbl];
        [alertLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(HScale*12.5);
            make.left.equalTo(statusImage.mas_right).offset(WScale*20);
            make.size.mas_equalTo(CGSizeMake(width+5, WScale*19));
        }];
        
        timeLbl = [UILabel createNoramlLbl:@"" font:10 textColor:[UIColor nineSixColor]];
        [self addSubview:timeLbl];
        [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(alertLbl.mas_left);
            make.top.equalTo(alertLbl.mas_bottom).offset(HScale*15);
            make.size.mas_equalTo(CGSizeMake(WScale*110, WScale*13));
        }];
        
        moneyLbl = [UILabel createRightLbl:@"" font:15 textColor:BLACK_COLOR];
        [self addSubview:moneyLbl];
        [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(WScale*-25);
            make.left.equalTo(alertLbl.mas_right).offset(WScale*8);
            make.centerY.mas_equalTo(alertLbl.mas_centerY);
            make.height.mas_equalTo(WScale*18);
        }];
        
        UIView *lineView = [BDStyle createView:[UIColor cEightColor]];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setSettleModel:(BDSettleMentModel *)settleModel
{
    if (settleModel)
    {
        moneyLbl.text = [NSString stringWithFormat:@"+ %.2f",[settleModel.amount floatValue]];
        timeLbl.text = settleModel.create_time;
    }
    _settleModel = settleModel;
}

- (void)cellAction:(BDSignFinishViewController *)vc
{
    if (vc)
    {
        BDWithdrawDetailViewController *dVC = [[BDWithdrawDetailViewController alloc]init];
        dVC.setModel = _settleModel;
        dVC.title = vc.signModel.title;
        [vc pushAction:dVC];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
