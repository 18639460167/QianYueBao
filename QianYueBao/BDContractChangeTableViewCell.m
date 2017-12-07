//
//  BDContractChangeTableViewCell.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/30.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDContractChangeTableViewCell.h"

@implementation BDContractChangeTableViewCell
@synthesize timeLbl;
@synthesize statusImage;
@synthesize statusLbl;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        statusImage = [UIImageView new];
        statusImage.layer.cornerRadius = HScale*8;
        statusImage.layer.masksToBounds = YES;
        [self addSubview:statusImage];
        [statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.equalTo(self).offset(WScale*-15);
            make.height.mas_equalTo(HScale*16);
            make.width.mas_equalTo(WScale*50);
        }];
        
        statusLbl = [UILabel createLbl:@"" font:10 textColor:WHITE_COLOR];
        [statusImage addSubview:statusLbl];
        [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(statusImage);
        }];
        
        timeLbl = [UILabel  createNoramlLbl:@"" font:12 textColor:[UIColor threeTwoColor]];
        [self addSubview:timeLbl];
        [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.right.equalTo(statusImage.mas_left).offset(WScale*-8);
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

- (void)setContractModel:(BDContractModel *)contractModel
{
    timeLbl.text = contractModel.update_time;
    NSString *status = @"";
    UIColor *bgColor = [UIColor navigationColor];
    switch (contractModel.contract_status)
    {
        case TradeStatus_Fail:
        {
            status = LS(@"Review_Fail");
            bgColor = BLACK_COLOR;
        }
            break;
        case TradeStatus_Process:
        {
            status = LS(@"Under_Review");
            bgColor = [UIColor colorWithHexString:@"#6ec4de"];
        }
            break;
        case TradeStatus_Finish:
        {
            status = LS(@"Contract_Inforce");
            bgColor = [UIColor subjectColor];
        }
            break;
        default:
        {
            status = LS(@"Contract_Expired");
            bgColor = [UIColor colorWithHexString:@"#b4b4b4"];
        }
            break;
    }
    statusImage.image = [BDStyle getImageWithColor:bgColor];
    statusLbl.text = status;
    CGFloat width = [BDStyle getWidthWithTitle:status font:10]+HScale*13;
    [statusImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    _contractModel = contractModel;
}

- (void)cellAction:(BDSignFinishViewController *)vc
{
    if (vc)
    {
        BDChangeContractViewController *cVC = [[BDChangeContractViewController alloc]init];
        cVC.detailModel = [[BDSignDetailModel alloc]initWithFmdbDic:[NSDictionary new]];
        cVC.detailModel.requestSuccess = YES;
        cVC.detailModel.contractModel = _contractModel;
        [vc pushAction:cVC];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
