//
//  HYPhotoPickerCollectionView.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerCollectionView.h"
#import "HYPhotoPickerCollectionViewCell.h"
#import "HYPhotoPickerImageView.h"
#import "HYPhotoPickerFooterCollectionReusableView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HYPhotoAssets.h"
#import "HYPhoto.h"
#import "UIImage+HYPhotoLib.h"
#import "HYPhotoPickerCommon.h"

@interface HYPhotoPickerCollectionView()<UICollectionViewDataSource>

@property (nonatomic, strong) HYPhotoPickerFooterCollectionReusableView *footerView;

// 判断是否是第一次加载
@property (nonatomic, assign, getter=isFirstLoadding) BOOL firstLoadding;

@end
@implementation HYPhotoPickerCollectionView

- (NSMutableArray *)selectsIndexPath{
    if (!_selectsIndexPath) {
        _selectsIndexPath = [NSMutableArray array];
    }
    if (_selectsIndexPath) {
        NSSet *set = [NSSet setWithArray:_selectsIndexPath];
        _selectsIndexPath = [NSMutableArray arrayWithArray:[set allObjects]];
    }
    return _selectsIndexPath;
}

- (void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    
}

#pragma mark -setter
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    // 需要记录选中的值的数据
    if (self.isRecoderSelectPicker){
        NSMutableArray *selectAssets = [NSMutableArray array];
        for (HYPhotoAssets *asset in self.selectAssets) {
            for (HYPhotoAssets *asset2 in self.dataArray) {
                
                if (![asset isKindOfClass:[HYPhotoAssets class]] || ![asset2 isKindOfClass:[HYPhotoAssets class]]) {
                    continue;
                }
                
                if ([asset.asset.defaultRepresentation.url isEqual:asset2.asset.defaultRepresentation.url]) {
                    [selectAssets addObject:asset2];
                    break;
                }
            }
        }
        _selectAssets = selectAssets;
    }
    
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        _selectAssets = [NSMutableArray array];
        self.selectsIndexPath = [NSMutableArray new];
    }
    return self;
}

#pragma mark -<UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYPhotoPickerCollectionViewCell *cell = [HYPhotoPickerCollectionViewCell cellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    
    if(indexPath.item == 0 && self.topShowPhotoPicker && self.isShowCamera){
        UIImageView *imageView = [[cell.contentView subviews] lastObject];
        // 判断真实类型
        if (![imageView isKindOfClass:[UIImageView class]]) {
            imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            [cell.contentView addSubview:imageView];
        }
        imageView.tag = indexPath.item;
        imageView.image = [UIImage ml_imageFormBundleNamed:@"camera"];
    }else{
        HYPhotoPickerImageView *cellImgView = [[HYPhotoPickerImageView alloc] initWithFrame:cell.bounds];
        // 需要记录选中的值的数据
        if (self.isRecoderSelectPicker)
        {
            for (HYPhotoAssets *asset in self.selectAssets)
            {
                if ([asset isKindOfClass:[HYPhotoAssets class]] && [asset.asset.defaultRepresentation.url isEqual:[(HYPhotoAssets *)self.dataArray[indexPath.item] asset].defaultRepresentation.url])
                {
                    [self.selectsIndexPath addObject:@(indexPath.row)];
                }
            }
        }
        [cell.contentView addSubview:cellImgView];
        cellImgView.isClickHaveAnimation = NO;
        cellImgView.maskViewFlag = ([self.selectsIndexPath containsObject:@(indexPath.row)]);
        HYPhotoAssets *asset = self.dataArray[indexPath.item];
        asset.cuurntIndex = indexPath.row;
        cellImgView.isVideoType = asset.isVideoType;
        if ([asset isKindOfClass:[HYPhotoAssets class]]) {
            [asset thumbImageCallBack:^(UIImage *image) {
                asset.thumbImage = image;
                cellImgView.image = image;
            }];
        }
    }
    
    return cell;
}

- (BOOL)validatePhotoCount:(NSInteger)maxCount
{
    if ((long)self.selectAssets.count >= maxCount || maxCount < 0)
    {
//        NSString *format = [NSString stringWithFormat:@"最多只能选择%zd张图片",maxCount];
        NSString *format = [NSString stringWithFormat:LS(@"Select_Only_Picture"),maxCount];
        if (maxCount <= 0)
        {
            format = [NSString stringWithFormat:LS(@"Select_Only_Picture"),maxCount];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"U-Travel" message:format delegate:self cancelButtonTitle:nil otherButtonTitles:LS(@"Determine"), nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.topShowPhotoPicker && indexPath.item == 0 && self.isShowCamera) {
        NSUInteger maxCount = (self.maxCount == 0) ? KPhotoShowMaxCount :  self.maxCount;
        if (![self validatePhotoCount:maxCount])
        {
            return ;
        }
        if ([self.collectionViewDelegate respondsToSelector:@selector(pickerCollectionViewDidCameraSelect:)]) {
            [self.collectionViewDelegate pickerCollectionViewDidCameraSelect:self];
        }
        return ;
    }
    
    if (!self.lastDataArray) {
        self.lastDataArray = [NSMutableArray array];
    }
    
    HYPhotoPickerCollectionViewCell *cell = (HYPhotoPickerCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    HYPhotoAssets *asset = self.dataArray[indexPath.row];
    HYPhotoPickerImageView *pickerImageView = [cell.contentView.subviews lastObject];
    // 如果没有就添加到数组里面，存在就移除
    if (pickerImageView.isMaskViewFlag)
    {
        [self.selectsIndexPath removeObject:@(indexPath.row)];
        [self.selectAssets removeObject:asset];
        [self.lastDataArray removeObject:asset];
    }else{
        // 1 判断图片数超过最大数或者小于0
        NSInteger maxCount = (self.maxCount == 0) ? KPhotoShowMaxCount :  self.maxCount;
        if (![self validatePhotoCount:maxCount]){
            return ;
        }
        
        [self.selectsIndexPath addObject:@(indexPath.row)];
        [self.selectAssets addObject:asset];
        [self.lastDataArray addObject:asset];
    }
    // 告诉代理现在被点击了!
    if ([self.collectionViewDelegate respondsToSelector:@selector(pickerCollectionViewDidSelected: deleteAsset:)]) {
        if (pickerImageView.isMaskViewFlag) {
            // 删除的情况下
            [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:asset];
        }else{
            [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:nil];
        }
    }
    
    pickerImageView.isClickHaveAnimation = YES;
    pickerImageView.maskViewFlag = ([pickerImageView isKindOfClass:[HYPhotoPickerImageView class]]) && !pickerImageView.isMaskViewFlag;
}

#pragma mark 底部View
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HYPhotoPickerFooterCollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        HYPhotoPickerFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.count = self.dataArray.count;
        reusableView = footerView;
        self.footerView = footerView;
    }else{
        
    }
    return reusableView;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 时间置顶的话
    if (self.status == HYPickerCollectionViewShowOrderStatusTimeDesc) {
        if (!self.firstLoadding && self.contentSize.height > [[UIScreen mainScreen] bounds].size.height) {
            // 滚动到最底部（最新的）
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            // 展示图片数
            self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + 100);
            self.firstLoadding = YES;
        }
    }else if (self.status == HYPickerCollectionViewShowOrderStatusTimeAsc)
    {
        // 滚动到最底部（最新的）
        if (!self.firstLoadding && self.contentSize.height > [[UIScreen mainScreen] bounds].size.height) {
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            // 展示图片数
            self.contentOffset = CGPointMake(self.contentOffset.x, -self.contentInset.top);
            self.firstLoadding = YES;
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
