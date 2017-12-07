//
//  BDShopLogoTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/5/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDShopLogoTableViewCell : UITableViewCell<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *logoImage;

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, copy) BDHandler logoUrlHandler;

- (void)bindMessage:(NSString *)title message:(NSString *)logoUrl;

@end
