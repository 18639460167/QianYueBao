//
//  BDOrderTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/4/19.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDOrderTableViewCell.h"

@implementation BDOrderTableViewCell
@synthesize logoImage;
@synthesize moneyLbl;
@synthesize monthLbl;
@synthesize nameLbl;
@synthesize statusLbl;
@synthesize dishLbl;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        logoImage = [UIImageView createImage:@"pay_place"];
        [self addSubview:logoImage];
        [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(WScale*35, WScale*35));
            make.left.equalTo(self).offset(WScale*24);
        }];
        
        nameLbl = [UILabel createNoramlLbl:@"" font:15 textColor:BLACK_COLOR];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(HScale *12.5);
            make.left.equalTo(logoImage.mas_right).offset(WScale *20);
            make.height.mas_equalTo(HScale*18);
            make.width.mas_equalTo(WScale*100);
        }];
        
        monthLbl = [UILabel createNoramlLbl:@"" font:10 textColor:[UIColor nineSixColor]];
        [self addSubview:monthLbl];
        [monthLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(logoImage.mas_right).offset(WScale *20);
            make.height.mas_equalTo(HScale*40/2);
            make.width.mas_equalTo(WScale*220/2);
            make.top.equalTo(nameLbl.mas_bottom).offset(HScale *8);
        }];
        
        moneyLbl = [UILabel createRightLbl:@"" font:15 textColor:[UIColor nineSixColor]];
        [self addSubview:moneyLbl];
        [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(monthLbl.mas_right).offset(WScale*15);
            make.height.mas_equalTo(HScale*40/2);
            make.bottom.mas_equalTo(monthLbl.mas_bottom);
            make.right.equalTo(self).offset(WScale*-24);
        }];
        
        statusLbl = [UILabel createNoramlLbl:@"" font:9 textColor:[UIColor colorWithHexString:@"#ff001f"]];
        statusLbl.layer.cornerRadius = WScale*4;
        statusLbl.layer.borderWidth = WScale*1;
        statusLbl.layer.borderColor = [UIColor colorWithHexString:@"#ff001f"].CGColor;
        statusLbl.textAlignment = NSTextAlignmentCenter;
        statusLbl.adjustsFontSizeToFitWidth = YES;
        [self addSubview:statusLbl];
        [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(WScale*44);
            make.height.mas_equalTo(HScale*15);
            make.bottom.equalTo(nameLbl.mas_top).offset(HScale*10);
            make.left.equalTo(nameLbl.mas_right).offset(WScale*5);
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

- (void)binData:(BDTransactionModel *)bModel title:(NSString *)title
{
    self.model =  bModel;
    self.model.shopName = title;
    monthLbl.text = bModel.pay_time;
    moneyLbl.text = [NSString stringWithFormat:@"%@ %@",bModel.currency_sign,bModel.settle_amount];
    [logoImage sd_setImageWithURL:[NSURL URLWithString:bModel.payment_channel_icon] placeholderImage:[UIImage imageNamed:@"pay_place"] options:SDWebImageAllowInvalidSSLCertificates];
     moneyLbl.text = [NSString stringWithFormat:@"%@ %@",bModel.currency_sign,bModel.settle_amount];
    moneyLbl.textColor = [UIColor colorWithHexString:@"#969696"];
    switch (bModel.finsh_status)
    {
        case BDTranscationStatus_Pay:
        {
            statusLbl.layer.borderColor = [UIColor colorWithHexString:@"#e99316"].CGColor;
            statusLbl.textColor = [UIColor colorWithHexString:@"#e99316"];
            moneyLbl.textColor = [UIColor colorWithHexString:@"#e99316"];
            statusLbl.text = LS(@"Done");
        }
            break;
        case BDTranscationStatus_Progress:
        {
            statusLbl.layer.borderColor = [UIColor colorWithHexString:@"#ff001f"].CGColor;
            statusLbl.textColor = [UIColor colorWithHexString:@"#ff001f"];
            statusLbl.text = LS(@"Procress");
        }
            break;
        case BDTranscationStatus_Finish:
        {
            statusLbl.layer.borderColor = [UIColor colorWithHexString:@"#17a5a1"].CGColor;
            statusLbl.textColor = [UIColor colorWithHexString:@"#17a5a1"];
            statusLbl.text = LS(@"Refunded");
        }
            break;
        default:
        {
            statusLbl.layer.borderColor = [UIColor colorWithHexString:@"#969696"].CGColor;
            statusLbl.textColor = [UIColor colorWithHexString:@"#969696"];
            statusLbl.text = LS(@"UnPay");
        }
            break;
    }
    NSString *message = @"";
    if ([bModel.settlement_status isEqualToString:@"1"])
    {
        message = [NSString stringWithFormat:@"[%@]",LS(@"Settle_Finish")];
    }
    else
    {
        message = [NSString stringWithFormat:@"[%@]",LS(@"Settlf_Fail")];
    }
    NSMutableAttributedString *attStr = [NSString getMessage:message defaultMessage:title textColor:statusLbl.textColor];
    nameLbl.attributedText = attStr;
    
     CGFloat width  =[BDStyle getWidthWithTitle:statusLbl.text font:9];
    CGFloat titWidth = [BDStyle getWidthWithTitle:[NSString stringWithFormat:@"%@%@",message,title] font:15];
    if (titWidth>(SCREEN_WIDTH-WScale*110-width))
    {
        titWidth = (SCREEN_WIDTH-WScale*110-width);
    }
    [nameLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titWidth);
    }];
    [statusLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width+WScale*5);
    }];
}

- (void)cellAction:(BDSuperViewController *)vc title:(NSString *)title
{
    if (vc)
    {
        BDOrderDeatilViewController *detailVC = [[BDOrderDeatilViewController alloc]init];
        detailVC.transModel = self.model;
        [vc pushAction:detailVC];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
