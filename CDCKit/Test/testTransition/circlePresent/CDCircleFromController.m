//
//  CDCircleFromController.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/16.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDCircleFromController.h"
#import "CDCircleToController.h"
#import "CDNavTranslation.h"

@interface CDCircleFromController ()<CDNavTranslationDelegate, CAAnimationDelegate>

@end

@implementation CDCircleFromController
{
    CDQuickButton *circleBtn;
    CDCircleToController *toVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    weakOf(self);
    circleBtn = [CDQuickButton createBtnWithName:@"circle" WithBlock:^(id sender) {
        strongOf(self);
        [self presentVC];
    }];
    [self.view addSubview:circleBtn];
    circleBtn.backgroundColor = [UIColor blueColor];
    circleBtn.width = circleBtn.height = 40;
    circleBtn.y = 200;
    circleBtn.layer.cornerRadius = 20;
    circleBtn.layer.masksToBounds = YES;

    toVC = [CDCircleToController new];
    CDNavTranslation *translation = [CDNavTranslation translationWithDirection:InteractiveDirection_Up operation:InteractivePublicOperation_Persent fromVC:self toVC:toVC];
    translation.delegate = self;
}

- (void)presentVC {
    [self presentViewController:toVC animated:YES completion:nil];
}

- (NSTimeInterval)durationTraslationAnimation {
    return 0.5;
}

static bool isPresent = false;
- (void)presentTranslationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC {
    isPresent = true;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];

    UIBezierPath *smallCirclePath = [UIBezierPath bezierPathWithOvalInRect:circleBtn.frame];
    CGFloat x = MAX(circleBtn.x, containerView.frame.size.width - circleBtn.x);
    CGFloat y = MAX(circleBtn.y, containerView.frame.size.height - circleBtn.y);
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    UIBezierPath *bigCirclePath = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CAShapeLayer *bigCircleLayer = [CAShapeLayer layer];
    bigCircleLayer.path = bigCirclePath.CGPath;
    toVC.view.layer.mask = bigCircleLayer;

    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.fromValue = (__bridge id)smallCirclePath.CGPath;
    basicAnimation.toValue = (__bridge id)bigCirclePath.CGPath;
    basicAnimation.duration = 0.5;
    basicAnimation.delegate = self;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [basicAnimation setValue:transitionContext forKey:@"transitionContext"];
    [bigCircleLayer addAnimation:basicAnimation forKey:@"path"];
}

- (void)dismissTranslationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC {
    isPresent = false;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];

    CGFloat x = MAX(circleBtn.x, containerView.frame.size.width - circleBtn.x);
    CGFloat y = MAX(circleBtn.y, containerView.frame.size.height - circleBtn.y);
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    UIBezierPath *bigCirclePath = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];

    UIBezierPath *smallCirclePath = [UIBezierPath bezierPathWithOvalInRect:circleBtn.frame];

    CAShapeLayer *smallCircleLayer = [CAShapeLayer layer];
    smallCircleLayer.path = smallCirclePath.CGPath;

    fromVC.view.layer.mask = smallCircleLayer;

    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.fromValue = (__bridge id)bigCirclePath.CGPath;
    basicAnimation.toValue = (__bridge id)smallCirclePath.CGPath;
    basicAnimation.duration = 0.5;
    basicAnimation.delegate = self;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [basicAnimation setValue:transitionContext forKey:@"transitionContext"];
    [smallCircleLayer addAnimation:basicAnimation forKey:@"path"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    id<UIViewControllerContextTransitioning>transitionContext = [anim valueForKey:@"transitionContext"];
    if (isPresent) {
        [transitionContext completeTransition:YES];
    } else {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if (![transitionContext transitionWasCancelled]) {
                    [transitionContext viewControllerForKey:UITransitionContextFromViewKey].view.layer.mask = nil;
        }
    }
}

@end

