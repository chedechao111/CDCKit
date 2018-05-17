//
//  CDDynamicView.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/4.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDDynamicView.h"

@interface CDDynamicItem : NSObject<UIDynamicItem>

@property (nonatomic, readwrite) CGPoint center;
@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readwrite) CGAffineTransform transform;

@end

@implementation CDDynamicItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        _bounds = CGRectMake(0, 0, 1, 1);
    }
    return self;
}
@end

@interface CDDynamicView() <UIGestureRecognizerDelegate, UIDynamicAnimatorDelegate>

@end

@implementation CDDynamicView
{
    UIPanGestureRecognizer *_pan;
    UIScrollView *_firstScrollView;
    UIScrollView *_secondScrollView;
    CGFloat _lastCurrentOffsetY;
    CGFloat _lastCurrentY;
    CGFloat _lastTranslation;
    CGFloat _CurrentY;
    UIDynamicAnimator *_animator;
}

- (UIScrollView *)getFirstScroll {
    if ([_delegate respondsToSelector:@selector(firstScrollView)]) {
        return [_delegate firstScrollView];
    }
    return nil;
}

- (UIScrollView *)getSecondScroll {
    if ([_delegate respondsToSelector:@selector(secondScrollView)]) {
        return [_delegate secondScrollView];
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addPanGesture];
    }
    return self;
}

- (void)dealloc {
    _pan.delegate = nil;
}

- (void)addPanGesture {
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    _pan.delegate = self;
    _CurrentY = 100;
    [self addGestureRecognizer:_pan];
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    _animator.delegate = self;
}

- (void)panAction:(id)sender {
    UIGestureRecognizerState state = _pan.state;
    _firstScrollView = [self getFirstScroll];
    _secondScrollView = [self getSecondScroll];
    CGFloat translation = [_pan translationInView:self].y;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            _lastTranslation = 0;
            [_animator removeAllBehaviors];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            
            CGFloat translationY = translation - _lastTranslation;
            _CurrentY += translationY;
            CGFloat secondContentOffsetY = _secondScrollView.contentOffset.y - translationY;
            if (_CurrentY > 100) {
                _secondScrollView.frame = CGRectMake(0, _CurrentY, self.frame.size.width, self.frame.size.height);
            } else{
                if (secondContentOffsetY > 0) {
                    [_secondScrollView setContentOffset:CGPointMake(00, secondContentOffsetY)];
                    _CurrentY = 100;
                    _secondScrollView.frame = CGRectMake(0, _CurrentY, self.frame.size.width, self.frame.size.height);
                } else {
                    _secondScrollView.frame = CGRectMake(0, _CurrentY, self.frame.size.width, self.frame.size.height);
                }
            }
            _lastTranslation = translation;
            _lastCurrentY = _CurrentY;
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            if(_secondScrollView.contentOffset.y > 0 && _secondScrollView.frame.origin.y <= 100){
                CGFloat velocityY = [_pan velocityInView:self].y;
                [self translation:_secondScrollView.contentOffset.y velocity:velocityY];
            }
            break;
        }
        default:
            break;
    }
}

- (void)translation:(CGFloat)translation velocity:(CGFloat)velocity {
    CDDynamicItem *item = [CDDynamicItem new];
    item.center = CGPointMake(0, -translation);
    UIDynamicItemBehavior *behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[item]];
    [behavior addLinearVelocity:CGPointMake(0, velocity) forItem:item];
    behavior.resistance = 2.0f;
    behavior.action = ^{
        [_secondScrollView setContentOffset:CGPointMake(0, -item.center.y) animated:NO];
    };
    [_animator addBehavior:behavior];
}

@end
