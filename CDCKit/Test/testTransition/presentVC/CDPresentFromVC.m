//
//  CDFromVC.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/10.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDPresentFromVC.h"
#import "CDPresentToVC.h"
#import "CDNavTranslation.h"

@interface CDPresentFromVC () <CDNavTranslationDelegate>

@end

@implementation CDPresentFromVC
{
    CDPresentToVC *toVc;
//    CDNavTranslation *translation;
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
   CDNavTranslation *translation = [CDNavTranslation translationWithDirection:InteractiveDirection_Up operation:InteractivePublicOperation_Persent fromVC:self toVC:[CDPresentToVC new]];
//    translation.delegate = self;
}

- (NSTimeInterval)durationTraslationAnimation {
    return 0.5;
}

- (void)translationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext withType:(InteractiveOperation)opeartion {
    if (opeartion == InteractiveOperation_Persent) {
        [self presentAnimationWithContext:transitionContext];
    } else {
        [self dismissAnimationWithContext:transitionContext];
    }
}


- (void)presentAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromTempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    fromTempView.tag = 0x200;
    fromVC.view.hidden = YES;
    fromTempView.frame = fromVC.view.frame;
    
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromTempView];
    [containerView addSubview:toVC.view];
    
    toVC.view.frame = CGRectMake(0, containerView.height, containerView.width, 400);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        toVC.view.transform = CGAffineTransformMakeTranslation(0, -400);
        fromTempView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        BOOL isTranslationFail = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!isTranslationFail];
        if (isTranslationFail) {
            fromVC.view.hidden = NO;
            [fromTempView removeFromSuperview];
        }
    }];
}

- (void)dismissAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIView *tempView = [containerView viewWithTag:0x200];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        fromVC.view.transform = CGAffineTransformIdentity;
        tempView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        BOOL isTranslationFail = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!isTranslationFail];
        if (!isTranslationFail) {
            toVC.view.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
    
}

- (void)dealloc {
    NSLog(@"dealloc");
}

@end
