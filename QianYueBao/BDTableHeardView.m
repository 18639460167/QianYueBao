//
//  BDTableHeardView.m
//  QianYueBao
//
//  Created by Black on 17/4/5.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDTableHeardView.h"

@implementation BDAddOwnerView
@synthesize deleteView;


+ (instancetype)createOwnerView:(CGFloat)height title:(NSString *)title handler:(noParameterBlock)complete
{
    BDAddOwnerView *view = [[BDAddOwnerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) title:title handler:complete];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title handler:(noParameterBlock)complete
{
    if (self = [super initWithFrame:CGRectZero])
    {
        self.backgroundColor = WHITE_COLOR;
        
        CGFloat width = [BDStyle getWidthWithTitle:title font:15];
        UIView *leftView = [BDStyle createView:[UIColor subjectColor]];
        [self addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
        //    make.top.bottom.equalTo(self);
            make.width.mas_equalTo(width+BDHeight(10));
            make.bottom.equalTo(self).offset(BDHeight(-10));
            make.height.mas_equalTo(BDHeight(25));
        }];
        
        UIView *rigthView=  [BDStyle createView:[UIColor subjectColor]];
        rigthView.layer.cornerRadius = BDHeight(12.5);
        rigthView.layer.masksToBounds = YES;
        [leftView addSubview:rigthView];
        [rigthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(leftView).offset(BDHeight(12.5));
            make.size.mas_equalTo(CGSizeMake(BDHeight(25), BDHeight(25)));
            make.top.equalTo(leftView);
        }];
        
        
        UILabel *titleLbl  = [UILabel createLbl:title font:15 textColor:WHITE_COLOR];
        titleLbl.textAlignment = NSTextAlignmentRight;
        [leftView addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(leftView);
            make.right.equalTo(leftView).offset(BDHeight(-2.5));
        }];
        
        deleteView = [BDStyle createView:WHITE_COLOR];
        [self addSubview:deleteView];
        [deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(leftView.mas_centerY);
            make.right.equalTo(self);
            make.height.mas_equalTo(HScale*30);
            make.left.equalTo(leftView.mas_right).offset(BDHeight(12.5)+WScale*10);
        }];
        
       UIImageView * deleteImage = [UIImageView createImage:@"owner_delete"];
        [deleteView addSubview:deleteImage];
        [deleteImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(deleteView).offset(WScale*-15);
            make.size.mas_equalTo(CGSizeMake(WScale*11, WScale*11));
            make.centerY.mas_equalTo(deleteView.mas_centerY);
        }];
        
        UILabel * messageLbl = [UILabel createRightLbl:LS(@"Delete") font:12 textColor:[UIColor colorWithHexString:@"#fd655b"]];
        [deleteView addSubview:messageLbl];
        [messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(deleteView);
            make.right.equalTo(deleteImage.mas_left).offset(-3);
            make.left.equalTo(deleteView);
        }];
        
        UIButton *actionBnt = [UIButton buttonWithType:0];
        [[actionBnt rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            if (complete)
            {
                complete();
            }
        }];
        [deleteView addSubview:actionBnt];
        [actionBnt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(deleteView);
        }];
    }
    return self;
}

- (void)setIsDelete:(BOOL)isDelete
{
    deleteView.hidden = !isDelete;
    _isDelete = isDelete;
}
@end

#pragma mark -展开View

@implementation BDHeardView
@synthesize heardBtn;

+ (instancetype)createView:(CGFloat)height title:(NSString *)title handler:(noParameterBlock)complete
{
    BDHeardView *view = [[BDHeardView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) title:title handler:complete];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title handler:(noParameterBlock)complete
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = WHITE_COLOR;
        heardBtn = [BDTabHeardButton creatHeardBtn:title fatherView:self];
        UIButton *actionBnt = [UIButton buttonWithType:0];
        [[actionBnt rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            if (complete)
            {
                complete();
            }
        }];
        [self addSubview:actionBnt];
        [actionBnt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self);
        }];
    }
    return self;
}


@end


@implementation BDTableHeardView

+ (instancetype)createView:(UIView *)fatherView title:(NSString *)title
{
    BDTableHeardView *heardView = [[BDTableHeardView alloc]initWithFrame:CGRectZero title:title];
    [fatherView addSubview:heardView];
    [heardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(fatherView);
        make.top.equalTo(fatherView).offset(64);
        make.height.mas_equalTo(HScale*75);
    }];
    return heardView;
}
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *heardImage = [UIImageView createImage:@"wave"];
        [self addSubview:heardImage];
        [heardImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(HScale*55);
        }];
        
        CGFloat width = [BDStyle getWidthWithTitle:title font:15];
        UIView *leftView = [BDStyle createView:[UIColor subjectColor]];
        [self addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            //    make.top.bottom.equalTo(self);
            make.width.mas_equalTo(width+BDHeight(10));
            make.bottom.equalTo(self).offset(BDHeight(-10));
            make.height.mas_equalTo(BDHeight(25));
        }];
        
        UIView *rigthView=  [BDStyle createView:[UIColor subjectColor]];
        rigthView.layer.cornerRadius = BDHeight(12.5);
        rigthView.layer.masksToBounds = YES;
        [leftView addSubview:rigthView];
        [rigthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(leftView).offset(BDHeight(12.5));
            make.size.mas_equalTo(CGSizeMake(BDHeight(25), BDHeight(25)));
            make.top.equalTo(leftView);
        }];
        
        
        UILabel *titleLbl  = [UILabel createLbl:title font:15 textColor:WHITE_COLOR];
        titleLbl.textAlignment = NSTextAlignmentRight;
        [leftView addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(leftView);
            make.right.equalTo(leftView).offset(BDHeight(-2.5));
        }];
    }
    return self;
}

@end

@implementation BDChartHeardView

+ (void)createHeardView:(UIView *)fatherView
{
    BDChartHeardView *heardView = [[BDChartHeardView alloc]initWithFrame:CGRectZero];
    [fatherView addSubview:heardView];
    [heardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(fatherView);
        make.top.equalTo(fatherView).offset(64);
        make.height.mas_equalTo(BDHeight(60));
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UILabel *rankLbl = [UILabel createLbl:LS(@"Rank") font:15 textColor:[UIColor nineSixColor]];
        [self addSubview:rankLbl];
        [rankLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.width.mas_equalTo(WScale*80);
        }];
        
        UILabel *moneyLbl = [UILabel createLbl:LS(@"Trading_Volume") font:15 textColor:[UIColor nineSixColor]];
        [self addSubview:moneyLbl];
        [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(WScale*-15);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo((SCREEN_WIDTH-WScale*130)/2);
        }];
        
        UILabel *nameLbl = [UILabel createLbl:LS(@"Shop_Name") font:15 textColor:[UIColor nineSixColor]];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moneyLbl.mas_left).offset(WScale*-10);
            make.top.bottom.equalTo(self);
            make.left.equalTo(rankLbl.mas_right).offset(WScale*10);
        }];
        
        UIView *lineView = [BDStyle createView:[UIColor lineColor]];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self).offset(WScale*15);
        }];

    }
    return self;
}

@end
