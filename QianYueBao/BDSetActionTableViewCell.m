//
//  BDSetActionTableViewCell.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSetActionTableViewCell.h"
#import "BDSetActionButton.h"

@implementation BDSetActionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *array = @[LS(@"Service_Hotline"),LS(@"Online_Service"),LS(@"Information"),LS(@"More")];
        NSArray *imageArray = @[@"set_phone",@"set_customer",@"set_consult",@"set_more"];
        UIView *bgView = [BDStyle createView:WHITE_COLOR];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.top.equalTo(self);
            make.left.equalTo(self).offset(WScale*12.5);
        }];
        CGFloat width = (SCREEN_WIDTH-WScale*25)/2;
        CGFloat heigth = HScale*93;
        for (int i=0; i<imageArray.count; i++)
        {
            BOOL isOK = NO;
            int x = i%2;
            int y = i/2;
            if (i==1 || i==2)
            {
                isOK = YES;
            }
            BDSetActionButton *actionBtn = [BDSetActionButton createButton:array[i] imageName:imageArray[i] isSame:isOK];
            actionBtn.frame = CGRectMake(x*width, y*heigth, width, heigth);
            actionBtn.tag = i+1;
            [actionBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:actionBtn];
        }
        
        for (int i=0; i<2; i++)
        {
            UIView *lineView = [BDStyle createView:[UIColor lineColor]];
            lineView.frame = CGRectMake(0, heigth*i, SCREEN_WIDTH-WScale*25, 0.5);
            [bgView addSubview:lineView];
        }
        
        UIView *line = [BDStyle createView:[UIColor lineColor]];
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.top.bottom.equalTo(bgView);
            make.width.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)btnAction:(UIButton *)button
{
    if (self.VC)
    {
        switch (button.tag)
        {
            case 1:
            {
                [BDStyle BDTelPhone:self.VC.view];
            }
                break;
            case 2:
            {
              //  [BDStyle BDTelPhone:self.VC.view];
            }
                break;
            case 3:
            {
                [self.VC pushAction:[BDConsultViewController new]];
//                HYCameraViewController *vc = [[HYCameraViewController alloc]init];
//                vc.maxCount = 6;
//                vc.cameraBack = ^(NSArray<HYCamera *> *assets){
//                    NSLog(@"%@",assets);
//                };
//                [self.VC presentViewController:vc animated:YES completion:nil];
            }
                break;
            case 4:
            {
                return;
            }
                break;
                
            default:
                break;
        }
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
