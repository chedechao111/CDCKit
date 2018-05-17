//
//  CDAView.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/25.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDAView.h"

@implementation CDAView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    NSLog(@"i'm a view ,%@",view);
    return view;
}

@end
