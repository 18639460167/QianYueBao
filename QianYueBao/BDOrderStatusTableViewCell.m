//
//  BDOrderStatusTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/5/23.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDOrderStatusTableViewCell.h"

@implementation BDOrderStatusTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

@synthesize titleLbl;
@synthesize statusLbl;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        titleLbl = [UILabel createNoramlLbl:LS(@"Trading_Status") font:15 textColor:[UIColor colorWithHexString:@"#646464"]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.width.mas_equalTo(WScale*150);
        }];
        
        statusLbl = [UILabel createLbl:@"" font:10 textColor:[UIColor colorWithHexString:@"#646464"]];
        statusLbl.adjustsFontSizeToFitWidth = YES;
        statusLbl.layer.borderWidth = 1;
        statusLbl.layer.cornerRadius = WScale*4;
        [self addSubview:statusLbl];
        [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(WScale*40, HScale*20));
            make.right.equalTo(self).offset(-WScale*20);
        }];
    }
    return self;
}

- (void)bindData:(BDTranscationStatus)status
{
    switch (status)
    {
        case BDTranscationStatus_Pay:
        {
            statusLbl.textColor = [UIColor colorWithHexString:@"#e99316"];
            statusLbl.layer.borderColor = [UIColor colorWithHexString:@"#e99316"].CGColor;
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
            statusLbl.text = LS(@"Unknow");
        }
            break;
    }
    CGFloat width = [BDStyle getWidthWithTitle:statusLbl.text font:10];
    if (width<WScale*40)
    {
        width = WScale*40;
    }
    else
    {
        width = width+WScale*6;
    }
    [statusLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, HScale*20));
        make.right.equalTo(self).offset(-WScale*15);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
