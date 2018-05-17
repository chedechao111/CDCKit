//
//  CDProgressView.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/25.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDProgressView.h"

@implementation CDProgressView

- (void)setProgress:(float)progress {
    [super setProgress:progress];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(0, 0, self.width, 10);
    }];
}

@end
