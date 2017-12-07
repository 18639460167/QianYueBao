//
//  HYPhotoPickerViewController.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerViewController.h"
#import "HYPhoto.h"
#import "UIViewController+Alert.h"
#import "HYPhotoPickerGroupViewController.h"
#import "NavigationViewController.h"

@interface HYPhotoPickerViewController ()

@property (nonatomic , strong) HYPhotoPickerGroupViewController *groupVc;

@end

@implementation HYPhotoPickerViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNotification];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init Action
- (void) createNavigationController{
    HYPhotoPickerGroupViewController *groupVc = [[HYPhotoPickerGroupViewController alloc] init];
    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:groupVc];
    nav.view.frame = self.view.bounds;
    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
    self.groupVc = groupVc;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self createNavigationController];
    }
    return self;
}

- (void)setIsShowCamera:(BOOL)isShowCamera{
    _isShowCamera = isShowCamera;
    self.groupVc.isShowCamera = isShowCamera;
}

- (void)setSelectPickers:(NSArray *)selectPickers{
    _selectPickers = selectPickers;
    self.groupVc.selectAsstes = selectPickers;
}

- (void)setStatus:(PickerViewShowStatus)status{
    _status = status;
    self.groupVc.status = status;
}

- (void)setPhotoStatus:(PickerPhotoStatus)photoStatus{
    _photoStatus = photoStatus;
    self.groupVc.photoStatus = photoStatus;
}

- (void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount <= 0 ? -1 : maxCount;
    self.groupVc.maxCount = _maxCount;
}

- (void)setTopShowPhotoPicker:(BOOL)topShowPhotoPicker{
    _topShowPhotoPicker = topShowPhotoPicker;
    self.groupVc.topShowPhotoPicker = topShowPhotoPicker;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideWaitingAnimation];
}

#pragma mark - 展示控制器
- (void)showPickerVc:(UIViewController *)vc{
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
    {
        CGFloat kSystemMainVersion = [UIDevice currentDevice].systemVersion.floatValue;
        NSString *title = nil;
        NSString *msg = LS(@"Picture_Alert");
        NSString *cancelTitle = LS(@"Temporarily");
        NSString *otherButtonTitles = LS(@"Go_Set");
        
        if (kSystemMainVersion < 8.0)
        {
            title = LS(@"Album_Permissions_Not_Open");
            msg = LS(@"Set_Album_Permission");
            cancelTitle = LS(@"Determine");
            otherButtonTitles = nil;
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:otherButtonTitles, nil];
        [alertView show];
    }
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil)
    {
        [weakVc presentViewController:self animated:YES completion:nil];
    }
}

- (void) addNotification{
    // 监听异步done通知
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done:) name:PICKER_TAKE_DONE object:nil];
    });
    
    // 监听异步点击第一个Cell的拍照通知
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCamera:) name:PICKER_TAKE_PHOTO object:nil];
    });
}

#pragma mark - 监听点击第一个Cell进行拍照
- (void)selectCamera:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(pickerCollectionViewSelectCamera:withImage:)]){
            [self.delegate pickerCollectionViewSelectCamera:self withImage:noti.userInfo[@"image"]];
        }
    });
}

#pragma mark - 监听点击Done按钮
- (void)done:(NSNotification *)note{
    NSArray *selectArray =  note.userInfo[@"selectAssets"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(pickerViewControllerDoneAsstes:)]) {
            [self.delegate pickerViewControllerDoneAsstes:selectArray];
        }else if (self.callBack){
            self.callBack(selectArray);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)setDelegate:(id<HYPhotoPickerViewControllerDelegate>)delegate{
    _delegate = delegate;
    self.groupVc.delegate = delegate;
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
