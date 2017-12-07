//
//  BDOrderDetailTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/5/23.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDOrderDetailTableViewCell.h"

@implementation BDOrderDetailTableViewCell
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
        titleLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor colorWithHexString:@"#646464"]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.width.mas_equalTo(WScale*100);
        }];
        
        messageLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor colorWithHexString:@"#646464"]];
        messageLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:messageLbl];
        [messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(titleLbl.mas_right).offset(WScale*8);
            make.right.equalTo(self).offset(WScale*-15);
        }];
        
        UIView *lineView = [BDStyle createView:[UIColor colorWithHexString:@"#f0f0f0"]];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.left.equalTo(self).offset(WScale *20);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)bindData:(NSString *)title message:(NSString *)message
{
    titleLbl.text = title;
    titleLbl.font = FONTSIZE(15);
    messageLbl.text = message;
    CGFloat width = [BDStyle getWidthWithTitle:title font:15];
    
    [titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(width);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
