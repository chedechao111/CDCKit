//
//  CDPushVC.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/11.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDVC1.h"
#import "CDVC2.h"
#import "CDNavTranslation.h"

@interface CDVC1 () <CDNavTranslationDelegate>

@end

@implementation CDVC1
{
    CDNavTranslation *_navTransLation;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _navTransLation = [[CDNavTranslation alloc] initWithDirection:InteractiveDirection_Right operation:InteractivePublicOperation_Push];
//        _navTransLation.delegate = self;
    }
    return self;
}

- (void)dealloc {
//    _navTransLation.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)pushVc {
    CDVC2 *vc2 = [[CDVC2 alloc] initWithNavTranslation:_navTransLation];
    self.navigationController.delegate = _navTransLation;
    [self.navigationController pushViewController:vc2 animated:YES];
}

#pragma mark - delegate
- (NSTimeInterval)durationTraslationAnimation {
    return 1;
}

- (void)translationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext withType:(UINavigationControllerOperation)opeartion {
    if (opeartion == UINavigationControllerOperationPush) {
        [self pushVCWithContext:transitionContext];
    } else {
        [self popVCWithContext:transitionContext];
    }
    
}

- (void)pushVCWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //对tempView做动画，避免bug;
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    tempView.frame = fromVC.view.frame;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    fromVC.view.hidden = YES;
    [containerView insertSubview:toVC.view atIndex:0];
    [tempView setAnchorPointTo:CGPointMake(0, 0.5)];
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -0.002;
    containerView.layer.sublayerTransform = transfrom3d;
    //增加阴影
    CAGradientLayer *fromGradient = [CAGradientLayer layer];
    fromGradient.frame = fromVC.view.bounds;
    fromGradient.colors = @[(id)[UIColor blackColor].CGColor,
                            (id)[UIColor blackColor].CGColor];
    fromGradient.startPoint = CGPointMake(0.0, 0.5);
    fromGradient.endPoint = CGPointMake(0.8, 0.5);
    UIView *fromShadow = [[UIView alloc]initWithFrame:fromVC.view.bounds];
    fromShadow.backgroundColor = [UIColor clearColor];
    [fromShadow.layer insertSublayer:fromGradient atIndex:1];
    fromShadow.alpha = 0.0;
    [tempView addSubview:fromShadow];
    CAGradientLayer *toGradient = [CAGradientLayer layer];
    toGradient.frame = fromVC.view.bounds;
    toGradient.colors = @[(id)[UIColor blackColor].CGColor,
                          (id)[UIColor blackColor].CGColor];
    toGradient.startPoint = CGPointMake(0.0, 0.5);
    toGradient.endPoint = CGPointMake(0.8, 0.5);
    UIView *toShadow = [[UIView alloc]initWithFrame:fromVC.view.bounds];
    toShadow.backgroundColor = [UIColor clearColor];
    [toShadow.layer insertSublayer:toGradient atIndex:1];
    toShadow.alpha = 1.0;
    [toVC.view addSubview:toShadow];
    [UIView animateWithDuration:1 animations:^{
        tempView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
        fromShadow.alpha = 1.0;
        toShadow.alpha = 0.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            [tempView removeFromSuperview];
            fromVC.view.hidden = NO;
        }
    }];
}

- (void)popVCWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    //拿到push时候的
    UIView *tempView = containerView.subviews.lastObject;
    [containerView addSubview:toVC.view];
    [UIView animateWithDuration:1 animations:^{
        tempView.layer.transform = CATransform3DIdentity;
        fromVC.view.subviews.lastObject.alpha = 1.0;
        tempView.subviews.lastObject.alpha = 0.0;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
            [tempView removeFromSuperview];
            toVC.view.hidden = NO;
        }
    }];
}
@end
