//
//  presentView.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/18.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "presentView.h"
#import <objc/runtime.h>

void exchangeMethod(Class originalClz, Class newClz, SEL originalSelector, SEL newSelector) {
    Method originalMethod = class_getInstanceMethod(originalClz, originalSelector);
    Method newMethod = class_getInstanceMethod(newClz, newSelector);
    bool isAdd = class_addMethod(originalClz, newSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (isAdd) {
        Method originalAddMethod = class_getInstanceMethod(originalClz, newSelector);
        method_exchangeImplementations(originalMethod, originalAddMethod);
    }
    
}

@implementation presentView

+ (void)changePresentMethod {
    exchangeMethod([UIViewController class], [self class], @selector(presentViewController:animated:completion:), @selector(cd_presentVC:animation:completion:));
}

- (void)cd_presentVC:(UIViewController *)vc animation:(BOOL)animation completion: (void (^ __nullable)(void))completion {
    [self cd_presentVC:vc animation:animation completion:completion];
}

@end
