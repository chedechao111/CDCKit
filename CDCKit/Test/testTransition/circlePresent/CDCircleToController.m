//
//  CDCircleToController.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/16.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDCircleToController.h"
#import "CDQuickButton.h"
#import "CDNavTranslation.h"

@interface CDCircleToController ()

@end

@implementation CDCircleToController
{
    CDQuickButton *circleBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    weakOf(self);
    circleBtn = [CDQuickButton createBtnWithName:@"circle" WithBlock:^(id sender) {
        strongOf(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:circleBtn];
    
}
@end
