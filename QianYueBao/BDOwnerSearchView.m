//
//  BDOwnerSearchView.m
//  QianYueBao
//
//  Created by Black on 17/5/4.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDOwnerSearchView.h"

@implementation BDOwnerSearchView

+ (void)createSearchView:(BDSuperViewController *)vc handler:(BDHandler)complete
{
    BDOwnerSearchView *searchView = [[BDOwnerSearchView alloc]initWithFrame:CGRectZero createSearchView:vc handler:complete];
    [vc.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(vc.view);
        make.height.mas_equalTo(@64);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame createSearchView:(BDSuperViewController *)vc handler:(BDHandler)complete
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor subjectColor];
        self.handler = complete;
        
        CGFloat width = [BDStyle getWidthWithTitle:LS(@"BACK") font:16]+WScale*18;
        BDBackButton  *backButton = [BDBackButton button:CGRectZero];
        [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [vc.navigationController popViewControllerAnimated:YES];
        }];
        [self addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(WScale*10);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(width);
            
        }];
        
        CGFloat createWidth = [BDStyle getWidthWithTitle:LS(@"Create_New") font:16];
        UIButton *createBtn = [UIButton createBtn:@"" font:16 textColor:WHITE_COLOR complete:^{
            BDOwnerMessageViewController *mVc = [[BDOwnerMessageViewController alloc]init];
            mVc.pushNumber = vc.pushNumber;
            [vc pushAction:mVc];
        }];
        [createBtn setAttributedTitle:[NSString getStr:LS(@"Create_New") textColor:WHITE_COLOR]
                          forState:UIControlStateNormal];
        [self addSubview:createBtn];
        [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(WScale*-10);
            make.bottom.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(createWidth+5, 44));
        }];
        
        UIView *searchView = [[UIView alloc]initWithFrame:CGRectZero];
        searchView.layer.borderWidth = 0.5;
        searchView.layer.borderColor = WHITE_COLOR.CGColor;
        searchView.layer.masksToBounds = YES;
        searchView.backgroundColor = [WHITE_COLOR colorWithAlphaComponent:0];
        searchView.layer.cornerRadius = 15;
        [self addSubview:searchView];
        [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(backButton.mas_centerY);
            make.left.equalTo(backButton.mas_right).offset(WScale*8);
            make.right.equalTo(createBtn.mas_left).offset(WScale*-8);
            make.height.mas_equalTo(30);
        }];
        
        
        UIImageView *searchImage = [UIImageView createImage:@"homeSearch"];
        [searchView addSubview:searchImage];
        [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(HScale*18, HScale*18));
            make.centerY.mas_equalTo(searchView.mas_centerY);
            make.left.equalTo(searchView).offset(WScale*8);
        }];
        
        UITextField *searchText = [UITextField createText:LS(@"Search_Owner") font:15 textColor:WHITE_COLOR];
        searchText.delegate = self;
        searchText.returnKeyType = UIReturnKeySearch;
        [searchView addSubview:searchText];
        [searchText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(searchView);
            make.left.equalTo(searchImage.mas_right).offset(WScale*5);
        }];
        
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.handler)
    {
        self.handler(textField.text);
    }
    return YES;
}

@end
