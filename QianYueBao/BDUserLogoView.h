//
//  BDUserLogoView.h
//  QianYueBao
//
//  Created by Black on 17/4/21.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDUserLogoView : UIView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *heardImage;

@property (nonatomic, strong) UIViewController *currentVC;

+ (instancetype)createLogoView:(UIViewController *)vc;


@end
