//
//  BDSelectMessageViewController.h
//  QianYueBao
//
//  Created by Black on 17/5/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSuperViewController.h"

@interface BDSelectMessageViewController : BDSuperViewController

//@property (nonatomic, copy) BDHandler selecthandler;

@property (nonatomic, copy) void (^selecthandler)(NSString *code,NSString *message);

@end
