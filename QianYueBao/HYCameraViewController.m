//
//  HYCameraViewController.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYCameraViewController.h"
#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>
#import "HYCameraImageView.h"
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import "HYCameraView.h"
#import "HYPhoto.h"
#import "UIImage+HYPhotoLib.h"
#import "UIViewController+Alert.h"

typedef NS_ENUM(NSInteger, XGImageOrientation) {
    XGImageOrientationUp,            // default orientation
    XGImageOrientationDown,          // 180 deg rotation
    XGImageOrientationLeft,          // 90 deg CCW
    XGImageOrientationRight,         // 90 deg CW
    XGImageOrientationUpMirrored,    // as above but image mirrored along other axis. horizontal flip
    XGImageOrientationDownMirrored,  // horizontal flip
    XGImageOrientationLeftMirrored,  // vertical flip
    XGImageOrientationRightMirrored, // vertical flip
};

typedef void(^codeBlock)();
static CGFloat ZLCameraColletionViewW = 80;
static CGFloat ZLCameraColletionViewPadding = 20;
static CGFloat BOTTOM_HEIGHT = 60;

@interface HYCameraViewController ()<UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AVCaptureMetadataOutputObjectsDelegate,HYCameraImageViewDelegate,HYCameraViewDelegate,HYPhotoPickerBrowserViewControllerDelegate,UIAlertViewDelegate>

@property (weak ,  nonatomic) HYCameraView *caramView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIViewController *currentViewController;

// Datas
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableDictionary *dictM;

// 陀螺仪,检测屏幕方向
@property (nonatomic, strong) CMMotionManager * motionManager;

// AVFoundation
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;
@property (strong, nonatomic) AVCaptureDevice *device;

@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, assign) XGImageOrientation imageOrientation;

@end

@implementation HYCameraViewController

#pragma mark Data
- (NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableDictionary *)dictM{
    if (!_dictM) {
        _dictM = [NSMutableDictionary dictionary];
    }
    return _dictM;
}

#pragma mark View
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(ZLCameraColletionViewW, ZLCameraColletionViewW);
        layout.minimumLineSpacing = ZLCameraColletionViewPadding;
        
        CGFloat collectionViewH = ZLCameraColletionViewW;
        CGFloat collectionViewY = self.caramView.hy_height - collectionViewH - 10;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, collectionViewY, self.view.hy_width, collectionViewH)
                                                              collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.caramView addSubview:collectionView];
        self.collectionView = collectionView;
    }
    return _collectionView;
}


- (void)startMotionManager{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/15.0;
    if (_motionManager.deviceMotionAvailable) {
        NSLog(@"Device Motion Available");
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                                [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                                
                                            }];
    } else {
        NSLog(@"No device motion on device.");
        [self setMotionManager:nil];
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    NSNumber *value = nil;
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
            value = [NSNumber numberWithInt:UIDeviceOrientationPortraitUpsideDown];
        }
        else{
            value = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        }
    }
    else
    {
        if (x >= 0){
            value = [NSNumber numberWithInt:UIDeviceOrientationLandscapeRight];
        }
        else{
            value = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
        }
    }
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [self gettingOrientation];
}

- (void) initialize
{
    //1.创建会话层
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.captureOutput setOutputSettings:outputSettings];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:_captureOutput])
    {
        [self.session addOutput:_captureOutput];
    }
    
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.bounds;
    
    HYCameraView *caramView = [[HYCameraView alloc] initWithFrame:CGRectMake(0, 40, self.view.hy_width, self.view.hy_height - 40 - BOTTOM_HEIGHT)];
    caramView.backgroundColor = [UIColor clearColor];
    caramView.delegate = self;
    [self.view addSubview:caramView];
    [self.view.layer insertSublayer:self.preview atIndex:0];
    self.caramView = caramView;
}

- (void)cameraDidSelected:(HYCameraView *)camera
{
    [self.device lockForConfiguration:nil];
    [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
    [self.device setFocusPointOfInterest:CGPointMake(50,50)];
    //操作完成后，记得进行unlock。
    [self.device unlockForConfiguration];
}

//对焦回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if( [keyPath isEqualToString:@"adjustingFocus"] ){}
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initialize];
    [self setup];
    // 开启陀螺仪
    [self startMotionManager];
    if (self.session) {
        [self.session startRunning];
    }
}

#pragma mark 初始化按钮
- (UIButton *) setupButtonWithImageName : (NSString *) imageName andX : (CGFloat ) x{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage ml_imageFormBundleNamed:imageName] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.hy_width = 50;
    button.hy_y = 0;
    button.hy_height = self.topView.hy_height;
    button.hy_x = x;
    [self.view addSubview:button];
    return button;
}

#pragma mark -初始化界面
- (void) setup{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    CGFloat width = 50;
    CGFloat margin = 20;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    topView.frame = CGRectMake(0, 0, self.view.hy_width, 40);
    [self.view addSubview:topView];
    self.topView = topView;
    
    // 头部View
    UIButton *deviceBtn = [self setupButtonWithImageName:@"xiang" andX:self.view.hy_width - margin - width];
    [deviceBtn addTarget:self action:@selector(changeCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *flashBtn = [self setupButtonWithImageName:@"shanguangdeng" andX:10];
    [flashBtn addTarget:self action:@selector(flashCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeBtn = [self setupButtonWithImageName:@"shanguangdeng2" andX:60];
    [closeBtn addTarget:self action:@selector(closeFlashlight:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 底部View
    UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.hy_height-BOTTOM_HEIGHT, self.view.hy_width, BOTTOM_HEIGHT)];
    controlView.backgroundColor = [UIColor clearColor];
    self.controlView = controlView;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = controlView.bounds;
    contentView.backgroundColor = [UIColor blackColor];
    contentView.alpha = 0.3;
    [controlView addSubview:contentView];
    
    CGFloat x = (self.view.hy_width - width) / 3;
    //取消
    UIButton *cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancalBtn.frame = CGRectMake(margin, 0, x, controlView.hy_height);
    [cancalBtn setTitle:LS(@"Cancel") forState:UIControlStateNormal];
    [cancalBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:cancalBtn];
    //拍照
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(x+margin, margin / 4, x, controlView.hy_height - margin / 2);
    cameraBtn.showsTouchWhenHighlighted = YES;
    cameraBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cameraBtn setImage:[UIImage ml_imageFormBundleNamed:@"paizhao"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(stillImage:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:cameraBtn];
    // 完成
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(self.view.hy_width - 2 * margin - width, 0, width, controlView.hy_height);
    [doneBtn setTitle:LS(@"Finish") forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:doneBtn];
    
    [self.view addSubview:controlView];
}

- (NSInteger ) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger ) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    HYCamera *camera = self.images[indexPath.item];
    
    HYCameraImageView *lastView = [cell.contentView.subviews lastObject];
    if(![lastView isKindOfClass:[HYCameraImageView class]]){
        // 解决重用问题
        UIImage *image = camera.thumbImage;
        HYCameraImageView *imageView = [[HYCameraImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.delegate = self;
        imageView.edit = YES;
        imageView.image = image;
        imageView.frame = cell.bounds;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
    }
    
    lastView.image = camera.thumbImage;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *photos = [NSMutableArray array];
    for (id asset in self.images)
    {
        HYPhotoPickerBrowerPhoto *photo = [[HYPhotoPickerBrowerPhoto alloc] init];
        if ([asset isKindOfClass:[HYPhotoAssets class]]) {
            photo.asset = asset;
        }else if ([asset isKindOfClass:[HYCamera class]]){
            HYCamera *camera = (HYCamera *)asset;
            photo.thumbImage = [camera thumbImage];
        }else if ([asset isKindOfClass:[UIImage class]]){
            photo.thumbImage = (UIImage *)asset;
            photo.photoImage = (UIImage *)asset;
        }
        [photos addObject:photo];
    }
    
    HYPhotoPickerBrowserViewController *browserVc = [[HYPhotoPickerBrowserViewController alloc] init];
    browserVc.photos = photos;
    browserVc.delegate = self;
    browserVc.currentIndex = indexPath.item;
    [self presentViewController:browserVc animated:NO completion:nil];
}

- (void)photoBrowser:(HYPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index
{
    [self.images removeObjectAtIndex:index];
    [self.collectionView reloadData];
}
- (void)deleteImageView:(HYCameraImageView *)imageView{
    NSMutableArray *arrM = [self.images mutableCopy];
    for (HYCamera *camera in self.images) {
        UIImage *image = camera.thumbImage;
        if ([image isEqual:imageView.image]) {
            [arrM removeObject:camera];
        }
    }
    self.images = arrM;
    [self.collectionView reloadData];
}

- (void)showPickerVc:(UIViewController *)vc{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusDenied){
        // denied
        CGFloat kSystemMainVersion = [UIDevice currentDevice].systemVersion.floatValue;
        NSString *title = nil;
        NSString *msg = LS(@"Picture_Alert");
        NSString *cancelTitle = LS(@"Temporarily");
        NSString *otherButtonTitles = LS(@"Go_Set");
        
        if (kSystemMainVersion < 8.0) {
            title = LS(@"Album_Permissions_Not_Open");
            msg = LS(@"Set_Album_Permission");
            cancelTitle = LS(@"Determine");
            otherButtonTitles = nil;
        }
        
        [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:otherButtonTitles, nil] show];
    }
    
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        [weakVc presentViewController:self animated:YES completion:nil];
    }
}

-(void)Captureimage
{
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //get UIImage
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         CFDictionaryRef exifAttachments =
         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [UIImage imageWithData:imageData];
         
         NSDateFormatter *formater = [[NSDateFormatter alloc] init];
         formater.dateFormat = @"yyyyMMddHHmmss";
         NSString *currentTimeStr = [[formater stringFromDate:[NSDate date]] stringByAppendingFormat:@"_%d" ,arc4random_uniform(10000)];
         
         t_image = [self fixOrientation:t_image];
         
         NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:currentTimeStr];
         [UIImagePNGRepresentation(t_image) writeToFile:path atomically:YES];
         
         ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
         [assetsLibrary writeImageToSavedPhotosAlbum:[t_image CGImage] orientation:(ALAssetOrientation)t_image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
             if (error) {
                 NSLog(@"Save image fail：%@",error);
             }else{
                 NSLog(@"Save image succeed.");
             }
         }];
         
         NSData *data = UIImageJPEGRepresentation(t_image, 0.3);
         HYCamera *camera = [[HYCamera alloc] init];
         camera.imagePath = path;
         camera.thumbImage = [UIImage imageWithData:data];
         [self.images addObject:camera];
         
         [self.collectionView reloadData];
         [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.images.count - 1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
         
     }];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

- (void)changeCameraDevice:(id)sender
{
    // 翻转
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            break;
        }
    }
}

- (void) flashLightModel : (codeBlock) codeBlock{
    if (!codeBlock) return;
    [self.session beginConfiguration];
    [self.device lockForConfiguration:nil];
    codeBlock();
    [self.device unlockForConfiguration];
    [self.session commitConfiguration];
    [self.session startRunning];
}
- (void) flashCameraDevice:(UIButton *)sender{
    [self flashLightModel:^{
        [self.device setTorchMode:AVCaptureTorchModeOn];
    }];
}

- (void) closeFlashlight:(UIButton *)sender{
    // self.device.torchMode == AVCaptureTorchModeOff 判断
    [self flashLightModel:^{
        [self.device setTorchMode:AVCaptureTorchModeOff];
    }];
}

- (void)cancel:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//完成、取消
- (void)doneAction
{
    //关闭相册界面
    if(self.callback)
    {
        self.callback(self.images);
    }
    if (self.cameraBack)
    {
        self.cameraBack(self.images);
    }
    [self cancel:nil];
}

//拍照
- (void)stillImage:(id)sender
{
    // 判断图片的限制个数
    if (self.maxCount > 0 && self.images.count >= self.maxCount) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"U-Travel" message:[NSString stringWithFormat:LS(@"Number_Photos_Unexceed"),(long)self.maxCount]delegate:nil cancelButtonTitle:LS(@"Determine") otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self Captureimage];
        UIView *maskView = [[UIView alloc] init];
        maskView.frame = self.view.bounds;
        maskView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:maskView];
        [UIView animateWithDuration:.5 animations:^{
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [maskView removeFromSuperview];
        }];
    });
    
}

- (void)dealloc{
    [_motionManager stopDeviceMotionUpdates];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotate{
    return NO;
}

#pragma mark - 屏幕
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
// 支持屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return NO;
}
// 画面一开始加载时就是竖向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


- (UIImage *)fixOrientation:(UIImage *)srcImg
{
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    //优于srcImg.gettingOrientation的值有问题，横竖屏拍照它的值不变。所以现在根据机器硬件的当前旋转方向，来确定自定义imageOrientation，根据这个值来翻转image
    [self gettingOrientation];
    
    CGFloat width = srcImg.size.width;
    CGFloat height = srcImg.size.height;
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        width = srcImg.size.height;
        height = srcImg.size.width;
    }else{
        //        width = [UIScreen mainScreen].bounds.size.width;
        //        height = [UIScreen mainScreen].bounds.size.height;
    }
    
    switch (_imageOrientation) {
        case XGImageOrientationDown:
        case XGImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case XGImageOrientationLeft:
        case XGImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case XGImageOrientationRight:
        case XGImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case XGImageOrientationUp:
        case XGImageOrientationUpMirrored:
            break;
    }
    
    switch (_imageOrientation) {
        case XGImageOrientationUpMirrored:
        case XGImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case XGImageOrientationLeftMirrored:
        case XGImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case XGImageOrientationUp:
        case XGImageOrientationDown:
        case XGImageOrientationLeft:
        case XGImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, width, height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    
    
    CGContextConcatCTM(ctx, transform);
    switch (_imageOrientation) {
        case XGImageOrientationLeft:
        case XGImageOrientationLeftMirrored:
        case XGImageOrientationRight:
        case XGImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,height,width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,width,height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}


- (void)gettingOrientation {
    
    NSArray *inputs = self.session.inputs;
    AVCaptureDevicePosition position;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            position = device.position;
        }
    }
    
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            _imageOrientation = XGImageOrientationRight;
            //            if (position == AVCaptureDevicePositionFront) {
            //                _imageOrientation = XGImageOrientationDownMirrored;
            //            }
            break;
            //        case UIDeviceOrientationPortraitUpsideDown:
            //            _imageOrientation = XGImageOrientationLeft;
            //            if (position == AVCaptureDevicePositionFront) {
            //                _imageOrientation = XGImageOrientationLeftMirrored;
            //            }
            //            break;
        case UIDeviceOrientationLandscapeLeft:
            _imageOrientation = XGImageOrientationUp;
            break;
        case UIDeviceOrientationLandscapeRight:
            _imageOrientation = XGImageOrientationDown;
            break;
        default:
            break;
    }
}

#pragma mark - <UIAlertDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        CGFloat kSystemMainVersion = [UIDevice currentDevice].systemVersion.floatValue;
        if (kSystemMainVersion >= 8.0) { // ios8 以后支持跳转到设置
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
