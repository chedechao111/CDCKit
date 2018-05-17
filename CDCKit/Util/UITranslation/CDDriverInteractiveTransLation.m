//
//  CDDriverInteractiveTransLation.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/10.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDDriverInteractiveTransLation.h"

@implementation CDDriverInteractiveTransLation
{
    InteractiveOperation _operation;
    InteractiveDirection _direction;
    __weak UIViewController *_vc;
}

+ (instancetype)interactiveTraslationWithDirection:(InteractiveDirection)direction operation:(InteractiveOperation)operation {
    return [[self alloc] initWithDirection:direction operation:operation];
}

- (instancetype)initWithDirection:(InteractiveDirection)direction operation:(InteractiveOperation)operation
{
    self = [super init];
    if (self) {
        _operation = operation;
        _direction = direction;
    }
    return self;
}

- (UIPanGestureRecognizer *)addPanGestureWithVC:(UIViewController *)vc {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    _vc = vc;
    [vc.view addGestureRecognizer:pan];
    return pan;
}

- (CGFloat)percentWithGesture:(UIPanGestureRecognizer *)pan {
    CGFloat translation = 0.0f;
    static CGFloat denominator;
    denominator = _vc.view.width;
    switch (_direction) {
        case InteractiveDirection_None:{
            translation = 0;
        }
            break;
        case InteractiveDirection_Left:{
            translation = -[pan translationInView:_vc.view].x;
        }
            break;
        case InteractiveDirection_Right:{
            translation = [pan translationInView:_vc.view].x;
        }
            break;
        case InteractiveDirection_Up:{
            translation = -[pan translationInView:_vc.view].y;
        }
            break;
        case InteractiveDirection_Down:{
            translation = [pan translationInView:_vc.view].y;
        }
            break;
    }
//    NSLog(@"%d,%f",_direction,translation);
    return translation / denominator;
}

- (void)panGesture:(UIPanGestureRecognizer *)pan {
    UIGestureRecognizerState state = pan.state;
    CGFloat temp = [self percentWithGesture:pan];
    CGFloat percent = temp <= 0 ? 0 : temp;
    if (percent <= 0 ) {
        return;
    }
//    NSLog(@"%f",percent);
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            self.isInteractive = YES;
            [self startGesture];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            [self updateInteractiveTransition:percent];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            self.isInteractive = NO;
            if(percent > 0.5) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        }
        default:
            break;
    }
}

- (void)startGesture {
    switch (_operation) {
        case InteractiveOperation_Persent:
        case InteractiveOperation_Push:
            if (_pushBlock) {
                _pushBlock();
            }
            break;
            
        case InteractiveOperation_Pop:{
            [_vc.navigationController popViewControllerAnimated:YES];
        }
            break;
        case InteractiveOperation_Dismiss:{
            [_vc dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
@end
