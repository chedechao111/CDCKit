//
//  CDPresentToVC.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/10.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDPresentToVC.h"

@interface CDPresentToVC ()

@end

@implementation CDPresentToVC {
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    weakOf(self);
    CDQuickButton *btn = [CDQuickButton createBtnWithName:@"dismiss" WithBlock:^(id sender) {
        strongOf(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:btn];
}


- (void)dealloc {
    NSLog(@"mu ");
}

@end
