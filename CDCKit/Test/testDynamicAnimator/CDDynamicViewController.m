//
//  CDDynamicViewController.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/8.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDDynamicViewController.h"

@interface CDDynamicViewController () <UIDynamicAnimatorDelegate>

@end

@implementation CDDynamicViewController
{
    NSInteger _index;
    UIDynamicAnimator *_animator;
    UIView *_mainTestView;
}

- (instancetype)initWithIndex:(NSInteger)index {
    if (self = [super init]) {
        _index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _mainTestView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 40, 40)];
    _mainTestView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_mainTestView];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _animator.delegate = self;
    [self gravityDynamic];
}

//- (void)executeFunctionWithIndex:(NSInteger)index {
//    switch (index) {
//        case 0:{
//            [self ]
//        }
//        break;
//        default:
//            break;
//    }
//}

- (UIAttachmentBehavior *)attachDynamicView {
    [_animator removeAllBehaviors];
    UIAttachmentBehavior *attachBehavior = [[UIAttachmentBehavior alloc] initWithItem:_mainTestView attachedToAnchor:CGPointMake(200, 200)];
    attachBehavior.frequency = 2;
    attachBehavior.damping = 2;
    attachBehavior.length = 1;
    [_animator addBehavior:attachBehavior];
    return attachBehavior;
}

- (void)gravityDynamic {
    [_animator removeAllBehaviors];
    UIGravityBehavior *gravityBrhavior = [[UIGravityBehavior alloc] initWithItems:@[_mainTestView]];
    [_animator addBehavior:gravityBrhavior];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_mainTestView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:collisionBehavior];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    UIAttachmentBehavior *attachBehavior = [self attachDynamicView];
    attachBehavior.anchorPoint = loc;
}

@end
