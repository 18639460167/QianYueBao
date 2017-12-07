//
//  BDContractPictureTableViewCell.m
//  QianYueBao
//
//  Created by Black on 17/4/5.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDContractPictureTableViewCell.h"


#pragma mark - 创建图片展示列表
@implementation BDPhotoImageView

+ (instancetype)createImageWithFrame:(CGRect)frame
{
    BDPhotoImageView *imageView = [[BDPhotoImageView alloc]initWithFrame:frame];
    return imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.contentMode =  UIViewContentModeScaleAspectFill;
        self.clipsToBounds  = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = WScale*3;
//        UIButton *deleteBtn = [UIButton buttonWithType:0];
//        [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
//        [deleteBtn setBackgroundImage:IMAGE_NAME(@"delete") forState:0];
//        [self addSubview:deleteBtn];
//        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).offset(WScale*-2);
//            make.top.equalTo(self).offset(WScale*2);
//            make.size.mas_equalTo(CGSizeMake(HScale*25, HScale*25));
//        }];
    }
    return self;
}

- (void)deleteAction
{
    if (self.complete)
    {
        self.complete();
    }
}

@end

@interface BDPictureView()

@property (nonatomic, strong) NSArray *urlArray;

@end

@implementation BDPictureView

+ (instancetype)createView
{
    BDPictureView *view = [[BDPictureView alloc]initWithFrame:CGRectZero];
    return view;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = RGB(245, 245, 245);
        self.layer.cornerRadius = WScale*5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)reloadData:(NSArray *)pictureArray currentVC:(UIViewController *)vc
{
    self.VC = vc;
    self.urlArray = pictureArray;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    HYWeakSelf;
    CGFloat width = (SCREEN_WIDTH-WScale*70)/3;
    
    for (int i=0; i<pictureArray.count; i++)
    {
        int x = i%3;
        int y = i/3;
        
        BDPhotoImageView *view = [BDPhotoImageView createImageWithFrame:CGRectMake(WScale*10+(width+WScale*10)*x, WScale*10+(width+WScale*10)*y, width, width)];
        view.tag = i+1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
        [view addGestureRecognizer:tap];
        view.complete = ^(){
            if (wSelf.deleteComplete)
            {
                wSelf.deleteComplete(i);
            }
        };
        id asset = pictureArray[i];
        if ([asset isKindOfClass:[HYPhotoAssets class]])
        {
            HYPhotoAssets *pAsset = (HYPhotoAssets *)asset;
            view.image = pAsset.originImage;
        }
        else if ([asset isKindOfClass:[NSString class]])
        {
            [view sd_setImageWithURL:[NSURL URLWithString:asset] placeholderImage:[UIImage imageNamed:@"addPicture"] options:SDWebImageAllowInvalidSSLCertificates];
        }
        else if([asset isKindOfClass:[HYCamera class]])
        {
            HYCamera *cAsset = (HYCamera *)asset;
            view.image = cAsset.photoImage;
        }
        [self addSubview:view];
    }
}

- (void)imageAction:(UITapGestureRecognizer *)tap
{
    UIImageView *image = (UIImageView *)tap.view;
    NSMutableArray *photos = [NSMutableArray new];
    for (int i=0; i<self.urlArray.count; i++)
    {
        HYPhotoPickerBrowerPhoto *photo = [[HYPhotoPickerBrowerPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:self.urlArray[i]];
        [photos addObject:photo];
    }
    HYPhotoPickerBrowserViewController *browserVc = [[HYPhotoPickerBrowserViewController alloc] init];
    browserVc.photos = photos;
    browserVc.currentIndex = image.tag-1;
    browserVc.delegate = self;
    browserVc.deleleBtn.hidden = self.imgCanEdit;
    [browserVc showPickerVC:self.VC];
}

- (void)photoBrowser:(HYPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index
{
    NSString *str = [NSString stringWithFormat:@"%ld",(long)index];
    int value = [str intValue];
    if (self.deleteComplete)
    {
        self.deleteComplete(value);
    }
}

@end

#pragma mark -cell
@interface BDContractPictureTableViewCell()


@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) NSMutableArray *urlArray;

@property (nonatomic, strong) NSMutableArray *pictureArray;

@property (nonatomic, strong) BDPictureView *pictureView;

@property (nonatomic, strong) UIViewController *VC;

@end

@implementation BDContractPictureTableViewCell
@synthesize pictureView;
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
        UIImageView *cirImage = [UIImageView createImage:@"circle"];
        [self addSubview:cirImage];
        [cirImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(HScale*35, HScale*35));
            make.top.equalTo(self).offset(WScale*7.5);
            make.right.equalTo(self).offset(WScale*-15);
        }];
        
        UIImageView *addImage = [UIImageView createImage:@"add"];
        [cirImage addSubview:addImage];
        [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cirImage.mas_centerY);
            make.centerX.mas_equalTo(cirImage.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(HScale*20, HScale*20));
        }];
        
        UIButton *button = [UIButton buttonWithType:0];
        button.backgroundColor = CLEAR_COLOR;
        [button addTarget:self action:@selector(addPictureAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(WScale*7.5);
            make.size.mas_equalTo(CGSizeMake(HScale*40, HScale*35));
            make.right.equalTo(self).offset(WScale*-15);
        }];
        
        titleLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(HScale*7.5);
            make.height.mas_equalTo(HScale*35);
            make.left.equalTo(self).offset(WScale*15);
            make.right.equalTo(button.mas_left).offset(WScale*-10);
        }];
        
        UIImageView *lineImage = [UIImageView createImageWithColor:[UIColor cEightColor]];
        [self addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.left.equalTo(self).offset(WScale*15);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        HYWeakSelf;
        pictureView = [BDPictureView createView];
        pictureView.deleteComplete = ^(int index){
            [wSelf.urlArray removeObjectAtIndex:index];
            if (wSelf.contractImage)
            {
                wSelf.contractImage(wSelf.urlArray);
            }
        };
        [self addSubview:pictureView];
        [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(WScale*15);
            make.top.equalTo(titleLbl.mas_bottom).offset(HScale*3.5);
            make.right.equalTo(self).offset(WScale*-15);
            make.bottom.equalTo(lineImage.mas_top).offset(-HScale*4);
        }];
        
    }
    return self;
}

- (void)bindTitle:(NSString *)title currentVC:(UIViewController *)currenVC
{
    self.titleLbl.text = title;
    self.VC = currenVC;
}

- (void)addPictureAction
{
    if (!self.canEdit)
    {
        if (self.VC)
        {
            HYWeakSelf;
            HYPhotoPickerViewController *pickerVc = [[HYPhotoPickerViewController alloc] init];
            
            pickerVc.status = PickerViewShowStatusCameraRoll;
            pickerVc.photoStatus = PickerPhotoStatusPhotos;
            pickerVc.maxCount = 9-self.urlArray.count;
            pickerVc.topShowPhotoPicker = YES;
            pickerVc.isShowCamera = YES;
            pickerVc.callBack = ^(NSArray<HYPhotoAssets *> *status){
                HYStrongSelf;
                for (int i=0; i<status.count; i++)
                {
                    [sSelf.pictureArray addObject:status[i]];
                }
                [BDStyle showLoading:LS(@"Uploading") rootView:sSelf.VC.view];
                [BDCommonVieModel updateMorePicture:sSelf.pictureArray backHandler:^(NSInteger failNum, NSArray *picturArray) {
                    NSString *message = LS(@"Uploaded_Success");
                    [sSelf.pictureArray removeAllObjects];
                    if (failNum != 0)
                    {
                        message = [NSString stringWithFormat:LS(@"Upload_Fail_Number"),failNum];
                    }
                    for (NSString *url in picturArray)
                    {
                        [self.urlArray addObject:url];
                    }
                    if (wSelf.contractImage)
                    {
                        wSelf.contractImage(wSelf.urlArray);
                    }
                    [BDStyle handlerDataError:message currentVC:sSelf.VC handler:nil];
                }];
            };
            [pickerVc showPickerVc:self.VC];
        }
    }
}

- (void)bindData:(NSArray *)dataArray
{
    self.urlArray = [NSMutableArray arrayWithArray:dataArray];
    self.pictureArray = [NSMutableArray new];
    [pictureView reloadData:self.urlArray currentVC:self.VC];
}

- (void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
    pictureView.imgCanEdit = canEdit;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
