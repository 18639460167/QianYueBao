//
//  HYPhotoPickerAssetsViewController.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HYPhoto.h"
#import "HYPhotoPickerCollectionView.h"
#import "HYPhotoPcikerGroup.h"
#import "HYPhotoPickerCollectionViewCell.h"

#import "HYPhotoPickerFooterCollectionReusableView.h"


static NSString *const _cellIdentifier = @"cell";
static NSString *const _footerIdentifier = @"FooterView";
static NSString *const _identifier = @"toolBarThumbCollectionViewCell";

@interface HYPhotoPickerAssetsViewController ()<HYPhotoPcikerCollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,HYPhotoPickerBrowserViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

// View
// 相片View
@property (nonatomic , strong) HYPhotoPickerCollectionView *collectionView;
// 底部CollectionView
@property (nonatomic , weak) UICollectionView *toolBarThumbCollectionView;
// 标记View
@property (nonatomic , weak) UILabel *makeView;
@property (nonatomic , strong) UIButton *doneBtn;
@property (nonatomic , weak) UIToolbar *toolBar;

@property (assign,nonatomic) NSUInteger privateTempMaxCount;
// Datas
// 数据源
@property (nonatomic , strong) NSMutableArray *assets;
// 记录选中的assets
@property (nonatomic , strong) NSMutableArray *selectAssets;
// 拍照后的图片数组
@property (strong,nonatomic) NSMutableArray *takePhotoImages;


@end

@implementation HYPhotoPickerAssetsViewController

#pragma mark - getter
#pragma mark Get Data
- (NSMutableArray *)selectAssets{
    if (!_selectAssets) {
        _selectAssets = [NSMutableArray array];
    }
    return _selectAssets;
}

- (NSMutableArray *)takePhotoImages{
    if (!_takePhotoImages) {
        _takePhotoImages = [NSMutableArray array];
    }
    return _takePhotoImages;
}

#pragma mark Get View
- (UIButton *)doneBtn{
    if (!_doneBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:91/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        rightBtn.enabled = YES;
        rightBtn.titleLabel.font = FONTSIZE(16);
        rightBtn.frame = CGRectMake(0, 0, 45, 45);
        rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [rightBtn setTitle:LS(@"Finish") forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addSubview:self.makeView];
        self.doneBtn = rightBtn;
    }
    return _doneBtn;
}

- (UICollectionView *)toolBarThumbCollectionView{
    if (!_toolBarThumbCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(40, 40);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        // CGRectMake(0, 22, 300, 44)
        UICollectionView *toolBarThumbCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, self.view.hy_width - 100, 44) collectionViewLayout:flowLayout];
        toolBarThumbCollectionView.backgroundColor = [UIColor clearColor];
        toolBarThumbCollectionView.dataSource = self;
        toolBarThumbCollectionView.delegate = self;
        [toolBarThumbCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_identifier];
        
        self.toolBarThumbCollectionView = toolBarThumbCollectionView;
        [self.toolBar addSubview:toolBarThumbCollectionView];
        
    }
    return _toolBarThumbCollectionView;
}

- (void)setSelectPickerAssets:(NSArray *)selectPickerAssets{
    NSSet *set = [NSSet setWithArray:selectPickerAssets];
    _selectPickerAssets = [set allObjects];
    
    for (HYPhotoAssets *assets in selectPickerAssets)
    {
        if ([assets isKindOfClass:[HYPhotoAssets class]] || [assets isKindOfClass:[HYCamera class]]
            )
        {
            [self.selectAssets addObject:assets];
        }
        else if ([assets isKindOfClass:[UIImage class]])
        {
            [self.selectAssets addObject:[HYPhotoAssets assetWithImage:(UIImage *)assets]];
        }
    }
    
    self.collectionView.lastDataArray = nil;
    self.collectionView.isRecoderSelectPicker = YES;
    self.collectionView.selectAssets = [self.selectAssets mutableCopy];
    
    NSInteger count = self.selectAssets.count;
    self.makeView.hidden = !count;
    self.makeView.text = [NSString stringWithFormat:@"%ld",(long)count];
    self.doneBtn.enabled = (count > 0);
}

- (void)setTopShowPhotoPicker:(BOOL)topShowPhotoPicker{
    _topShowPhotoPicker = topShowPhotoPicker;
    
    if (self.topShowPhotoPicker == YES) {
        NSMutableArray *reSortArray= [[NSMutableArray alloc] init];
        for (id obj in [self.collectionView.dataArray reverseObjectEnumerator]) {
            [reSortArray addObject:obj];
        }
        
        if (self.isShowCamera) {
            HYPhotoAssets *zlAsset = [[HYPhotoAssets alloc] init];
            [reSortArray insertObject:zlAsset atIndex:0];
        }
        
        self.collectionView.status = HYPickerCollectionViewShowOrderStatusTimeAsc;
        self.collectionView.isShowCamera = self.isShowCamera;
        self.collectionView.topShowPhotoPicker = topShowPhotoPicker;
        self.collectionView.dataArray = reSortArray;
        [self.collectionView reloadData];
    }
}

#pragma mark collectionView
- (HYPhotoPickerCollectionView *)collectionView
{
    if (!_collectionView) {
        
        NSInteger cellW = (self.view.frame.size.width - CELL_MARGIN * CELL_ROW + 1) / CELL_ROW;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(cellW, cellW);
        layout.sectionInset = UIEdgeInsetsMake(0, 2, 0, 2);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = CELL_LINE_MARGIN;
        layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, TOOLBAR_HEIGHT * 2);
        
        HYPhotoPickerCollectionView *collectionView = [[HYPhotoPickerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        // 时间置顶
        collectionView.status = HYPickerCollectionViewShowOrderStatusTimeDesc;
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [collectionView registerClass:[HYPhotoPickerCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        // 底部的View
        [collectionView registerClass:[HYPhotoPickerFooterCollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:_footerIdentifier];
        
        collectionView.contentInset = UIEdgeInsetsMake(5, 0,TOOLBAR_HEIGHT, 0);
        collectionView.collectionViewDelegate = self;
        [self.view insertSubview:_collectionView = collectionView belowSubview:self.toolBar];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
        
        NSString *widthVfl = @"H:|-0-[collectionView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];
        
        NSString *heightVfl = @"V:|-0-[collectionView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
        
    }
    return _collectionView;
}

#pragma mark makeView 红点标记View
- (UILabel *)makeView
{
    if (!_makeView) {
        UILabel *makeView = [[UILabel alloc] init];
        makeView.textColor = [UIColor whiteColor];
        makeView.textAlignment = NSTextAlignmentCenter;
        makeView.font = [UIFont systemFontOfSize:13];
        makeView.frame = CGRectMake(-5, -5, 20, 20);
        makeView.hidden = YES;
        makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
        makeView.clipsToBounds = YES;
        makeView.backgroundColor = [UIColor redColor];
        [self.view addSubview:makeView];
        self.makeView = makeView;
        
    }
    return _makeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bounds = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化按钮
    [self setupButtons];
    
    // 初始化底部ToorBar
    [self setupToorBar];
}

#pragma mark - setter
#pragma mark 初始化按钮
- (void) setupButtons{
    HYWeakSelf;
    [BDStyle setRigthBtnInVC:self messge:LS(@"Cancel") action:^{
        [wSelf back];
    }];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}

#pragma mark 初始化所有的组
- (void) setupAssets{
    
    __block NSMutableArray *assetsM = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    [[HYPhotoPickerDatas defaultPicker] getGroupPhotosWithGroup:self.assetsGroup finished:^(NSArray *assets) {
        
        [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
            __block HYPhotoAssets *zlAsset = [[HYPhotoAssets alloc] init];
            zlAsset.asset = asset;
            [assetsM addObject:zlAsset];
        }];
        
        weakSelf.collectionView.dataArray = assetsM;
    }];
    
}

- (void)pickerCollectionViewDidCameraSelect:(HYPhotoPickerCollectionView *)pickerCollectionView
{
    HYCameraViewController *cameraVc = [[HYCameraViewController alloc] init];
    cameraVc.maxCount = (self.maxCount - self.selectAssets.count > 0) ? (self.maxCount - self.selectAssets.count) : 0;
    __weak typeof(self)weakSelf = self;
    __weak typeof(cameraVc)weakCameraVc = cameraVc;
    cameraVc.callback = ^(NSArray *camera){
        [weakSelf.selectAssets addObjectsFromArray:camera];
        [weakSelf.toolBarThumbCollectionView reloadData];
        [weakSelf.takePhotoImages addObjectsFromArray:camera];
        weakSelf.collectionView.selectAssets = [weakSelf.selectAssets mutableCopy];
        
        NSInteger count = self.selectAssets.count;
        weakSelf.makeView.hidden = !count;
        weakSelf.makeView.text = [NSString stringWithFormat:@"%ld",(long)count];
        weakSelf.doneBtn.enabled = (count > 0);
        [weakCameraVc dismissViewControllerAnimated:YES completion:nil];
    };
    [cameraVc showPickerVc:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 处理
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        
        [self.selectAssets addObject:image];
        [self.toolBarThumbCollectionView reloadData];
        [self.takePhotoImages addObject:image];
        self.collectionView.selectAssets = [self.selectAssets mutableCopy];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:PICKER_TAKE_PHOTO object:nil userInfo:@{@"image":image}];
        });
        
        NSInteger count = self.selectAssets.count;
        self.makeView.hidden = !count;
        self.makeView.text = [NSString stringWithFormat:@"%ld",(long)count];
        self.doneBtn.enabled = (count > 0);
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        NSLog(@"请在真机使用!");
    }
}

#pragma mark -初始化底部ToorBar
- (void) setupToorBar
{
    UIToolbar *toorBar = [[UIToolbar alloc] init];
    toorBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:toorBar];
    self.toolBar = toorBar;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(toorBar);
    NSString *widthVfl =  @"H:|-0-[toorBar]-0-|";
    NSString *heightVfl = @"V:[toorBar(44)]-0-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
    
    // 左视图 中间距 右视图
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.toolBarThumbCollectionView];
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];
    
    toorBar.items = @[leftItem,fiexItem,rightItem];
    
}

#pragma mark - setter
-(void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    
    if (!_privateTempMaxCount && maxCount >= 0) {
        if (maxCount) {
            _privateTempMaxCount = maxCount;
        }else{
            _privateTempMaxCount = KPhotoShowMaxCount;
        }
    }
    
    if (self.selectAssets.count == maxCount){
        maxCount = -1;
    }else if (self.selectPickerAssets.count - self.selectAssets.count > 0) {
        maxCount = _privateTempMaxCount;
    }
    
    if (!maxCount && !self.selectAssets.count && !self.selectPickerAssets.count) {
        maxCount = KPhotoShowMaxCount;
    }
    
    self.collectionView.maxCount = maxCount;
}

- (void)setAssetsGroup:(HYPhotoPcikerGroup *)assetsGroup
{
    if (!assetsGroup.groupName.length) return ;
    
    _assetsGroup = assetsGroup;
    
    self.title = assetsGroup.groupName;
    
    // 获取Assets
    [self setupAssets];
}


- (void) pickerCollectionViewDidSelected:(HYPhotoPickerCollectionView *) pickerCollectionView deleteAsset:(HYPhotoAssets *)deleteAssets
{
    if (self.selectPickerAssets.count == 0)
    {
        self.selectAssets = [NSMutableArray arrayWithArray:pickerCollectionView.selectAssets];
    }else if (deleteAssets == nil)
    {
        [self.selectAssets addObject:[pickerCollectionView.selectAssets lastObject]];
    }
    
    NSInteger count = self.selectAssets.count;
    self.makeView.hidden = !count;
    self.makeView.text = [NSString stringWithFormat:@"%ld",(long)count];
    self.doneBtn.enabled = (count > 0);
    
    [self.toolBarThumbCollectionView reloadData];
    
    if (self.selectPickerAssets.count || deleteAssets) {
        HYPhotoAssets *asset = [pickerCollectionView.lastDataArray lastObject];
        if (deleteAssets){
            asset = deleteAssets;
        }
        
        NSInteger selectAssetsCurrentPage = -1;
        for (NSInteger i = 0; i < self.selectAssets.count; i++) {
            HYPhotoAssets *photoAsset = self.selectAssets[i];
            if ([photoAsset isKindOfClass:[HYCamera class]])
            {
                continue;
            }
            if([[[[asset.asset defaultRepresentation] url] absoluteString] isEqualToString:[[[photoAsset.asset defaultRepresentation] url] absoluteString]]){
                selectAssetsCurrentPage = i;
                break;
            }
        }
        
        if (
            (self.selectAssets.count > selectAssetsCurrentPage)
            &&
            (selectAssetsCurrentPage >= 0)
            ){
            if (deleteAssets){
                [self.selectAssets removeObjectAtIndex:selectAssetsCurrentPage];
            }
            
            [self.collectionView.selectsIndexPath removeObject:@(selectAssetsCurrentPage)];
            
            [self.toolBarThumbCollectionView reloadData];
            self.makeView.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.selectAssets.count];
        }
        // 刷新下最小的页数
        self.maxCount = self.selectAssets.count + (_privateTempMaxCount - self.selectAssets.count);
    }
}

#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectAssets.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_identifier forIndexPath:indexPath];
    
    if (self.selectAssets.count > indexPath.item) {
        UIImageView *imageView = [[cell.contentView subviews] lastObject];
        // 判断真实类型
        if (![imageView isKindOfClass:[UIImageView class]]) {
            imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            [cell.contentView addSubview:imageView];
        }
        imageView.tag = indexPath.item;
        if ([self.selectAssets[indexPath.item] isKindOfClass:[HYPhotoAssets class]]) {
            imageView.image = [self.selectAssets[indexPath.item] thumbImage];
        }else if ([self.selectAssets[indexPath.item] isKindOfClass:[HYCamera class]]){
            HYCamera *camera = self.selectAssets[indexPath.item];
            imageView.image = [camera thumbImage];
        }
    }
    
    return cell;
}

#pragma mark -
#pragma makr UICollectionViewDelegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *photos = [NSMutableArray array];
    if (self.selectAssets.count && self.selectAssets.count - 1 >= indexPath.item) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        UIImageView *imageView = [[cell.contentView subviews] lastObject];
        for (HYPhotoAssets *asset in self.selectAssets) {
            HYPhotoPickerBrowerPhoto *photo = [[HYPhotoPickerBrowerPhoto alloc] init];
            if ([asset isKindOfClass:[HYPhotoAssets class]]) {
                photo.asset = asset;
            }else if ([asset isKindOfClass:[HYCamera class]]){
                HYCamera *camera = (HYCamera *)asset;
                photo.thumbImage = [camera thumbImage];
            }
            if ([imageView isKindOfClass:[UIImageView class]]) {
                photo.toView = imageView;
            }
            [photos addObject:photo];
        }
    }
    
    HYPhotoPickerBrowserViewController *browserVc = [[HYPhotoPickerBrowserViewController alloc] init];
    browserVc.photos = photos;
    browserVc.delegate = self;
    browserVc.currentIndex = indexPath.row;
    [browserVc showPickerVC:self];
}

- (void)photoBrowser:(HYPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index
{
    // 删除选中的照片
    ALAsset *asset = self.selectAssets[index];
    NSInteger currentPage = index;
    for (NSInteger i = 0; i < self.collectionView.dataArray.count; i++)
    {
        ALAsset *photoAsset = self.collectionView.dataArray[i];
        if ([photoAsset isKindOfClass:[HYPhotoAssets class]] && [asset isKindOfClass:[HYPhotoAssets class]]) {
            HYPhotoAssets *photoAssets = (HYPhotoAssets *)photoAsset;
            HYPhotoAssets *assets = (HYPhotoAssets *)asset;
            if([[[[assets.asset defaultRepresentation] url] absoluteString] isEqualToString:[[[photoAssets.asset defaultRepresentation] url] absoluteString]]){
                currentPage = i;
                break;
            }
        }
        else{
            continue;
            break;
        }
    }
    if ([asset isKindOfClass:[HYPhotoAssets class]])
    {
        for (int i=0; i<self.collectionView.selectAssets.count; i++)
        {
            id assets = self.collectionView.selectAssets[i];
            if ([assets isKindOfClass:[HYPhotoAssets class]])
            {
                HYPhotoAssets *photot = (HYPhotoAssets *)assets;
                if (photot.cuurntIndex == currentPage)
                {
                    [self.collectionView.selectAssets removeObject:assets];
                }
            }
        }
    }
    else if([asset isKindOfClass:[HYCamera class]])
    {
        for (int i=0; i<self.collectionView.selectAssets.count; i++)
        {
            id assets = self.collectionView.selectAssets[i];
            if ([assets isKindOfClass:[HYCamera class]])
            {
                HYCamera *photot = (HYCamera *)assets;
                HYCamera *imageAss = (HYCamera *)asset;
                if ([photot.imagePath isEqualToString:imageAss.imagePath])
                {
                    [self.collectionView.selectAssets removeObject:assets];
                }
            }
        }
    }

    [self.collectionView.selectsIndexPath removeObject:@(currentPage)];
    [self.selectAssets removeObjectAtIndex:index];
    [self.toolBarThumbCollectionView reloadData];
    [self.collectionView reloadData];
    self.makeView.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.selectAssets.count];

}
#pragma mark -<Navigation Actions>
#pragma mark -开启异步通知
- (void) back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) done{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:PICKER_TAKE_DONE object:nil userInfo:@{@"selectAssets":self.selectAssets}];
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc{
    // 赋值给上一个控制器
    self.groupVc.selectAsstes = self.selectAssets;
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
