//
//  CDQuickButton.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/10.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDQuickButton.h"

@implementation CDQuickButton {
    clickedBlock _block;
}

+ (CDQuickButton *)createBtnWithName:(NSString *)str WithBlock:(clickedBlock)block  {
    CDQuickButton *btn = [[self alloc] initWithBlock:block];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.x = 100;
    btn.y = 50;
    return btn;
    
}

- (instancetype)initWithBlock:(clickedBlock)block {
    if (self = [super init]) {
        _block = block;
        [self addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clicked:(id)sender {
    if (_block) {
        _block(sender);
    }
}

@end
