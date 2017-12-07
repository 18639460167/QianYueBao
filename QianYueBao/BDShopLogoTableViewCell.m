//
//  BDShopLogoTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/5/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDShopLogoTableViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation BDShopLogoTableViewCell
@synthesize logoImage;
@synthesize titleLbl;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        logoImage = [UIImageView createImage:@"shopPlace"];
        logoImage.contentMode =  UIViewContentModeScaleAspectFill;
        logoImage.layer.cornerRadius = HScale*30;
        logoImage.layer.masksToBounds = YES;
        logoImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [logoImage addGestureRecognizer:tap];
        [self addSubview:logoImage];
        [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(HScale*60, HScale*60));
            make.right.equalTo(self).offset(WScale*-15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        titleLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.right.equalTo(logoImage.mas_left).offset(WScale*-8);
        }];
        
        UIImageView *lineImage = [UIImageView new];
        lineImage.image = [BDStyle imageWithColor:[UIColor cEightColor] size:CGSizeMake(1, 1)];
        [self addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)bindMessage:(NSString *)title message:(NSString *)logoUrl
{
    titleLbl.text = title;
    [logoImage sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:[UIImage imageNamed:@"shopPlace"] options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)tapAction
{
    if (self.vc)
    {
        ActionSheet *action=[[ActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:LS(@"Cancel") destructiveButtonTitle:LS(@"Take_Picture") otherButtonTitles:LS(@"Select_From_Album"),nil];
        action.tag=1;
        [action showInView:self.vc.view];
    }
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0) //take photo
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
                && [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
                {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                
                [self.vc presentViewController:controller animated:YES completion:nil];
            }
        }
        else if (buttonIndex == 1) //choose photo
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                if ([controller.navigationBar respondsToSelector:@selector(setBarTintColor:)])
                {
                    [controller.navigationBar setBarTintColor:[UIColor subjectColor]];
                    [controller.navigationBar setTranslucent:NO];
                    [controller.navigationBar setTintColor:[UIColor whiteColor]];
                }
                else
                {
                    [controller.navigationBar setBackgroundColor:[UIColor subjectColor]];
                }
                NSDictionary *attributes = @{NSFontAttributeName:FONTSIZE(18),NSForegroundColorAttributeName:[UIColor whiteColor]};
                [controller.navigationBar setTitleTextAttributes:attributes];
                [self.vc presentViewController:controller animated:YES completion:nil];
            }
        }
    }
    else if (actionSheet.tag == 2)
    {
        
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^()
     {
         UIImage *photo = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
         photo = [BDStyle imageByScalingToMaxSize:photo];
         [BDStyle showLoading:@"" rootView:self.vc.view];
         [BDCommonVieModel updatePicture:@[photo] handler:^(NSString *logoUrl, BOOL success) {
             NSString *str = logoUrl;
             if (success)
             {
                 str = LS(@"Update_Success");
                [logoImage sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:[UIImage imageNamed:@"shopPlace"] options:SDWebImageAllowInvalidSSLCertificates];
                 if (self.logoUrlHandler)
                 {
                     self.logoUrlHandler(logoUrl);
                 }
             }
             [BDStyle handlerDataError:str currentVC:self.vc handler:nil];
             
         }];
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if (paramMediaType.length == 0)
    {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop)
     {
         NSString *mediaType = (NSString *)obj;
         if ([mediaType isEqualToString:paramMediaType])
         {
             result = YES;
             *stop= YES;
         }
     }];
    return result;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
