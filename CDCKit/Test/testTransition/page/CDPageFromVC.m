//
//  CDPageFromVC.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/19.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDPageFromVC.h"
#import "CDNavTranslation.h"
#import "CDPageToVC.h"

@interface CDPageFromVC () <CDNavTranslationDelegate>

@end

@implementation CDPageFromVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    CDNavTranslation *translation = [CDNavTranslation translationWithDirection:InteractiveDirection_Left operation:InteractivePublicOperation_Push fromVC:self toVC:[CDPageToVC new]];
    translation.delegate = self;
}

- (NSTimeInterval)durationTraslationAnimation {
    return 1;
}

- (void)pushTranslationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC {
    
    
    UIView *containerView = [transitionContext containerView];
    UIView *tempFromView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempFromView];
    
    fromVC.view.hidden = YES;
    
    tempFromView.layer.anchorPoint = CGPointMake(0, 0.5);
    tempFromView.layer.position = CGPointMake(- containerView.width * .5, containerView.height * .5);
    
    CATransform3D transforn3D = CATransform3DIdentity;
    transforn3D.m34 = - 1/ 500;
    containerView.layer.sublayerTransform = transforn3D;
    
    [UIView animateWithDuration:1 animations:^{
        tempFromView.layer.transform = CATransform3DMakeRotation(- M_PI_2, 0, 1, 0);
        
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
            fromVC.view.hidden = NO;
        } else {
            [transitionContext completeTransition:YES];
        }
    }];
}

- (void)popTranslationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC {
    
}

@end
