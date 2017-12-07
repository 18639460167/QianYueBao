//
//  BDTradeTableViewCell.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDTradeTableViewCell.h"

@implementation BDLabelView

+ (instancetype)createView
{
    BDLabelView *view = [[BDLabelView alloc]initWithFrame:CGRectZero];
    return view;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [WHITE_COLOR colorWithAlphaComponent:0];
    }
    return self;
}

- (CGFloat)reloadData:(NSArray *)labelArray tradeStatus:(TradeStatus)status
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat startX = 0;
    if (labelArray.count>0)
    {
        labelArray = @[labelArray[0]];
    }
    for (int i=0; i<labelArray.count; i++)
    {
        CGFloat width = [BDStyle getWidthWithTitle:labelArray[i] font:10]+HScale*12;
        UIImageView *statusImage = [UIImageView new];
        statusImage.image =   [BDStyle imageWithColor:[UIColor navigationColor] size:CGSizeMake(1, 1)];
        statusImage.frame = CGRectMake(startX, 0, width, HScale*15);
        statusImage.layer.cornerRadius = HScale*7.5;
        statusImage.clipsToBounds = YES;
        if (i!=0 || (status == TradeStatus_Finish))
        {
            statusImage.image = [BDStyle imageWithColor:[UIColor navigationColor] size:CGSizeMake(1, 1)];
        }
        else
        {
            if (status == TradeStatus_Process)
            {
                statusImage.image = [BDStyle imageWithColor:[UIColor colorWithHexString:@"#6ec4de"] size:CGSizeMake(1, 1)];
            }
            else
            {
                statusImage.image = [BDStyle imageWithColor:BLACK_COLOR size:CGSizeMake(1, 1)];
            }
        }
        [self addSubview:statusImage];
        
        UILabel *statusLbl = [UILabel createLbl:labelArray[i] font:10 textColor:WHITE_COLOR];
        [statusImage addSubview:statusLbl];
        [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(statusImage);
        }];
        startX  = startX+width+WScale*5;
    }
    return startX;
}

@end

@interface BDTradeTableViewCell()
{
    UIImageView *logoImage;
}

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) BDLabelView *labelView;
@end

@implementation BDTradeTableViewCell
@synthesize nameLbl;
@synthesize timeLbl;
@synthesize labelView;
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
        
        logoImage = [UIImageView createImage:@"shop_logo"];
        [self addSubview:logoImage];
        [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(HScale*20, HScale*26));
            make.left.equalTo(self).offset(WScale*25);
        }];
        
        nameLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(WScale*17);
            make.left.equalTo(logoImage.mas_right).offset(WScale*20);
            make.width.mas_equalTo(WScale*100);
        }];
        timeLbl = [UILabel createRightLbl:@"" font:12 textColor:[UIColor nineSixColor]];
        [self addSubview:timeLbl];
        [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(WScale*-20);
            make.bottom.equalTo(self).offset(HScale*-5);
            make.height.mas_equalTo(WScale*12);
            make.left.equalTo(logoImage.mas_right).offset(WScale*10);
        }];
        
        
//        labelView = [BDLabelView createView];
//        [self addSubview:labelView];
//        [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(nameLbl.mas_right).offset(3);
//            make.height.mas_equalTo(HScale*15);
//            make.width.mas_equalTo(50);
//            make.bottom.equalTo(nameLbl.mas_top).offset(HScale*2);
//        }];
        statusLbl = [UILabel createLbl:@"" font:10 textColor:WHITE_COLOR];
        statusLbl.layer.cornerRadius = HScale*7.5;
        statusLbl.clipsToBounds = YES;
        [self addSubview:statusLbl];
        [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLbl.mas_right).offset(3);
            make.height.mas_equalTo(HScale*15);
            make.width.mas_equalTo(50);
            make.bottom.equalTo(nameLbl.mas_top).offset(HScale*2);
        }];
        
        UIImageView *lineImage = [UIImageView new];
        lineImage.image = [BDStyle imageWithColor:[UIColor cEightColor] size:CGSizeMake(1, 1)];
        [self addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*35/2);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setSignModel:(BDSignListModel *)signModel
{
    if (signModel)
    {
        timeLbl.text = signModel.upadte_time;
        switch (signModel.contract_status)
        {
            case TradeStatus_Process:
            {
                statusLbl.backgroundColor = [UIColor colorWithHexString:@"#6ec4de"];
            }
                break;
            case TradeStatus_Finish:
            {
                statusLbl.backgroundColor = [UIColor subjectColor];
            }
                break;
                
            default:
            {
                statusLbl.backgroundColor = BLACK_COLOR;
            }
                break;
        }
//        CGFloat width = [labelView reloadData:signModel.comp_platform tradeStatus:signModel.contract_status];
        CGFloat width = [BDStyle getWidthWithTitle:[signModel getTradeStatus:signModel.contract_status] font:10]+HScale*12;
        CGFloat titleWidth = [BDStyle getWidthWithTitle:signModel.title font:15];
        
        nameLbl.text = signModel.title;
        statusLbl.text = [signModel getTradeStatus:signModel.contract_status];
        if (titleWidth>SCREEN_WIDTH-WScale*68-HScale*20-width)
        {
            titleWidth = SCREEN_WIDTH-WScale*68-HScale*20-width;
        }
        
        [nameLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(titleWidth);
        }];
        [statusLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
//        [labelView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(width);
//        }];

    }
    _signModel = signModel;
}

- (void)cellAction:(UIViewController *)vc
{
    if (vc)
    {
        switch (self.signModel.contract_status)
        {
            case TradeStatus_Finish:
            {
                BDSignFinishViewController *sVc = [[BDSignFinishViewController alloc]init];
                sVc.signModel = _signModel;
                [vc pushAction:sVc];
            }
                break;
            case TradeStatus_Wait:
            {
                BDSignDeatilViewController *dVc = [BDSignDeatilViewController new];
                dVc.listModel = _signModel;
                [vc pushAction:dVc];
            }
                break;
                
            default:
            {
                BDSignDeatilViewController *dVc = [BDSignDeatilViewController new];
                dVc.listModel = _signModel;
                [vc pushAction:dVc];
            }
                break;
        }
      
//        if (_signModel.contract_status == TradeStatus_Finish)
//        {
//        }
//        else
//        {
//            BDSignDeatilViewController *dVc = [BDSignDeatilViewController new];
//            dVc.signMid = self.signModel.sign_mid;
//            [vc pushAction:dVc];
//        }
 
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
