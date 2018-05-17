//
//  CDNavTranslation.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/11.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDNavTranslation.h"
#import "CDDriverInteractiveTransLation.h"
#import <objc/runtime.h>

static int const pushGestureId = 0x200;
static int const popGestureId = 0x300;
static char *const kNavTranslationAssociatedSymbol = "kNavTranslationAssociatedSymbol";

@implementation CDNavTranslation
{
    CDDriverInteractiveTransLation *_pushInteractive; // present
    CDDriverInteractiveTransLation *_popInteractive; //dismiss
    InteractiveOperation _navOperation;
    InteractiveOperation _presentOperation;
    InteractivePublicOperation _opreation;
    __weak UIViewController *_fromVC;
    UIViewController *_toVC;
    UIPanGestureRecognizer *_fromVCPan;
    UIPanGestureRecognizer *_toVCPan;
}

#pragma mark - public interface

+ (instancetype)translationWithDirection:(InteractiveDirection)direction operation:(InteractivePublicOperation)operation fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC {
    if (!fromVC) return nil;
    CDNavTranslation *navTranslation = objc_getAssociatedObject(fromVC, kNavTranslationAssociatedSymbol);
    if (!navTranslation) {
        navTranslation = [[CDNavTranslation alloc] initWithDirection:direction operation:operation fromVC:fromVC toVC:toVC];
    }
    objc_setAssociatedObject(fromVC, kNavTranslationAssociatedSymbol, navTranslation, OBJC_ASSOCIATION_RETAIN);
    return navTranslation;
}

- (instancetype)initWithDirection:(InteractiveDirection)direction operation:(InteractivePublicOperation)operation fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC {
    if (self = [super init]) {
        _fromVC = fromVC;
        _toVC = toVC;
        _opreation = operation;
        if (operation == InteractivePublicOperation_Persent) {
            _toVC.transitioningDelegate = self;
            _toVC.modalPresentationStyle = UIModalPresentationCustom;
        }
        if (operation == InteractivePublicOperation_Push) {
            _fromVC.navigationController.delegate = self;
        }
        _navOperation = InteractiveOperation_None;
        _presentOperation = InteractiveOperation_None;
        if (direction != InteractiveDirection_None) {
            [self addDrivenInteractiveTranslationWithDirection:direction operation:operation];
            [self addPushPanGestureWithVC:_fromVC];
        }
        [self setDrivenPushBlock];
    }
    return self;
}

- (void)dealloc {
    _toVC.transitioningDelegate = nil;
    _fromVC.navigationController.delegate = nil;
    objc_setAssociatedObject(_fromVC, kNavTranslationAssociatedSymbol, nil, OBJC_ASSOCIATION_RETAIN);
    NSLog(@"-=-=-dealloc");
}

- (void)addDrivenInteractiveTranslationWithDirection:(InteractiveDirection)direction operation:(InteractivePublicOperation)operation {
    
        _pushInteractive = [CDDriverInteractiveTransLation interactiveTraslationWithDirection:direction operation:[self changePublicOperation:operation isRevert:NO]];
        _popInteractive = [CDDriverInteractiveTransLation interactiveTraslationWithDirection:[self turnDirection:direction] operation:[self changePublicOperation:operation isRevert:YES]];
}

#pragma mark - transfer

- (InteractiveOperation)changePublicOperation:(InteractivePublicOperation)opreation isRevert:(BOOL)isRevert{
    switch (opreation) {
        case InteractivePublicOperation_Push:
            return isRevert ? InteractiveOperation_Pop: InteractiveOperation_Push;
            break;
        case InteractivePublicOperation_Persent:
            return isRevert ? InteractiveOperation_Dismiss : InteractiveOperation_Persent;
            break;
        default:
            break;
    }
}

- (InteractiveDirection)turnDirection:(InteractiveDirection)direction {
    switch (direction) {
        case InteractiveDirection_Up:
            return InteractiveDirection_Down;
        case InteractiveDirection_Down:
            return InteractiveDirection_Up;
        case InteractiveDirection_Right:
            return InteractiveDirection_Left;
        case InteractiveDirection_Left:
            return InteractiveDirection_Right;
        default:
            return InteractiveDirection_None;
    }
}

#pragma mark - push pop block

- (void)setDrivenPushBlock { //present
    weakOf(self);
    _pushInteractive.pushBlock = ^{
        strongOf(self);
        if (!self->_fromVC || !self->_toVC) {
            return;
        }
        if (self->_opreation == InteractivePublicOperation_Persent) {
            [self->_fromVC presentViewController:self->_toVC animated:YES completion:nil];
        } else if(self->_opreation == InteractivePublicOperation_Push) {
            [self->_fromVC.navigationController pushViewController:self->_toVC animated:YES];
        }
    };
}

- (void)addPushPanGestureWithVC:(UIViewController *)vc {
    if (vc.view.tag != pushGestureId && vc) {
        vc.view.tag = pushGestureId;
        _fromVCPan = [_pushInteractive addPanGestureWithVC:vc];
    }
}

- (void)addPopPanGestureWithVC:(UIViewController *)vc {
    if (vc.view.tag != popGestureId) {
        vc.view.tag = popGestureId;
       _toVCPan = [_popInteractive addPanGestureWithVC:vc];
    }
}

- (void)setFromVCGestureEnable:(BOOL)enable {
    _fromVCPan.enabled = enable;
}

- (void)setToVCGestureEnable:(BOOL)enable {
    _toVCPan.enabled = enable;
}

#pragma mark - delegate
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return [_delegate durationTraslationAnimation];
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    InteractiveOperation operation = _navOperation != InteractiveOperation_None ? _navOperation : _presentOperation != InteractiveOperation_None ? _presentOperation : InteractiveOperation_None;
    UIViewController *fromVc;
    UIViewController *toVc;
    if (operation != InteractiveOperation_None) {
        fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    switch (operation) {
        case InteractiveOperation_Push:
            [_delegate pushTranslationAnimation:transitionContext fromVC:fromVc toVC:toVc];
            break;
        case InteractiveOperation_Pop:
            [_delegate popTranslationAnimation:transitionContext fromVC:fromVc toVC:toVc];
            break;
        case InteractiveOperation_Persent:
            [_delegate presentTranslationAnimation:transitionContext fromVC:fromVc toVC:toVc];
            break;
        case InteractiveOperation_Dismiss:
            [_delegate dismissTranslationAnimation:transitionContext fromVC:fromVc toVC:toVc];
            break;
        default:
            break;
    }
}



#pragma mark - navgationDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    [self transferNavOperation:operation];
    [self addPopPanGestureWithVC:toVC];
    return self;
}

- (void)transferNavOperation:(UINavigationControllerOperation)navOp {
    switch (navOp) {
        case UINavigationControllerOperationPop:
            _navOperation = InteractiveOperation_Pop;
            break;
        case UINavigationControllerOperationPush:
            _navOperation = InteractiveOperation_Push;
            break;
        default:
            _navOperation = InteractiveOperation_None;
            break;
    }
}

//gesture
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (_navOperation == InteractiveOperation_Push) {
        return !_pushInteractive.isInteractive ? _pushInteractive : nil;
    } else if(_navOperation == InteractiveOperation_Pop) {
        return !_popInteractive.isInteractive ? _popInteractive : nil;
    } else {
        return nil;
    }
}

#pragma mark - presentDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _presentOperation = InteractiveOperation_Persent;
    [self addPopPanGestureWithVC:presented];
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _presentOperation = InteractiveOperation_Dismiss;
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return _pushInteractive.isInteractive ? _pushInteractive : nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return  _popInteractive.isInteractive ? _popInteractive : nil;
}

@end
