//
//  CDPopVC.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/11.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDVC2.h"
#import "CDNavTranslation.h"

@interface CDVC2 ()

@end

@implementation CDVC2
{
    CDNavTranslation *_navTransLation;
}

- (instancetype)initWithNavTranslation:(CDNavTranslation *)navTransLation
{
    self = [super init];
    if (self) {
        _navTransLation = navTransLation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
