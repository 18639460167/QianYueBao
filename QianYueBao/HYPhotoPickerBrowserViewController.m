//
//  HYPhotoPickerBrowserViewController.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerBrowserViewController.h"
#import "HYPhotoPickerBrowserViewController+SinglePhotoBrower.h"
#import "UIImage+HYPhotoLib.h"
#import "HYPhotoRect.h"
#import "UIView+HYExtension.h"

static NSString *_cellIdentifier = @"collectionViewCell";

@interface HYPhotoPickerBrowserViewController ()<UIScrollViewDelegate,HYPhotoPickerPhotoScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

// 控件
@property (weak,nonatomic) UILabel          *pageLabel;
@property (weak,nonatomic) UIPageControl    *pageControl;
@property (weak,nonatomic) UIButton         *backBtn;
@property (weak,nonatomic) UICollectionView *collectionView;

@property (weak,nonatomic) UIScrollView *userScrollView;

// 上一次屏幕旋转的位置
@property (assign,nonatomic) UIDeviceOrientation lastDeviceOrientation;

// 数据相关
// 单击时执行销毁的block
@property (nonatomic , copy) HYPickerBrowserViewControllerTapDisMissBlock disMissBlock;
// 当前提供的分页数
@property (nonatomic , assign) NSInteger currentPage;
// 当前是否在旋转
@property (assign,nonatomic) BOOL isNowRotation;
// 是否是Push模式
@property (assign,nonatomic) BOOL isPush;

@end

@implementation HYPhotoPickerBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupReload];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)setupReload{
    if (self.isPush) {
        [self reloadData];
        __weak typeof(self)weakSelf = self;
        __block BOOL navigationisHidden = NO;
        self.disMissBlock = ^(NSInteger page){
            if (navigationisHidden) {
                [UIView animateWithDuration:.25 animations:^{
                    weakSelf.navigationController.navigationBar.alpha = 1.0;
                }];
            }else{
                [UIView animateWithDuration:.25 animations:^{
                    weakSelf.navigationController.navigationBar.alpha = 0.0;
                }];
            }
            navigationisHidden = !navigationisHidden;
        };
    }else{
        // 初始化动画
        if (self.photos.count){
            [self showToView];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.alpha = 1.0;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
#pragma mark - getPhotos
- (NSArray *)getPhotos
{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_photos.count];
    for (HYPhotoPickerBrowerPhoto *photo in _photos)
    {
        photo.toView = [[photo toView] copy];
        [photos addObject:photo];
    }
    return photos;
}

#pragma mark collectionView
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width + HYPickerCollectionViewPadding, [UIScreen mainScreen].bounds.size.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        
        [self.view addSubview:collectionView];
        self.collectionView = collectionView;
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-x-|" options:0 metrics:@{@"x":@(-HYPickerCollectionViewPadding)} views:@{@"_collectionView":_collectionView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:@{@"_collectionView":_collectionView}]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotationDirection:) name:UIDeviceOrientationDidChangeNotification object:nil];
        self.lastDeviceOrientation = [[UIDevice currentDevice] orientation];
        
        self.pageLabel.hidden = NO;
//        self.deleleBtn.hidden = NO;
       // self.deleleBtn.hidden = !self.isEditing;
    }
    return _collectionView;
}

#pragma mark deleleBtn
- (UIButton *)deleleBtn{
    if (!_deleleBtn) {
        UIButton *deleleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleleBtn.translatesAutoresizingMaskIntoConstraints = NO;
        deleleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleleBtn setImage:[UIImage ml_imageFormBundleNamed:@"nav_delete_btn"] forState:UIControlStateNormal];
        
        // 设置阴影
        deleleBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        deleleBtn.layer.shadowOffset = CGSizeMake(0, 0);
        deleleBtn.layer.shadowRadius = 3;
        deleleBtn.layer.shadowOpacity = 1.0;
        deleleBtn.hidden = YES;
        
        [deleleBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_deleleBtn = deleleBtn];
        
        NSString *widthVfl = @"H:[deleleBtn(deleteBtnWH)]-margin-|";
        NSString *heightVfl = @"V:|-margin-[deleleBtn(deleteBtnWH)]";
        NSDictionary *metrics = @{@"deleteBtnWH":@(50),@"margin":@(10)};
        NSDictionary *views = NSDictionaryOfVariableBindings(deleleBtn);
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _deleleBtn;
}

#pragma mark pageLabel
- (UILabel *)pageLabel{
    if (!_pageLabel) {
        UILabel *pageLabel = [[UILabel alloc] init];
        pageLabel.font = [UIFont systemFontOfSize:18];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.userInteractionEnabled = NO;
        pageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        pageLabel.backgroundColor = [UIColor clearColor];
        pageLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:pageLabel];
        self.pageLabel = pageLabel;
        
        NSString *widthVfl = @"H:|-0-[pageLabel]-0-|";
        NSString *heightVfl = @"V:[pageLabel(ZLPickerPageCtrlH)]-20-|";
        NSDictionary *views = NSDictionaryOfVariableBindings(pageLabel);
        NSDictionary *metrics = @{@"ZLPickerPageCtrlH":@(HYPIckerPageCtrH)};
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _pageLabel;
}

#pragma mark pageControl
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:pageControl];
        self.pageControl = pageControl;
        
        NSString *widthVfl = @"H:|-0-[pageControl]-0-|";
        NSString *heightVfl = @"V:[pageControl(ZLPickerPageCtrlH)]-20-|";
        NSDictionary *views = NSDictionaryOfVariableBindings(pageControl);
        NSDictionary *metrics = @{@"ZLPickerPageCtrlH":@(HYPIckerPageCtrH)};
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _pageControl;
}


#pragma mark -Life cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.isPush)
    {
        
    }
    else
    {
        if (self.currentPage>=0)
        {
            self.collectionView.contentOffset = CGPointMake(self.currentPage*self.collectionView.hy_width, self.collectionView.contentOffset.y);
        }
    }
    [self.view bringSubviewToFront:_deleleBtn];
}

- (void)showToView
{
    _photos = [_photos copy];
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor blackColor];
    mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mainView.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    
    UIView *mainBgView = [[UIView alloc] init];
    mainBgView.alpha = 0.0;
    mainBgView.backgroundColor = [UIColor blackColor];
    mainBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mainBgView.frame = [UIScreen mainScreen].bounds;
    [mainView addSubview:mainBgView];
    
    __block UIImageView *toImageView = nil;
    if (self.currentIndex < self.photos.count) {
        toImageView = (UIImageView *)[self.photos[self.currentIndex] toView];
    }
    
    if (![toImageView isKindOfClass:[UIImageView class]] && self.status != UIViewAnimationAnimationStatusFade) {
        self.status = UIViewAnimationAnimationStatusFade;
    }
    
    __block UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [mainBgView addSubview:imageView];
    mainView.clipsToBounds = YES;
    
    UIImage *thumbImage = nil;
    
    if ([self.photos[self.currentIndex] asset] == nil) {
        thumbImage = [self.photos[self.currentIndex] thumbImage];
    }else{
        thumbImage = [self.photos[self.currentIndex] photoImage];
    }
    
    if (thumbImage == nil) {
        thumbImage = toImageView.image;
    }
    
    if (self.status == UIViewAnimationAnimationStatusFade){
        imageView.image = thumbImage;
    }else{
        if (thumbImage == nil) {
            imageView.image = toImageView.image;
        }else{
            imageView.image = thumbImage;
        }
    }
    
    
    if (self.status == UIViewAnimationAnimationStatusFade){
        imageView.alpha = 0.0;
        imageView.frame = [HYPhotoRect setMaxMinZoomScalesForCurrentBoundWithImage:imageView.image];
    }else if(self.status == UIViewAnimationAnimationStatusZoom){
        CGRect tempF = [toImageView.superview convertRect:toImageView.frame toView:[self getParsentView:toImageView]];
        if (self.navigationHeight) {
            tempF.origin.y += self.navigationHeight;
        }
        
        imageView.frame = tempF;
    }
    
    
    __block CGRect tempFrame = imageView.frame;
    __weak typeof(self)weakSelf = self;
    self.disMissBlock = ^(NSInteger page){
        mainView.hidden = NO;
        mainView.alpha = 1.0;
        CGRect originalFrame = CGRectZero;
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        // 缩放动画
        if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
            UIImage *thumbImage = nil;
            
            if ([weakSelf.photos[page] asset] == nil) {
                thumbImage = [weakSelf.photos[page] thumbImage];
            }else{
                thumbImage = [weakSelf.photos[page] photoImage];
            }
            
            HYPhotoPickerBrowerPhoto *photo = weakSelf.photos[page];
            if (thumbImage == nil) {
                imageView.image = [(UIImageView *)[photo toView] image];
                thumbImage = imageView.image;
            }else{
                imageView.image = thumbImage;
            }
            
            if (imageView.image == nil) {
                UICollectionViewCell *cell = [weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:weakSelf.currentIndex]];
                HYPhotoPickerBrowserPhotoScrollView *scrollView = (HYPhotoPickerBrowserPhotoScrollView *)[cell viewWithTag:101];
                if ([scrollView isKindOfClass:[HYPhotoPickerBrowserPhotoScrollView class]] && scrollView != nil) {
                    imageView.image = scrollView.photoImageView.image;
                }
            }
            
            CGRect ivFrame = [HYPhotoRect setMaxMinZoomScalesForCurrentBoundWithImage:thumbImage];
            if (!CGRectEqualToRect(ivFrame, CGRectZero)) {
                imageView.frame = ivFrame;
            }
            UIImageView *toImageView2 = (UIImageView *)[weakSelf.photos[page] toView];
            
            originalFrame = [toImageView2.superview convertRect:toImageView2.frame toView:[weakSelf getParsentView:toImageView2]];
            
            if (CGRectIsEmpty(originalFrame)) {
                originalFrame = tempFrame;
            }
            
        }else{
            // 淡入淡出
            HYPhotoPickerBrowerPhoto *photo = weakSelf.photos[page];
            if (photo.photoImage) {
                imageView.image = photo.photoImage;
            }else if (photo.thumbImage) {
                imageView.image = photo.thumbImage;
            }
            
            imageView.frame = [HYPhotoRect setMaxMinzoomScalesForCurrentBoundWithIMageView:imageView];
            imageView.alpha = 1.0;
            [imageView superview].alpha = 1.0;
            weakSelf.view.hidden = YES;
        }
        
        if (weakSelf.navigationHeight) {
            originalFrame.origin.y += weakSelf.navigationHeight;
        }
        
        [UIView animateWithDuration:0.35 animations:^{
            if (weakSelf.status == UIViewAnimationAnimationStatusFade){
                mainView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                mainBgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                
                imageView.alpha = 0.0;
            }else if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
                weakSelf.collectionView.hidden = YES;
                mainView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                mainBgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                imageView.frame = originalFrame;
            }
        } completion:^(BOOL finished) {
            weakSelf.view.hidden = NO;
            imageView.alpha = 1.0;
            [mainView removeFromSuperview];
            [mainBgView removeFromSuperview];
            
            [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        }];
    };
    
    [weakSelf reloadData];
    if (imageView.image == nil) {
        weakSelf.status = UIViewAnimationAnimationStatusFade;
        
        [UIView setAnimationsEnabled:YES];
        [UIView animateWithDuration:0.35 animations:^{
            // 淡入淡出
            mainView.alpha = 0.0;
        } completion:^(BOOL finished) {
            mainView.alpha = 1.0;
            mainView.hidden = YES;
        }];
        
    }else{
        [UIView setAnimationsEnabled:YES];
        [UIView animateWithDuration:0.35 animations:^{
            if (weakSelf.status == UIViewAnimationAnimationStatusFade){
                // 淡入淡出
                mainBgView.alpha = 1.0;
                imageView.alpha = 1.0;
            }else if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
                mainBgView.alpha = 1.0;
                imageView.alpha = 1.0;
                imageView.frame = [HYPhotoRect setMaxMinzoomScalesForCurrentBoundWithIMageView:imageView];
            }
        } completion:^(BOOL finished) {
            mainView.hidden = YES;
        }];
    }

}

#pragma mark get Controller.view
- (UIView *)getParsentView:(UIView *)view{
    if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]) {
        self.userScrollView = (UIScrollView *)view;
    }
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}

- (id)getParsentViewController:(UIView *)view{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return [view nextResponder];
    }
    return [self getParsentViewController:view.superview];
}


#pragma mark - reloadData
- (void)reloadData{
    if (self.currentPage <= 0){
        self.currentPage = self.currentIndex;
    }else{
        --self.currentPage;
    }
    
    if (self.currentPage >= self.photos.count) {
        self.currentPage = self.photos.count - 1;
    }
    
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    
    // 添加自定义View
    if ([self.delegate respondsToSelector:@selector(photoBrowserShowToolBarViewWithphotoBrowser:)]) {
        UIView *toolBarView = [self.delegate photoBrowserShowToolBarViewWithphotoBrowser:self];
        toolBarView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        CGFloat width = self.view.hy_width;
        CGFloat x = self.view.hy_x;
        if (toolBarView.hy_width) {
            width = toolBarView.hy_width;
        }
        if (toolBarView.hy_x) {
            x = toolBarView.hy_x;
        }
        toolBarView.frame = CGRectMake(x, self.view.hy_height - 44, width, 44);
        [self.view addSubview:toolBarView];
    }
    
    [self setPageLabelPage:self.currentPage];
    if (self.currentPage >= 0) {
        self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.hy_width , self.collectionView.contentOffset.y);
    }
}

-(void)setPageLabelPage:(NSInteger)page{
    self.pageLabel.text = [NSString stringWithFormat:@"%ld / %ld",(long)page + 1, (unsigned long)self.photos.count];
    if (self.isPush) {
        self.title = self.pageLabel.text;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    if (collectionView.isDragging) {
        cell.hidden = NO;
    }
    if (self.photos.count) {
        //        cell.backgroundColor = [UIColor clearColor];
        
        HYPhotoPickerBrowerPhoto *photo = self.photos[indexPath.item];
        
        if([[cell.contentView.subviews lastObject] isKindOfClass:[UIView class]]){
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        
        CGRect tempF = [UIScreen mainScreen].bounds;
        
        UIView *scrollBoxView = [[UIView alloc] init];
        scrollBoxView.frame = tempF;
        scrollBoxView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:scrollBoxView];
        
        HYPhotoPickerBrowserPhotoScrollView *scrollView =  [[HYPhotoPickerBrowserPhotoScrollView alloc] init];
        scrollView.sheet = self.sheet;
        // 为了监听单击photoView事件
        scrollView.frame = tempF;
        scrollView.tag = 101;
        if (self.isPush) {
            scrollView.hy_y -= 32;
        }
        scrollView.photoScrollViewDelegate = self;
        scrollView.photo = photo;
        __weak typeof(scrollBoxView)weakScrollBoxView = scrollBoxView;
        __weak typeof(self)weakSelf = self;
        if ([self.delegate respondsToSelector:@selector(photoBrowser:photoDidSelectView:atIndex:)]) {
            [[scrollBoxView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            scrollView.callBack = ^(id obj){
                [weakSelf.delegate photoBrowser:weakSelf photoDidSelectView:weakScrollBoxView atIndex:indexPath.row];
            };
        }
        
        [scrollBoxView addSubview:scrollView];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    return cell;
}

- (NSUInteger)getRealPhotosCount{
    return self.photos.count;
}



- (void)setPageControlPage:(long)page {
    self.pageControl.numberOfPages = self.photos.count;
    self.pageControl.currentPage = page;
    if (self.pageControl.numberOfPages > 1) {
        self.pageControl.hidden = NO;
    } else {
        self.pageControl.hidden = YES;
    }
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = (NSInteger)(scrollView.contentOffset.x / (scrollView.frame.size.width));
    if (currentPage == self.photos.count - 2) {
        currentPage = roundf((scrollView.contentOffset.x) / (scrollView.frame.size.width));
    }
    
    self.currentPage = currentPage;
    [self setPageLabelPage:currentPage];
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didCurrentPage:)]) {
        [self.delegate photoBrowser:self didCurrentPage:self.currentPage];
    }
}

#pragma mark - 展示控制器
- (void)showPickerVC:(UIViewController *)vc
{
    // 当没有数据的情况下
    if (self.photos.count == 0 || self.photos.count <= self.currentIndex) {
        NSLog(@"ZLPhotoLib提示: 您没有传photos数组");
        return;
    }
    
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        if (([vc isKindOfClass:[UITableViewController class]] || [vc isKindOfClass:[UICollectionView class]]) && weakVc.navigationController != nil && self.navigationHeight == 0) {
            self.navigationHeight = CGRectGetMaxY(weakVc.navigationController.navigationBar.frame);
        }
        [weakVc presentViewController:self animated:NO completion:nil];
    }
}

- (void)showPushPickerVC:(UIViewController *)vc
{
    self.isPush = YES;
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        if (([vc isKindOfClass:[UITableViewController class]] || [vc isKindOfClass:[UICollectionView class]]) && weakVc.navigationController != nil && self.navigationHeight == 0) {
            self.navigationHeight = CGRectGetMaxY(weakVc.navigationController.navigationBar.frame);
        }
        [weakVc.navigationController pushViewController:self animated:YES];
    }
}


#pragma mark - 删除照片
- (void)delete{
    // 准备删除
    if ([self.delegate respondsToSelector:@selector(photoBrowser:willRemovePhotoAtIndex:)]) {
        if(![self.delegate photoBrowser:self willRemovePhotoAtIndex:self.currentPage]){
            return ;
        }
    }
    
    UIAlertView *removeAlert = [[UIAlertView alloc]
                                initWithTitle:LS(@"Delete_This_Picture")
                                message:nil
                                delegate:self
                                cancelButtonTitle:LS(@"Cancel")
                                otherButtonTitles:LS(@"Determine"), nil];
    [removeAlert show];
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1)
    {
        NSInteger page = self.currentPage;
        NSMutableArray *photos = [NSMutableArray arrayWithArray:self.photos];
        if ([self.delegate respondsToSelector:@selector(photoBrowser:removePhotoAtIndex:)])
        {
            [self.delegate photoBrowser:self removePhotoAtIndex:page];
        }
        
        if (self.photos.count > self.currentPage) {
            [photos removeObjectAtIndex:self.currentPage];
            self.photos = photos;
        }
        
        if (page >= self.photos.count)
        {
            self.currentPage--;
        }
        
        self.status = UIViewAnimationAnimationStatusFade;
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0]];
        
        if (cell)
        {
            if([[[cell.contentView subviews] lastObject] isKindOfClass:[UIView class]]){
                
                [UIView animateWithDuration:0.35 animations:^{
                    [[[cell.contentView subviews] lastObject] setAlpha:0.0];
                } completion:^(BOOL finished) {
                    [self reloadData];
                }];
            }
        }
        
        if (self.photos.count < 1)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            if (self.isPush) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }
    }
}

#pragma mark - Rotation
- (void)changeRotationDirection:(NSNotification *)noti{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self.collectionView collectionViewLayout];
    [layout invalidateLayout];
    
    UIDevice *obj = (UIDevice *)noti.object;
    if ([obj isKindOfClass:[UIDevice class]] && (UIDeviceOrientation)[obj orientation] == self.lastDeviceOrientation) {
        self.lastDeviceOrientation = (UIDeviceOrientation)[obj orientation];
        return ;
    }
    
    if (CGSizeEqualToSize(CGSizeMake([UIScreen mainScreen].bounds.size.width + HYPickerCollectionViewPadding, [UIScreen mainScreen].bounds.size.height), [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout itemSize])) {
        return ;
    }
    
    self.lastDeviceOrientation = (UIDeviceOrientation)[obj orientation];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.view.hy_size.width + HYPickerCollectionViewPadding, self.view.hy_height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.alpha = 0.0;
    [self.collectionView setCollectionViewLayout:flowLayout animated:YES];
    
    self.isNowRotation = YES;
    
    self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.hy_width, self.collectionView.contentOffset.y);
    
    UICollectionViewCell *currentCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0]];
    for (UICollectionViewCell *cell in [self.collectionView subviews]) {
        if ([cell isKindOfClass:[UICollectionViewCell class]]) {
            cell.hidden = ![cell isEqual:currentCell];
            HYPhotoPickerBrowserPhotoScrollView *scrollView = (HYPhotoPickerBrowserPhotoScrollView *)[cell.contentView viewWithTag:101];
            [scrollView setMaxMinZoomScalesForCurrentBounds];
        }
    }
    
    [UIView animateWithDuration:.5 animations:^{
        self.collectionView.alpha = 1.0;
    }];
}

#pragma mark - <PickerPhotoScrollViewDelegate>
- (void)pickerPhotoScrollViewDidSingleClick:(HYPhotoPickerBrowserPhotoScrollView *)photoScrollView{
    if (self.disMissBlock) {
        
        if (self.photos.count == 1) {
            self.currentPage = 0;
        }
        self.disMissBlock(self.currentPage);
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showHeadPortrait:(UIImageView *)toImageView{
    
}

- (void)showHeadPortrait:(UIImageView *)toImageView originUrl:(NSString *)originUrl{
    
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
