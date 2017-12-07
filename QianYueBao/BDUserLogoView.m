//
//  BDUserLogoView.m
//  QianYueBao
//
//  Created by Black on 17/4/21.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDUserLogoView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation BDUserLogoView
@synthesize heardImage;
@synthesize currentVC;

+ (instancetype)createLogoView:(UIViewController *)vc
{
    BDUserLogoView *logo = [[BDUserLogoView alloc]initWithFrame:CGRectZero currentVC:vc];
    [vc.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(vc.view);
        make.top.equalTo(vc.view).offset(64);
        make.height.mas_equalTo(HScale*80);
    }];
    return logo;
}

- (instancetype)initWithFrame:(CGRect)frame currentVC:(UIViewController *)vc
{
    if (self = [super initWithFrame:frame])
    {
        self.currentVC = vc;
        UILabel *titleLbl = [UILabel createNoramlLbl:LS(@"Profile_Picture") font:15 textColor:[UIColor nineSixColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.width.mas_equalTo([BDStyle getWidthWithTitle:titleLbl.text font:15]);
        }];
        
        heardImage = [UIImageView createImage:@"head"];
        heardImage.contentMode =  UIViewContentModeScaleAspectFill;
        heardImage.layer.cornerRadius = HScale*30;
        heardImage.layer.masksToBounds = YES;
        heardImage.layer.borderWidth = 0.5;
        heardImage.userInteractionEnabled = YES;
        heardImage.layer.borderColor = RGB(210, 210, 210).CGColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [heardImage addGestureRecognizer:tap];
        [self addSubview:heardImage];
        [heardImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(HScale*60, HScale*60));
            make.right.equalTo(self).offset(WScale*-17);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIView *lineView = [BDStyle createView:[UIColor cEightColor]];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.left.equalTo(self).offset(WScale*15);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)tapAction
{
    if (currentVC)
    {
        ActionSheet *action=[[ActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:LS(@"Cancel") destructiveButtonTitle:LS(@"Take_Picture") otherButtonTitles:LS(@"Select_From_Album"),nil];
        action.tag=1;
        [action showInView:currentVC.view];
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
                
                [currentVC presentViewController:controller animated:YES completion:nil];
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
                [currentVC presentViewController:controller animated:YES completion:nil];
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
         
         NSData *data = UIImageJPEGRepresentation(photo, 1);
         self.heardImage.image = photo;
         NSString *str = READ_MESSAGE(User_ID, @"shopLogo");
         SET_USER_DEFAULT(data, str);
         SYN_USER_DEFAULT;
         [BDStyle handlerDataError:LS(@"Save_Success") currentVC:currentVC handler:nil];
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



@end
