//
//  HYPhotoPickerGroupViewController.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "HYPhotoPickerGroupViewController.h"

#import "HYPhotoPickerCollectionView.h"
#import "HYPhotoPickerDatas.h"
#import "HYPhotoPickerGroupViewController.h"
#import "HYPhotoPcikerGroup.h"
#import "HYPhotoPickerGroupTableViewCell.h"
#import "HYPhotoPickerAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+HYPhotoLib.h"
#import "UIViewController+Alert.h"
#import "HYPhotoPickerCommon.h"
@interface HYPhotoPickerGroupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , weak) HYPhotoPickerAssetsViewController *collectionVc;

@property (nonatomic , weak) UITableView *tableView;
@property (nonatomic , strong) NSArray *groups;
@end

@implementation HYPhotoPickerGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择相册";
    
    // 设置按钮
    [self setupButtons];
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        // 判断没有权限获取用户相册的话，就提示个View
        UIImageView *lockView = [[UIImageView alloc] init];
        lockView.image = [UIImage ml_imageFormBundleNamed:@"lock"];
        lockView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200);
        lockView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:lockView];
        
        UILabel *lockLbl = [[UILabel alloc] init];
        lockLbl.text = LS(@"PICKER_PowerBrowserPhotoLibirayText");
        lockLbl.numberOfLines = 0;
        lockLbl.textAlignment = NSTextAlignmentCenter;
        lockLbl.frame = CGRectMake(20, 0, self.view.frame.size.width - 40, self.view.frame.size.height);
        [self.view addSubview:lockLbl];
    }else{
        [self tableView];
        // 获取图片
        [self getImgs];
    }

}

- (void) setupButtons{
    HYWeakSelf;
    [BDStyle setRigthBtnInVC:self messge:LS(@"Cancel") action:^{
        [wSelf back];
    }];
//        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
//    
//        self.navigationItem.rightBarButtonItem = barItem;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.rowHeight = 80;
        tableView.delegate = self;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.separatorInset = UIEdgeInsetsZero;
        [tableView registerClass:[HYPhotoPickerGroupTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HYPhotoPickerGroupTableViewCell class])];
        [self.view addSubview:tableView];
        self.tableView = tableView;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(tableView);
        
        NSString *heightVfl = @"V:|-0-[tableView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
        NSString *widthVfl = @"H:|-0-[tableView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];
        
    }
    return _tableView;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HYPhotoPickerGroupTableViewCell *cell = (HYPhotoPickerGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HYPhotoPickerGroupTableViewCell class])];
    
    if (cell == nil){
        cell = [[HYPhotoPickerGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HYPhotoPickerGroupTableViewCell"];
    }
    cell.group = self.groups[indexPath.row];
    return cell;
    
}

#pragma mark 跳转到控制器里面的内容
- (void) jump2StatusVc{
    // 如果是相册
    HYPhotoPcikerGroup *gp = nil;
    for (HYPhotoPcikerGroup *group in self.groups) {
        if (self.status == PickerViewShowStatusCameraRoll && ([group.groupName isEqualToString:@"Camera Roll"] || [group.groupName isEqualToString:@"相机胶卷"])) {
            gp = group;
            break;
        }else if (self.status == PickerViewShowStatusSavePhotos && ([group.groupName isEqualToString:@"Saved Photos"] || [group.groupName isEqualToString:@"保存相册"])){
            gp = group;
            break;
        }else if (self.status == PickerViewShowStatusPhotoStream &&  ([group.groupName isEqualToString:@"Stream"] || [group.groupName isEqualToString:@"我的照片流"])){
            gp = group;
            break;
        }
    }
    
    if (!gp) return ;
    
    [self showWaitingAnimationWithText:nil];
    HYPhotoPickerAssetsViewController *assetsVc = [[HYPhotoPickerAssetsViewController alloc] init];
    assetsVc.selectPickerAssets = self.selectAsstes;
    assetsVc.assetsGroup = gp;
    assetsVc.isShowCamera = self.isShowCamera;
    assetsVc.topShowPhotoPicker = self.topShowPhotoPicker;
    assetsVc.groupVc = self;
    assetsVc.maxCount = self.maxCount;
    [self hideWaitingAnimation];
    [self.navigationController pushViewController:assetsVc animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideWaitingAnimation];
}

#pragma mark -<UITableViewDelegate>

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showWaitingAnimationWithText:nil];
    HYPhotoPcikerGroup *group = self.groups[indexPath.row];
    HYPhotoPickerAssetsViewController *assetsVc = [[HYPhotoPickerAssetsViewController alloc] init];
    assetsVc.selectPickerAssets = self.selectAsstes;
    assetsVc.groupVc = self;
    assetsVc.maxCount = self.maxCount;
    assetsVc.assetsGroup = group;
    assetsVc.isShowCamera = self.isShowCamera;
    assetsVc.topShowPhotoPicker = self.topShowPhotoPicker;
    [self hideWaitingAnimation];
    [self.navigationController pushViewController:assetsVc animated:YES];
}

#pragma mark -<Images Datas>

-(void)getImgs{
    HYPhotoPickerDatas *datas = [HYPhotoPickerDatas defaultPicker];
    
    __weak typeof(self) weakSelf = self;
    
    if (self.photoStatus == PickerPhotoStatusVideos){
        // 获取所有的视频URLs
        [datas getAllGroupWithVideos:^(NSArray *groups) {
            self.groups = groups;
            if (self.status) {
                [self jump2StatusVc];
            }
            weakSelf.tableView.dataSource = self;
            [weakSelf.tableView reloadData];
        }];
    }else if(self.photoStatus == PickerPhotoStatusPhotos){
        // 获取所有的图片URLs
        [datas getAllGroupWithAllPhotos:^(NSArray *groups) {
            self.groups = groups;
            if (self.status) {
                [self jump2StatusVc];
            }
            weakSelf.tableView.dataSource = self;
            [weakSelf.tableView reloadData];
        }];
    }else{
        // 获取所有的图片及视频URLs
        [datas getAllGroupWithPhotosAndVideos:^(NSArray *groups) {
            self.groups = groups;
            if (self.status) {
                [self jump2StatusVc];
            }
            weakSelf.tableView.dataSource = self;
            [weakSelf.tableView reloadData];
        }];
    }
}


#pragma mark -<Navigation Actions>
- (void) back
{
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
