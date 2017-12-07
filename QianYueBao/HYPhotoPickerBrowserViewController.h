
//
//  HYPhotoPickerBrowserViewController.h
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPhotoPickerBrowerPhoto.h"
#import "HYPhotoPickerCommon.h"
#import "HYPhotoPickerCustomToolBarView.h"
#import "HYPhotoPickerBrowserPhotoScrollView.h"

@class HYPhotoPickerBrowserViewController;

@protocol HYPhotoPickerBrowserViewControllerDelegate <NSObject>

@optional

/**
 *  点击每个Item时候调用
 */
- (void)photoBrowser:(HYPhotoPickerBrowserViewController *)pickerBrowser photoDidSelectView:(UIView *)scrollBoxView atIndex:(NSInteger)index;

/**
 *  返回用户自定义的toolBarView(类似tableView FooterView)
 */
- (HYPhotoPickerCustomToolBarView *)photoBrowserShowToolBarViewWithphotoBrowser:(HYPhotoPickerBrowserViewController *)photoBrowser;

/**
 *  准备删除那个照片，index要删除的索引值
 */
- (BOOL)photoBrowser:(HYPhotoPickerBrowserViewController *)photoBrowser willRemovePhotoAtIndex:(NSInteger)index;

/**
 *  删除indexPath对应索引的图片
 *
 *  @param indexPath        要删除的索引值
 */
- (void)photoBrowser:(HYPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index;


/**
 *  滑动结束的页数
 *
 *  @param photoBrowser
 *  @param page         滑动的页数
 */
- (void)photoBrowser:(HYPhotoPickerBrowserViewController *)photoBrowser didCurrentPage:(NSUInteger)page;

/**
 *  滑动开始的页数
 *
 *  @param photoBrowser
 *  @param page         滑动的页数
 */
- (void)photoBrowser:(HYPhotoPickerBrowserViewController *)photoBrowser willCurrentPage:(NSUInteger)page;

@end
@interface HYPhotoPickerBrowserViewController : UIViewController

@property (nonatomic, weak) id<HYPhotoPickerBrowserViewControllerDelegate>delegate;

/**
 *  展示的图片数组<HYPhotoPickerBrowserPhoto> == [self.dataSource photoBrowser:photoAtIndex:]
 */
@property (nonatomic, strong) NSArray <HYPhotoPickerBrowerPhoto *> *photos;

/**
 *  当前提供的组
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 *  是否可以编辑
 */
@property (nonatomic, assign, getter=idEditing) BOOL editing;

/**
 *   动画status（放大缩小／淡入浅出／旋转）
 */
@property (nonatomic, assign) UIViewAnimationAnimationStatus status;

/**
 *  长按保存图片会调用sheet
 */
@property (nonatomic, strong) UIActionSheet *sheet;

/**
 *  需要增加的导航高度
 */
@property (nonatomic, assign) CGFloat navigationHeight;

/**
 *  放大缩小一张图片的情况下（查看头像）
 */
- (void)showHeadPortrait:(UIImageView *)toImageView;

@property (weak,nonatomic) UIButton         *deleleBtn;

/**
 *  放大缩小一张图片的情况下（查看头像）/ 缩略图是toImageView.image 原图URL
 */
- (void)showHeadPortrait:(UIImageView *)toImageView originUrl:(NSString *)originUrl;

- (UIView *)getParsentView:(UIView *)view;

- (id)getParsentViewController:(UIView *)view;

/**
 *  展示控制器
 */

- (void)showPickerVC:(UIViewController *)vc;

- (void)showPushPickerVC:(UIViewController *)vc;

@end
