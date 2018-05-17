//
//  CDNavTranslation.h
//  CDCKit
//
//  Created by 车德超 on 2018/4/11.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDDriverInteractiveTransLation.h"

@protocol CDNavTranslationDelegate <NSObject>

@required
- (NSTimeInterval)durationTraslationAnimation;

@optional
- (void)presentTranslationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC;
- (void)dismissTranslationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC;
- (void)pushTranslationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC;
- (void)popTranslationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC;

@end

typedef void(^animationBlock)(id<UIViewControllerContextTransitioning>transitionContext,UIViewController *fromVC,UIViewController *toVC);
typedef NSTimeInterval(^durationBlock)(void);

//动画，nav，present
@interface CDNavTranslation : NSObject <UIViewControllerAnimatedTransitioning,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) id<CDNavTranslationDelegate> delegate;

+ (instancetype)translationWithDirection:(InteractiveDirection)direction operation:(InteractivePublicOperation)operation fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC;

- (instancetype)initWithDirection:(InteractiveDirection)direction operation:(InteractivePublicOperation)operation fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC;

- (void)setFromVCGestureEnable:(BOOL)enable;
- (void)setToVCGestureEnable:(BOOL)enable;


@end
