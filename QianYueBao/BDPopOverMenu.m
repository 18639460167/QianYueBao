//
//  BDPopOverMenu.m
//  QianYueBao
//
//  Created by Black on 17/4/14.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDPopOverMenu.h"

#define BDDefaultMenuRowHeight (HScale*45)
#define BDDefaultMenuArrowHeight    0.0
#define BDDefaultMenuArrowWidth     0.0
#define BDDefaultMenuCornerRadius (WScale*4)
#define BDDefaultMargin            (WScale*4)

typedef NS_ENUM(NSUInteger,BDPopOverMenuArrowDirection) {
    
    BDPopOverMenuArrowDirectionUp, // 向上展示
    BDPopOverMenuArrowDirectionDown,
};

#pragma mark - BDPopOverMenuCell

@implementation BDPopOverMenuCell
@synthesize titleLbl;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        titleLbl = [UILabel createNoramlLbl:@"" font:14 textColor:[UIColor threeTwoColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.left.equalTo(self).offset(WScale*8);
        }];
        
        UIImageView *lineImage = [UIImageView createImageWithColor:[UIColor cEightColor]];
        [self addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)bindData:(NSString *)title
{
    titleLbl.text = title;
}
@end

@interface BDPopOverMenuView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *menuStringArray;
@property (nonatomic, assign) BDPopOverMenuArrowDirection arrirwDirection;
@property (nonatomic, copy) BDPopOverMenuDoneBlock doneBlock;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@end
@implementation BDPopOverMenuView
@synthesize tableview;
@synthesize menuStringArray;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        tableview = [UITableView createTableview:UITableViewStylePlain fatherView:self];
        tableview.backgroundColor = WHITE_COLOR;
        tableview.layer.cornerRadius = BDDefaultMenuCornerRadius;
        tableview.layer.masksToBounds = YES;
    }
    return self;
}

- (void)showWithAnglePoint:(CGPoint)anglePoint
             withNameArray:(NSArray<NSString*>*)nameArray
          shouldAutoScroll:(BOOL)shouldAutoScroll
           arrorwDirection:(BDPopOverMenuArrowDirection)arrowDirection
                 doneBlock:(BDPopOverMenuDoneBlock)doneBlock
{
    menuStringArray = nameArray;
    self.doneBlock = doneBlock;
    self.arrirwDirection = arrowDirection;
    [tableview reloadData];
    tableview.scrollEnabled = shouldAutoScroll;
    
    switch (self.arrirwDirection)
    {
        case BDPopOverMenuArrowDirectionUp:
        {
            tableview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }
            break;
        case BDPopOverMenuArrowDirectionDown:
        {
            tableview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }
            break;
            
        default:
            break;
    }
    [self drawBackgroundLayerWithAnglePoint:anglePoint];
}

- (void)drawBackgroundLayerWithAnglePoint:(CGPoint)anglePoint
{
    if (self.backgroundLayer)
    {
        [self.backgroundLayer removeFromSuperlayer];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (_arrirwDirection)
    {
        case BDPopOverMenuArrowDirectionUp:
        {
            [path moveToPoint:anglePoint];
            [path addLineToPoint:CGPointMake(anglePoint.x-BDDefaultMenuArrowWidth, BDDefaultMenuArrowHeight)];
            [path addLineToPoint:CGPointMake(BDDefaultMenuCornerRadius, BDDefaultMenuArrowHeight)];
            [path addArcWithCenter:CGPointMake(BDDefaultMenuCornerRadius, BDDefaultMenuArrowHeight+BDDefaultMenuCornerRadius) radius:BDDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
            [path addLineToPoint:CGPointMake(0, self.bounds.size.height-BDDefaultMenuCornerRadius)];
             [path addArcWithCenter:CGPointMake(BDDefaultMenuCornerRadius, self.bounds.size.height - BDDefaultMenuCornerRadius) radius:BDDefaultMenuCornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - BDDefaultMenuCornerRadius, self.bounds.size.height)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - BDDefaultMenuCornerRadius, self.bounds.size.height - BDDefaultMenuCornerRadius) radius:BDDefaultMenuCornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
            [path addLineToPoint:CGPointMake(self.bounds.size.width , BDDefaultMenuCornerRadius + BDDefaultMenuArrowHeight)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - BDDefaultMenuCornerRadius, BDDefaultMenuCornerRadius + BDDefaultMenuArrowHeight) radius:BDDefaultMenuCornerRadius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
            [path addLineToPoint:CGPointMake(anglePoint.x + BDDefaultMenuArrowWidth, BDDefaultMenuArrowHeight)];
            [path closePath];
            
        }
            break;
        case BDPopOverMenuArrowDirectionDown:
        {
            [path moveToPoint:anglePoint];
            [path addLineToPoint:CGPointMake(anglePoint.x-BDDefaultMenuArrowWidth, anglePoint.y-BDDefaultMenuArrowHeight)];
            [path addLineToPoint:CGPointMake(BDDefaultMenuCornerRadius, anglePoint.y-BDDefaultMenuArrowHeight)];
            [path addArcWithCenter:CGPointMake(BDDefaultMenuCornerRadius, anglePoint.y - BDDefaultMenuArrowHeight - BDDefaultMenuCornerRadius) radius:BDDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:YES];
            [path addLineToPoint:CGPointMake( 0, BDDefaultMenuCornerRadius)];
            [path addArcWithCenter:CGPointMake(BDDefaultMenuCornerRadius, BDDefaultMenuCornerRadius) radius:BDDefaultMenuCornerRadius startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - BDDefaultMenuCornerRadius, 0)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - BDDefaultMenuCornerRadius, BDDefaultMenuCornerRadius) radius:BDDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
            [path addLineToPoint:CGPointMake(self.bounds.size.width , anglePoint.y - (BDDefaultMenuCornerRadius + BDDefaultMenuArrowHeight))];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - BDDefaultMenuCornerRadius, anglePoint.y - (BDDefaultMenuCornerRadius + BDDefaultMenuArrowHeight)) radius:BDDefaultMenuCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [path addLineToPoint:CGPointMake(anglePoint.x + BDDefaultMenuArrowWidth, anglePoint.y - BDDefaultMenuArrowHeight)];
            [path closePath];
            
        }
            break;
            
        default:
            break;
    }
    self.backgroundLayer = [CAShapeLayer layer];
    self.backgroundLayer.path = path.CGPath;
    self.backgroundLayer.fillColor = WHITE_COLOR.CGColor;
    self.backgroundLayer.strokeColor = WHITE_COLOR.CGColor;
    [self.layer insertSublayer:self.backgroundLayer atIndex:0];
}

#pragma mark -tableview datasource delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BDDefaultMenuRowHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuStringArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDPopOverMenuCell *cell = [BDPopOverMenuCell createTableCell:tableView];
    [cell bindData:self.menuStringArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.doneBlock)
    {
        self.doneBlock(indexPath.row);
    }
}
@end


#pragma mark -BDPopOverMenu

@interface BDPopOverMenu()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) BDPopOverMenuView *popMenuView;
@property (nonatomic, copy) BDPopOverMenuDoneBlock doneBlock;
@property (nonatomic, copy) BDPopOverMenuDismissBlock dissmissBlock;

@property (nonatomic, strong) UIView *sender;
@property (nonatomic, assign) CGRect senderFrame;
@property (nonatomic, strong) NSArray<NSString*> *menuArray;
@property (nonatomic, assign) BOOL isCurrentlyOnScreen;

@end
@implementation BDPopOverMenu

+ (BDPopOverMenu *)sharedInstance
{
    static dispatch_once_t once = 0;
    static BDPopOverMenu *share;
    dispatch_once(&once, ^{
        share = [[BDPopOverMenu alloc]init];
    });
    return share;
}

#pragma mark -Publc Method

+ (void)showForSender:(UIView *)sender
            withIndex:(NSInteger)currentIndex
             withMenu:(NSArray<NSString *> *)menuArray
            doneBlock:(BDPopOverMenuDoneBlock)doneBlock
        dissmissBlock:(BDPopOverMenuDismissBlock)dissmissBlock
{
    [[self sharedInstance] showForSender:sender withInde:currentIndex senderFrame:CGRectNull withMenu:menuArray doneBlock:doneBlock dissBlock:dissmissBlock];
}

- (void)showForSender:(UIView *)sender withInde:(NSInteger)currentIndex senderFrame:(CGRect)senderFrame withMenu:(NSArray<NSString *>*)menuArray doneBlock:(BDPopOverMenuDoneBlock)doneBlock dissBlock:(BDPopOverMenuDismissBlock) dissmissBlock
{
    [self initViews];
    self.sender = sender;
    self.senderFrame = senderFrame;
    self.menuArray = menuArray;
    self.doneBlock = doneBlock;
    self.dissmissBlock = dissmissBlock;
    [self adjustPopOverMenu];
}

#pragma mark -Private Methods

- (instancetype)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onChangeStatusBarOrientationNotification:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - 显示隐藏
- (void)dissMiss
{
    self.isCurrentlyOnScreen = NO;
    [self doneActionWithSelectIndex:-1];
}

- (void)show
{
    self.isCurrentlyOnScreen = YES;
    [UIView animateWithDuration:0.2
                     animations:^{
                         _popMenuView.alpha = 1;
                         _bgView.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.3];
                     }];
}

- (void)doneActionWithSelectIndex:(NSInteger)selectIndex
{
    [UIView animateWithDuration:0.2 animations:^{
        _popMenuView.alpha = 0;
        _bgView.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        if (finished)
        {
            [_bgView removeFromSuperview];
            if (selectIndex <0)
            {
                if (self.dissmissBlock)
                {
                    self.dissmissBlock();
                }
            }
            else
            {
                
            }if (self.doneBlock) {
                self.doneBlock(selectIndex);
            }
        }
    }];
}
- (void)initViews
{
    if (!_bgView)
    {
        _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundViewTapped:)];
        tap.delegate = self;
        [_bgView addGestureRecognizer:tap];
        _bgView.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0];
    }
    
    if (!_popMenuView)
    {
        _popMenuView = [[BDPopOverMenuView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [_bgView addSubview:_popMenuView];
        _popMenuView.alpha = 0;
    }
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:_bgView];
}

- (void)adjustPopOverMenu
{
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CGRect senderRect;
    
    if (self.sender)
    {
        senderRect = [self.sender.superview convertRect:self.sender.frame toView:_bgView];
    }
    else
    {
        senderRect = self.senderFrame;
    }
    
    if (senderRect.origin.y > SCREEN_HEIGHT)
    {
        senderRect.origin.y = SCREEN_HEIGHT;
    }
    
    CGFloat menuHeight;
    BOOL sholdAutoScroll = NO;
    if (self.menuArray.count <= 5)
    {
         menuHeight = BDDefaultMenuRowHeight * self.menuArray.count + BDDefaultMenuArrowHeight;
    }
    else
    {
        menuHeight = BDDefaultMenuRowHeight * 5 + BDDefaultMenuArrowHeight;
        sholdAutoScroll=YES;
    }
    
    CGPoint menuArrowPoint = CGPointMake(senderRect.origin.x + (senderRect.size.width)/2, 0);
    CGFloat menuX = 0;
    CGRect menuRect = CGRectZero;
    
    BDPopOverMenuArrowDirection  arrorwDirection;
    if (senderRect.origin.y + senderRect.size.height/2  < SCREEN_HEIGHT/2)
    {
        arrorwDirection = BDPopOverMenuArrowDirectionUp;
        menuArrowPoint.y = 0;
        
    }
    else
    {
        arrorwDirection = BDPopOverMenuArrowDirectionDown;
        menuArrowPoint.y = menuHeight;
    }
    
    if (menuArrowPoint.x + self.sender.frame.size.width/2 + BDDefaultMargin > SCREEN_WIDTH)
    {
        menuArrowPoint.x = MIN(menuArrowPoint.x - (SCREEN_WIDTH - self.sender.frame.size.width - BDDefaultMargin), menuArrowPoint.x);
        menuX = SCREEN_WIDTH - self.sender.frame.size.width - BDDefaultMargin;
    }
    else if ( menuArrowPoint.x - self.sender.frame.size.width/2 - BDDefaultMargin < 0)
    {
        menuArrowPoint.x = MAX( BDDefaultMenuCornerRadius + BDDefaultMenuArrowWidth, menuArrowPoint.x - BDDefaultMargin);
        menuX = BDDefaultMargin;
    }
    else
    {
        menuArrowPoint.x = self.sender.frame.size.width/2;
        menuX = senderRect.origin.x + (senderRect.size.width)/2 - self.sender.frame.size.width/2;
    }
    
    if (arrorwDirection == BDPopOverMenuArrowDirectionUp)
    {
        menuRect = CGRectMake(menuX, (senderRect.origin.y + senderRect.size.height+HScale*2), self.sender.frame.size.width, menuHeight);
        // if too long and is out of screen
        if (menuRect.origin.y + menuRect.size.height > SCREEN_HEIGHT)
        {
            menuRect = CGRectMake(menuX, (senderRect.origin.y + senderRect.size.height), self.sender.frame.size.width, SCREEN_HEIGHT - menuRect.origin.y - BDDefaultMargin);
            sholdAutoScroll = YES;
        }
    }
    else
    {
        
        menuRect = CGRectMake(menuX, (senderRect.origin.y - menuHeight-HScale*2), self.sender.frame.size.width, menuHeight);
        // if too long and is out of screen
        if (menuRect.origin.y  < 0)
        {
            menuRect = CGRectMake(menuX, BDDefaultMargin, self.sender.frame.size.width, senderRect.origin.y - BDDefaultMargin);
            menuArrowPoint.y = senderRect.origin.y;
            sholdAutoScroll = YES;
        }
    }
    
    _popMenuView.frame = menuRect;
    
    HYWeakSelf;
    [_popMenuView showWithAnglePoint:menuArrowPoint withNameArray:self.menuArray shouldAutoScroll:sholdAutoScroll arrorwDirection:arrorwDirection doneBlock:^(NSInteger selectIndex) {
        [wSelf doneActionWithSelectIndex:selectIndex];
    }];
    [self show];
    
}




#pragma mark - 通知

-(void)onChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    if (self.isCurrentlyOnScreen) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self adjustPopOverMenu];
        });
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

-(void)onBackgroundViewTapped:(UIGestureRecognizer *)gesture
{
    [self dissMiss];
}



@end
