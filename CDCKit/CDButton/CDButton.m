//
//  CDButton.m
//  CDCKit
//
//  Created by 车德超 on 2018/5/17.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDButton.h"

@implementation CDButton {
    __weak id _target;
    SEL _action;
}

- (void)addTarget:(id)target action:(SEL)action {
    _target = target;
    _action = action;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_target performSelector:_action];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

@end
