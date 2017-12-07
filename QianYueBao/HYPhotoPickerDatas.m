//
//  HYPhotoPickerDatas.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerDatas.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HYPhotoPcikerGroup.h"

@interface HYPhotoPickerDatas()

@property (nonatomic, strong) ALAssetsLibrary *library;

@end

@implementation HYPhotoPickerDatas
+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^
                  {
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

- (ALAssetsLibrary *)library
{
    if (nil == _library)
    {
        _library = [self.class defaultAssetsLibrary];
    }
    return _library;
}

+ (instancetype)defaultPicker
{
    return [[self alloc] init];
}

#pragma mark - 获取所有的组
- (void)getAllGroupWithPhotos:(callBackPhotoBlock)callBack
{
    [self getAllGroupAllPhotos:YES withResource:callBack];
}

/**
 *  获取所有组对应的图片
 *
 */
- (void)getAllGroupWithAllPhotos:(callBackPhotoBlock)callBack
{
    NSMutableArray *groups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            // 包装一个模型来赋值
            HYPhotoPcikerGroup *pickerGroup = [[HYPhotoPcikerGroup alloc] init];
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            pickerGroup.group = group;
            pickerGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            pickerGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            pickerGroup.assetsCount = [group numberOfAssets];
            [groups addObject:pickerGroup];
        }
        else
        {
            callBack(groups);
        }
    };
    
    NSInteger type = ALAssetsGroupAll;
    
    [self.library enumerateGroupsWithTypes:type usingBlock:resultBlock failureBlock:nil];
}

/**
 * 获取所有组对应的图片与视频
 */
- (void) getAllGroupWithPhotosAndVideos : (callBackPhotoBlock ) callBack{
    NSMutableArray *groups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group)
        {
            // 包装一个模型来赋值
            HYPhotoPcikerGroup *pickerGroup = [[HYPhotoPcikerGroup alloc] init];
            pickerGroup.group = group;
            pickerGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            pickerGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            pickerGroup.assetsCount = [group numberOfAssets];
            [groups addObject:pickerGroup];
        }
        else
        {
            callBack(groups);
        }
    };
    
    NSInteger type = ALAssetsGroupAll;
    
    [self.library enumerateGroupsWithTypes:type usingBlock:resultBlock failureBlock:nil];
}

- (void)getAllGroupAllPhotos:(BOOL)allPhotos withResource:(callBackPhotoBlock)callBack
{
    NSMutableArray *groups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group)
        {
            // 包装一个模型赋值
            HYPhotoPcikerGroup *pickerGroup = [[HYPhotoPcikerGroup alloc]init];
            if (allPhotos)
            {
                [group setAssetsFilter:[ALAssetsFilter allAssets]];
            }
            else
            {
                pickerGroup.isVideo = YES;
                [group setAssetsFilter:[ALAssetsFilter allVideos]];
            }
            
            pickerGroup.group = group;
            pickerGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            pickerGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            pickerGroup.assetsCount = [group numberOfAssets];
            [groups addObject:pickerGroup];
        }
        else
        {
            if (callBack)
            {
                callBack(groups);
            }
        }
    };
    NSInteger type = ALAssetsGroupAll;
    [self.library enumerateGroupsWithTypes:type usingBlock:resultBlock failureBlock:nil];
}

/**
 * 获取所有组对应的图片
 */
- (void) getAllGroupWithVideos:(callBackPhotoBlock)callBack
{
    [self getAllGroupAllPhotos:NO withResource:callBack];
}


#pragma mark -传入一个组获取组里面的Asset
- (void) getGroupPhotosWithGroup : (HYPhotoPcikerGroup *) pickerGroup finished : (callBackPhotoBlock ) callBack
{
    NSMutableArray *assets = [NSMutableArray array];
    ALAssetsGroupEnumerationResultsBlock result = ^(ALAsset *asset , NSUInteger index , BOOL *stop){
        if (asset)
        {
            [assets addObject:asset];
        }
        else
        {
            callBack(assets);
        }
    };
    [pickerGroup.group enumerateAssetsUsingBlock:result];
}

#pragma mark -传入一个AssetsURL来获取UIImage
- (void)getAssetsPhotoWithURLS:(NSURL *)url callBack:(callBackPhotoBlock)callBack
{
    [self.library assetForURL:url resultBlock:^(ALAsset *asset) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]);
        });
    } failureBlock:nil];
}
@end
