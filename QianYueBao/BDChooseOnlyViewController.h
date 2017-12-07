//
//  BDChooseOnlyViewController.h
//  QianYueBao
//
//  Created by Black on 17/5/11.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSuperViewController.h"

@interface BDChooseOnlyViewController : BDSuperViewController

@property (nonatomic, copy) NSString *country;

@property (nonatomic, assign) BOOL isSex;
@property (nonatomic, copy) void(^backhandler)(NSString *name,NSString *code);


@end
