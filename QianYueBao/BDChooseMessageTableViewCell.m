//
//  BDChooseMessageTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/4/14.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDChooseMessageTableViewCell.h"

@implementation BDMenuButton
@synthesize messageLbl;

+ (instancetype)createButton:(UIView *)fatherView
{
    BDMenuButton *button = [[BDMenuButton alloc]initWithFrame:CGRectZero];
    [fatherView addSubview:button];
    return button;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
        self.layer.cornerRadius = HScale*35/2;
        self.layer.masksToBounds = YES;
        
        UIImageView *arrorImage = [UIImageView createImage:@"select_arrorw"];
        [self addSubview:arrorImage];
        [arrorImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(WScale*7, HScale*15));
            make.right.equalTo(self).offset(HScale*-10);
        }];
        
        messageLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:messageLbl];
        [messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(arrorImage.mas_left).offset(WScale*-5);
            make.left.equalTo(self).offset(HScale*10);
        }];

    }
    return self;
}

@end

@implementation BDChooseMessageTableViewCell
@synthesize menuBtn;
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
        CGFloat startX = (HScale*50-WScale*17.5)/2;
        titleLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(startX);
            make.height.mas_equalTo(WScale*15);
            make.left.equalTo(self).offset(WScale*15);
            make.width.mas_equalTo(WScale*100);
        }];
        
        UIImageView *arrorwImage = [UIImageView createImage:@"dish_arrorw"];
        [self addSubview:arrorwImage];
        [arrorwImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.equalTo(self).offset(WScale*-15);
            make.size.mas_equalTo(CGSizeMake(WScale*12, HScale*22));
        }];
        
        messageLbl = [UILabel createRightLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        messageLbl.numberOfLines = 0;
        [self addSubview:messageLbl];
        [messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(startX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.equalTo(arrorwImage.mas_left).offset(WScale*-8);
            make.left.equalTo(titleLbl.mas_right).offset(WScale*8);
        }];
        
        UIImageView *lineImage = [UIImageView createImageWithColor:[UIColor cEightColor]];
        [self addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self).offset(WScale*15);
        }];
//        menuBtn = [BDMenuButton createButton:self];
//        [menuBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//        [menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).offset(WScale*-15);
//            make.height.mas_equalTo(HScale*35);
//            make.bottom.equalTo(self);
//            make.left.equalTo(titleLbl.mas_right).offset(WScale*3);
//        }];
    }
    return self;
}

- (void)bindData:(NSString *)title message:(NSString *)message
{
    titleLbl.text = title;
    messageLbl.text = message;
    CGFloat width = [BDStyle getWidthWithTitle:title font:15];
    [titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (void)bindData:(NSString *)title model:(BDSignCategoryModel *)model
{
    self.model = model;
    menuBtn.messageLbl.text = model.category;
    CGFloat width = [BDStyle getWidthWithTitle:title font:15];
    [titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    titleLbl.text = title;
}

- (void)cellAction:(BDSuperViewController *)currentVC
{
    NSIndexPath *indexPath = [currentVC.tableview indexPathForCell:self];
    if (indexPath.section == 1)
    {
        if (indexPath.row == 9)
        {
            BDMoreChooseViewController *vc = [BDMoreChooseViewController new];
            vc.title = LS(@"Cooperation_Competing");
            vc.chooseStatus = ChooseStatus_Platform;
            vc.selectArray = [NSMutableArray arrayWithArray:currentVC.detailModel.basicModel.comp_platform_val];
            vc.backSelectHandler = ^(NSArray *messageArray,NSArray *selectArray){
                currentVC.detailModel.basicModel.comp_platform = selectArray;
                currentVC.detailModel.basicModel.comp_platform_val = messageArray;
                [currentVC.tableview reloadIndex:indexPath.section row:indexPath.row];
            };
            [currentVC pushAction:vc];
        }
        if (indexPath.row == 10)
        {
            BDMoreChooseViewController *vc = [BDMoreChooseViewController new];
            vc.title = LS(@"Recommend_Service");
            vc.chooseStatus = ChooseStatus_Service;
            vc.selectArray = [NSMutableArray arrayWithArray:currentVC.detailModel.basicModel.support_service_val];
            vc.backSelectHandler = ^(NSArray *messageArray,NSArray *selectArray){
                currentVC.detailModel.basicModel.support_service = selectArray;
                currentVC.detailModel.basicModel.support_service_val = messageArray;
                [currentVC.tableview reloadIndex:indexPath.section row:indexPath.row];
            };
            [currentVC pushAction:vc];
        }
        if (indexPath.row == 8)
        {
            BDSelectMessageViewController *sVC = [BDSelectMessageViewController new];
            sVC.selecthandler = ^(NSString *code,NSString *message){
                currentVC.detailModel.basicModel.category = message;
                currentVC.detailModel.basicModel.cat_id = code;
                [currentVC.tableview reloadIndex:indexPath.section row:indexPath.row];
            };
            [currentVC pushAction:sVC];
        }
        if (indexPath.row == 3)
        {
            BDChooseOnlyViewController *vc =[BDChooseOnlyViewController new];
            vc.title = LS(@"Country");
            vc.country = currentVC.detailModel.basicModel.loc_country;
            vc.backhandler = ^(NSString *title,NSString *code)
            {
                currentVC.detailModel.basicModel.loc_country = title;
                currentVC.detailModel.basicModel.country_code = code;
                [currentVC.tableview reloadIndex:indexPath.section row:indexPath.row];
            };
            [currentVC pushAction:vc];
        }
    }
    if (indexPath.section == 2)
    {
        if (indexPath.row == 2)
        {
            BDMoreChooseViewController *vc = [BDMoreChooseViewController new];
            vc.title = LS(@"Payment_Interface");
            vc.chooseStatus = ChooseStatus_Payment;
            vc.selectArray = [NSMutableArray arrayWithArray:currentVC.detailModel.contractModel.payment_channel_val];
            
            vc.backSelectHandler = ^(NSArray *messageArray,NSArray *selectArray){
                currentVC.detailModel.contractModel.payment_channel = selectArray;
                currentVC.detailModel.contractModel.payment_channel_val = messageArray;
                [currentVC.tableview reloadIndex:indexPath.section row:indexPath.row];
            };
            [currentVC pushAction:vc];
        }
    }

}

- (void)btnAction
{
    [BDPopOverMenu showForSender:menuBtn withIndex:0 withMenu:self.model.titleArray doneBlock:^(NSInteger selectIndex) {
        if (selectIndex<self.model.titleArray.count)
        {
            self.model.category = self.model.titleArray[selectIndex];
            menuBtn.messageLbl.text = self.model.titleArray[selectIndex];
            if (self.complete)
            {
                self.complete(self.model);
            }
        }
    } dissmissBlock:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
