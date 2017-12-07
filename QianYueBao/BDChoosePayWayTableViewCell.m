//
//  BDChoosePayWayTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/4/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDChoosePayWayTableViewCell.h"

@implementation BDChoosePayWayTableViewCell
@synthesize payWayView;
@synthesize tagWayView;
@synthesize lineImage;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.chooseTagArray = [NSMutableArray new];
        UILabel *titleLbl = [UILabel createNoramlLbl:[LS(@"Payment_Interface") stringByAppendingString:@":"] font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(HScale*20);
            make.left.equalTo(self).offset(WScale*15);
            make.height.mas_equalTo(HScale*30);
            make.width.mas_equalTo([BDStyle getWidthWithTitle:[LS(@"Payment_Interface") stringByAppendingString:@":"] font:15]);
        }];
        
        payWayView = [BDPayWayView createView:self];
        HYWeakSelf;
        payWayView.complete = ^()
        {
           wSelf.tagWayView.hidden =! wSelf.tagWayView.hidden;
           wSelf.lineImage.hidden = wSelf.tagWayView.hidden;
            if (wSelf.cellHandler)
            {
                wSelf.cellHandler();
            }
        };
        [payWayView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self).offset(HScale*20);
            make.left.equalTo(titleLbl.mas_right).offset(WScale*3);
            make.height.mas_equalTo(HScale*30);
            make.right.equalTo(self).offset(WScale*-15);
        }];
        
        tagWayView = [BDPayTagView createView:self];
        tagWayView.tagComplete = ^(NSString *title){
            int index = -1;
            for (int i=0;i<wSelf.chooseTagArray.count;i++)
            {
                NSString *oldTit = wSelf.chooseTagArray[i];
                if ([oldTit isEqualToString:title])
                {
                    index = i;
                    break;
                }
            }
            if (index == -1)
            {
                [wSelf.chooseTagArray addObject:title];
            }
            else
            {
                [wSelf.chooseTagArray removeObjectAtIndex:index];
            }
            NSString *str = @"";
            for (int i=0; i<wSelf.chooseTagArray.count; i++)
            {
                if (i==0)
                {
                    str= [NSString stringWithFormat:@"%@%@",str,wSelf.chooseTagArray[i]];
                }
                else
                {
                    str= [NSString stringWithFormat:@"%@;%@",str,wSelf.chooseTagArray[i]];
                }
            }
            wSelf.payWayView.titleLbl.text = str;
            if (wSelf.payWayHandler)
            {
                wSelf.payWayHandler(wSelf.chooseTagArray);
            }
        };
        [tagWayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(WScale*15);
            make.right.equalTo(self).offset(WScale*-15);
            make.top.equalTo(self).offset(HScale*60);
            make.bottom.equalTo(self).offset(HScale*-10);
        }];
        
        lineImage = [UIImageView createImageWithColor:[UIColor cEightColor]];
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

- (void)bindData:(NSArray *)tagArray isHide:(BOOL)isHide isFirst:(BOOL)isFrist
{
    lineImage.hidden = NO;
    tagWayView.hidden = isHide;
    NSString *str = @"";
    for (int i=0; i<tagArray.count; i++)
    {
        if (i==0)
        {
            str= [NSString stringWithFormat:@"%@%@",str,tagArray[i]];
        }
        else
        {
            str= [NSString stringWithFormat:@"%@;%@",str,tagArray[i]];
        }
    }
    self.payWayView.titleLbl.text = str;
//    if (!isFrist)
//    {
//        [tagWayView bindData:[BDAccountService sharedService].payWayArray];
//    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
