//
//  CDDriverInteractiveTransLation.h
//  CDCKit
//
//  Created by 车德超 on 2018/4/10.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDTranslationType.h"

typedef NS_ENUM(NSUInteger, InteractiveOperation) {
    InteractiveOperation_None,
    InteractiveOperation_Push,
    InteractiveOperation_Pop,
    InteractiveOperation_Persent,
    InteractiveOperation_Dismiss,
};

typedef void(^doBlock)(void);

@interface CDDriverInteractiveTransLation : UIPercentDrivenInteractiveTransition

@property (assign, nonatomic) BOOL isInteractive;
@property (copy, nonatomic) doBlock pushBlock;
+ (instancetype)interactiveTraslationWithDirection:(InteractiveDirection)direction operation:(InteractiveOperation)operation;
- (UIPanGestureRecognizer *)addPanGestureWithVC:(UIViewController *)vc;

@end
