//
//  UIButton+BDButtonSet.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "UIButton+BDButtonSet.h"

@implementation UIButton (BDButtonSet)

+ (instancetype)createBtn:(NSString *)title bgColor:(UIColor *)bgColor titleColor:(UIColor *)titColor font:(CGFloat)font complete:(void (^)(void))handler
{
    UIButton *button =[UIButton buttonWithType:0];
    [button setTitle:title forState:0];
    button.backgroundColor = bgColor;
    [button setTitleColor:titColor forState:0];
    button.layer.cornerRadius = HScale*20;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = FONTSIZE(font);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (handler)
        {
            handler();
        }
    }];
    return button;
}

+ (instancetype)createBtn:(NSString *)title bgImage:(NSString *)bgName titleColor:(UIColor *)titColor font:(CGFloat)font complete:(void (^)(void))handler
{
    UIButton *button = [UIButton buttonWithType:0];
    [button setTitle:title forState:0];
    [button setBackgroundImage:IMAGE_NAME(bgName) forState:0];
    [button setTitleColor:titColor forState:0];
    button.layer.cornerRadius = HScale*20;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = FONTSIZE(font);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (handler)
        {
            handler();
        }
    }];
    return button;
}

+ (instancetype)createBtn:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor complete:(void (^)(void))handler
{
    UIButton *button = [UIButton buttonWithType:0];
    [button setTitle:title forState:0];
    [button setTitleColor:textColor forState:0];
    button.titleLabel.font = FONTSIZE(font);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (handler)
        {
            handler();
        }
    }];
    return button;
}

+ (instancetype)buttonOnlyImage:(NSString *)imageName fatherView:(UIView *)fatherView action:(noParameterBlock)handler
{
    UIButton *button = [UIButton buttonWithType:0];
    [button setBackgroundImage:IMAGE_NAME(imageName) forState:0];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (handler)
        {
            handler();
        }
    }];
    [fatherView addSubview:button];
    return button;
}

- (void)racIsEnable:(UITextField *)nameTxt passText:(UITextField *)passText
{
    RACSignal *oldPassSingal = [nameTxt.rac_textSignal map:^id(NSString *text) {
        return @(text.length >= 1);
    }];
    RACSignal *newPassSignal = [passText.rac_textSignal map:^id(NSString *text) {
        return @(text.length >= 1);
    }];
    
    [[RACSignal combineLatest:@[oldPassSingal,newPassSignal] reduce:^id(NSNumber *usernameValid , NSNumber *passwordValid){
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }]
     subscribeNext:^(NSNumber *loginBtnSingal) {
         self.enabled = [loginBtnSingal boolValue];
//         if ([loginBtnSingal boolValue])
//         {
//             [self setBackgroundImage:IMAGE_NAME(@"login_button") forState:0];
//         }
//         else
//         {
//             [self setBackgroundImage:[BDStyle imageWithColor:RGB(210, 210, 210) size:CGSizeMake(1, 1)] forState:0];
//         }
     }];

}

- (void)racIsEnableWithModel:(BDSignDetailModel *)model backColor:(UIColor *)bgColor
{
    [model.contractModel racIsAllMessage];
    RACSignal *ownerSigal = [RACObserve(model,haveOwner) map:^id(id value) {
        return value;
    }];
    RACSignal *logoSigal = [RACObserve(model.basicModel,shopLogo) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    
    RACSignal *locationSigal = [RACObserve(model.basicModel,geo_lat) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    
    RACSignal *titleSigal = [RACObserve(model.basicModel,title) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *countrySigal = [RACObserve(model.basicModel,loc_country) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *stateSigal = [RACObserve(model.basicModel,loc_state) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *citySigal = [RACObserve(model.basicModel,loc_city) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *addressSigal = [RACObserve(model.basicModel,geo_address) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *circleSigal = [RACObserve(model.basicModel,commercial_circle) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *categorySigal = [RACObserve(model.basicModel,category) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *platformSigal = [RACObserve(model.basicModel,comp_platform_string) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *serviceSigal = [RACObserve(model.basicModel,support_service_message) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *thumSigal = [RACObserve(model.basicModel,thumbnails) map:^id(id value) {
        NSArray *array = value;
        return @(array.count!=0);
    }];
    
    RACSignal *preSigal = [RACObserve(model.contractModel,isAllMessage) map:^id(id value) {
        return value;
    }];
    
    [[RACSignal combineLatest:@[ownerSigal,titleSigal,countrySigal,stateSigal,citySigal,addressSigal,circleSigal,categorySigal,platformSigal,serviceSigal,preSigal,locationSigal,logoSigal,thumSigal] reduce:^id(NSNumber *valid1 , NSNumber *valid2,NSNumber *valid3,NSNumber *valid4,NSNumber *valid5,NSNumber *valid6,NSNumber *valid7,NSNumber *valid8,NSNumber *valid9,NSNumber *valid10,NSNumber *valid11,NSNumber *valid12,NSNumber *valid13,NSNumber *valid14){
        return @([valid1 boolValue] && [valid2 boolValue] && [valid3 boolValue] && [valid4 boolValue] && [valid5 boolValue] && [valid6 boolValue] && [valid7 boolValue] && [valid8 boolValue] && [valid9 boolValue] && [valid10 boolValue] && [valid11 boolValue] && [valid12 boolValue] && [valid13 boolValue] && [valid14 boolValue]
        );
    }]
     subscribeNext:^(NSNumber *loginBtnSingal) {
         self.enabled = [loginBtnSingal boolValue];
         if ([loginBtnSingal boolValue])
         {
             self.backgroundColor = bgColor;
         }
         else
         {
             self.backgroundColor = RGB(210, 210, 210);
         }
     }];

}

#pragma mark- 店主信息是否完整
- (void)racIsEnableWithOwner:(BDOwnerModel *)model
{
    RACSignal *nameSigal = [RACObserve(model,ownerName) map:^id(id value) {
        return @(![value isEqualToString:@""] && value != nil);
    }];
    RACSignal *nickSigal = [RACObserve(model,account_name) map:^id(id value) {
        return @(![value isEqualToString:@""] && value != nil);
    }];
    RACSignal *IDSigal = [RACObserve(model,IDNumber) map:^id(id value) {
        return @(![value isEqualToString:@""] && value != nil);
    }];
    RACSignal *codeSigal = [RACObserve(model,countey_code) map:^id(id value) {
        return @(![value isEqualToString:@""]&& value != nil);
    }];
    RACSignal *stateSigal = [RACObserve(model,province) map:^id(id value) {
        return @(![value isEqualToString:@""]&& value != nil);
    }];
    RACSignal *citySigal = [RACObserve(model,city) map:^id(id value) {
        return @(![value isEqualToString:@""]&& value != nil);
    }];
    RACSignal *addressSigal = [RACObserve(model,contact_assress) map:^id(id value) {
        return @(![value isEqualToString:@""]&& value != nil);
    }];
    RACSignal *phoneSigal = [RACObserve(model,phone) map:^id(id value) {
        return @(![value isEqualToString:@""]&& value != nil);
    }];
    RACSignal *mobilSigal = [RACObserve(model,mobil_phone) map:^id(id value) {
        return @(![value isEqualToString:@""]&& value != nil);
    }];
    RACSignal *emailSigal = [RACObserve(model,email) map:^id(id value) {
        return @(![value isEqualToString:@""]&& value != nil);
    }];
    RACSignal *bankNameSigal = [RACObserve(model,bank_name) map:^id(id value) {
        return @(![value isEqualToString:@""]&& value != nil);
    }];
    RACSignal *branchSigal = [RACObserve(model,branch) map:^id(id value) {
        return @(![value isEqualToString:@""]&& value != nil);
    }];
    RACSignal *swiftSigal = [RACObserve(model,swift_code) map:^id(id value) {
        return @(![value isEqualToString:@""]&& value != nil);
    }];
    RACSignal *accountNameSigal = [RACObserve(model,bank_name) map:^id(id value) {
        return @(![value isEqualToString:@""]&& value != nil);
    }];
    RACSignal *accountNumberSigal = [RACObserve(model,bank_number) map:^id(id value) {
        return @(![value isEqualToString:@""]&& value != nil);
    }];
    
    [[RACSignal combineLatest:@[nameSigal,nickSigal,IDSigal,codeSigal,stateSigal,citySigal,addressSigal,phoneSigal,mobilSigal,emailSigal,bankNameSigal,branchSigal,swiftSigal,accountNameSigal,accountNumberSigal] reduce:^id(NSNumber *valid1 , NSNumber *valid2,NSNumber *valid3,NSNumber *valid4,NSNumber *valid5,NSNumber *valid6,NSNumber *valid7,NSNumber *valid8,NSNumber *valid9,NSNumber *valid10,NSNumber *valid11,NSNumber *valid12,NSNumber *valid13,NSNumber *valid14,NSNumber *valid15){
        return @([valid1 boolValue] && [valid2 boolValue] && [valid3 boolValue] && [valid4 boolValue] && [valid5 boolValue] && [valid6 boolValue] && [valid7 boolValue] && [valid8 boolValue] && [valid9 boolValue] && [valid10 boolValue] && [valid11 boolValue] && [valid12 boolValue] && [valid13 boolValue] && [valid14 boolValue] && [valid15 boolValue]);
    }]
     subscribeNext:^(NSNumber *loginBtnSingal) {
         self.enabled = [loginBtnSingal boolValue];
         if ([loginBtnSingal boolValue])
         {
             self.backgroundColor = [UIColor subjectColor];
         }
         else
         {
             self.backgroundColor = RGB(210, 210, 210);
         }
     }];
}

#pragma mark - 合同信息是否完整
- (void)racIsEnableWithContract:(BDContractModel *)model
{
    RACSignal *nameSigal = [RACObserve(model,premium_rate) map:^id(id value) {
        return @(![value isEqualToString:@""] && value != nil);
    }];
    RACSignal *nickSigal = [RACObserve(model,payment_channel_string) map:^id(id value) {
        return @(![value isEqualToString:@""] && value != nil);
    }];
    RACSignal *IDSigal = [RACObserve(model,settlement_term) map:^id(id value) {
        return @(![value isEqualToString:@""] && value != nil);
    }];
    RACSignal *thumSigal = [RACObserve(model,contract_image) map:^id(id value) {
        NSArray *array = value;
        return @(array.count!=0);
    }];
    
    [[RACSignal combineLatest:@[nameSigal,nickSigal,IDSigal,thumSigal] reduce:^id(NSNumber *valid1 , NSNumber *valid2,NSNumber *valid3,NSNumber *valid4){
        return @([valid1 boolValue] && [valid2 boolValue] && [valid3 boolValue] && [valid4 boolValue]);
    }]
     subscribeNext:^(NSNumber *loginBtnSingal) {
         self.enabled = [loginBtnSingal boolValue];
         if ([loginBtnSingal boolValue])
         {
             [self setTitle:LS(@"Change") forState:UIControlStateNormal];
             self.backgroundColor = [UIColor subjectColor];
         }
         else
         {
             self.backgroundColor = RGB(210, 210, 210);
             [self setTitle:[model statusMessage:model.contract_status] forState:UIControlStateNormal];
         }
     }];
}

#pragma mark - 店主信息是否完整
- (void)racISEnableWithShopBasic:(BDSignDetailModel *)model
{
    RACSignal *ownerSigal = [RACObserve(model,haveOwner) map:^id(id value) {
        return value;
    }];
    RACSignal *logoSigal = [RACObserve(model.basicModel,shopLogo) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    
    RACSignal *locationSigal = [RACObserve(model.basicModel,geo_lat) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    
    RACSignal *titleSigal = [RACObserve(model.basicModel,title) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *countrySigal = [RACObserve(model.basicModel,loc_country) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *stateSigal = [RACObserve(model.basicModel,loc_state) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *citySigal = [RACObserve(model.basicModel,loc_city) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *addressSigal = [RACObserve(model.basicModel,geo_address) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *circleSigal = [RACObserve(model.basicModel,commercial_circle) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *categorySigal = [RACObserve(model.basicModel,category) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *platformSigal = [RACObserve(model.basicModel,comp_platform_string) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *serviceSigal = [RACObserve(model.basicModel,support_service_message) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *thumSigal = [RACObserve(model.basicModel,thumbnails) map:^id(id value) {
        NSArray *array = value;
        return @(array.count!=0);
    }];
    
    [[RACSignal combineLatest:@[ownerSigal,titleSigal,countrySigal,stateSigal,citySigal,addressSigal,circleSigal,categorySigal,platformSigal,serviceSigal,locationSigal,logoSigal,thumSigal] reduce:^id(NSNumber *valid1 , NSNumber *valid2,NSNumber *valid3,NSNumber *valid4,NSNumber *valid5,NSNumber *valid6,NSNumber *valid7,NSNumber *valid8,NSNumber *valid9,NSNumber *valid10,NSNumber *valid11,NSNumber *valid12,NSNumber *valid13){
        return @([valid1 boolValue] && [valid2 boolValue] && [valid3 boolValue] && [valid4 boolValue] && [valid5 boolValue] && [valid6 boolValue] && [valid7 boolValue] && [valid8 boolValue] && [valid9 boolValue] && [valid10 boolValue] && [valid11 boolValue] && [valid12 boolValue] && [valid13 boolValue] 
        );
    }]
     subscribeNext:^(NSNumber *loginBtnSingal) {
         self.enabled = [loginBtnSingal boolValue];
         if ([loginBtnSingal boolValue])
         {
             self.backgroundColor = [UIColor subjectColor];
         }
         else
         {
             self.backgroundColor = RGB(210, 210, 210);
         }
     }];

}

@end
