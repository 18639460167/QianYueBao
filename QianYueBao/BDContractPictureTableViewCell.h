//
//  BDContractPictureTableViewCell.h
//  QianYueBao
//
//  Created by Black on 17/4/5.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPhotoPickerBrowserViewController.h"

@interface BDPhotoImageView : UIImageView

@property (nonatomic, copy) noParameterBlock complete;

+ (instancetype)createImageWithFrame:(CGRect)frame;

@end

@interface BDPictureView : UIView<HYPhotoPickerBrowserViewControllerDelegate>

@property (nonatomic, copy) void (^deleteComplete) (int value);
@property (nonatomic, strong) UIViewController *VC;

@property (nonatomic, assign) BOOL imgCanEdit;
+ (instancetype)createView;

- (void)reloadData:(NSArray *)pictureArray currentVC:(UIViewController *)vc;

@end

@interface BDContractPictureTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^contractImage)(NSArray *picArr);

@property (nonatomic, assign) BOOL canEdit;

- (void)bindTitle:(NSString *)title currentVC:(UIViewController *)currenVC;

- (void)bindData:(NSArray *)dataArray;


@end
