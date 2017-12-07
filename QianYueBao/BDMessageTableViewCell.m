//
//  BDMessageTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/4/5.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDMessageTableViewCell.h"

@implementation BDMessageTableViewCell
@synthesize titleLbl;
@synthesize messageText;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        titleLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.width.mas_equalTo(WScale*100);
        }];
        
        messageText = [UITextField createText:@"" font:15 textColor:[UIColor threeTwoColor]];
        messageText.delegate = self;
        HYWeakSelf;
        [messageText.rac_textSignal subscribeNext:^(id x) {
            if (wSelf.textHandler) {
                wSelf.textHandler(x);
            }
        }];
        [self addSubview:messageText];
        [messageText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(self).offset(WScale*-15);
            make.left.equalTo(titleLbl.mas_right).offset(WScale*3);
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
    messageText.text = message;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
