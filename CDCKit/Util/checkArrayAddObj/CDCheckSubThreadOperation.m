//
//  CDCheckSubThreadOperation.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/10.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDCheckSubThreadOperation.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <os/lock.h>
#import <pthread/pthread.h>

static NSString *preSymbol;
static NSString *functionName;
static NSString *prefixName;

//找到调用add和remove等的selector，区分系统调用还是自己调用，如果是系统的不检测。
BOOL isUserFunctionWithSymbol(){
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    if (callStackSymbols.count < 4) {
        return NO;
    }
    //如果是上一个记录名直接返回yes
    NSString *symbols = [callStackSymbols objectAtIndex:3];
    if ([symbols isEqualToString:preSymbol]) {
        return YES;
    } else {
        NSRange markInstanceBegin = [symbols rangeOfString:@"-["];
        NSRange markClassBegin = [symbols rangeOfString:@"+["];
        NSRange markEnd = [symbols rangeOfString:@"]"];
        NSRange markBegin = markInstanceBegin.location == NSNotFound ? markClassBegin : markInstanceBegin;
        if (markEnd.location == NSNotFound || markBegin.location == NSNotFound) {
            return NO;
        }
        NSUInteger begin = markBegin.location + markBegin.length;
        NSString *tempFunctionName = [symbols substringWithRange:NSMakeRange(begin, markEnd.location - begin)];
        if ([tempFunctionName hasPrefix:prefixName]) {
            preSymbol = symbols;
            functionName = tempFunctionName;
            return YES;
        } else {
            return NO;
        }
    }
}

void ReplaceMethod(Class _originalClass, Class _newClass, SEL _originSelector, SEL _newSelector) {
    Method oriMethod = class_getInstanceMethod(_originalClass, _originSelector);
    Method newMethod = class_getInstanceMethod(_newClass, _newSelector);
    
    BOOL isAddedMethod = class_addMethod(_originalClass, _newSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (isAddedMethod) {
        Method original = class_getInstanceMethod(_originalClass, _newSelector);
        method_exchangeImplementations(oriMethod, original);
    }
}

static dispatch_semaphore_t lock;
API_AVAILABLE(ios(10.0)) static os_unfair_lock _osUnfairLock;

@interface CDCheckSubThreadOperation()<UIAlertViewDelegate>
@end

@implementation CDCheckSubThreadOperation

+ (void)checkArraySubThreadOpreationWithIdentifier:(NSString *)identifier {
#ifdef DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = dispatch_semaphore_create(1);
        if (@available(iOS 10.0, *)) {
            _osUnfairLock = OS_UNFAIR_LOCK_INIT;
        }
        prefixName = identifier;
        Class clz = NSClassFromString(@"__NSArrayM");
        Class newClz = [self class];
        SEL originAddSelector = @selector(addObject:);
        SEL replaceAddSelector = @selector(check_addObjc:);
        ReplaceMethod(clz, newClz, originAddSelector, replaceAddSelector);
        
        SEL originRemoveSelector = @selector(removeObject:);
        SEL replaceRemoveSelector = @selector(check_removeObjc:);
        ReplaceMethod(clz, newClz, originRemoveSelector, replaceRemoveSelector);
    });
#endif
}

- (void)check_addObjc:(id)anObj {
    if (@available(iOS 10.0, *)) {
        os_unfair_lock_lock(&_osUnfairLock);
        [self check_addObjc:anObj];
        [CDCheckSubThreadOperation logWithIndex:0];
        os_unfair_lock_unlock(&_osUnfairLock);
    } else {
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        [self check_addObjc:anObj];
        [CDCheckSubThreadOperation logWithIndex:0];
        dispatch_semaphore_signal(lock);
    }
}

- (void)check_removeObjc:(id)anObj {
    if (@available(iOS 10.0, *)) {
        os_unfair_lock_lock(&_osUnfairLock);
        [self check_removeObjc:anObj];
        [CDCheckSubThreadOperation logWithIndex:1];
        os_unfair_lock_unlock(&_osUnfairLock);
    } else {
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        [self check_removeObjc:anObj];
        [CDCheckSubThreadOperation logWithIndex:1];
        dispatch_semaphore_signal(lock);
    }
}

static bool isShowAlert = NO;
+ (void)logWithIndex:(NSInteger)index {
    if (isUserFunctionWithSymbol()) {
        if (![NSThread isMainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *log;
                switch (index) {
                    case 0:{
                        log = [NSString stringWithFormat:@"WARNING！！！子线程操作数组--添加操作，调用方法:%@",functionName];
                    }
                        break;
                    case 1:
                        log = [NSString stringWithFormat:@"WARNING！！！子线程操作数组--删除操作，调用方法:%@",functionName];
                        break;
                }
                NSLog(@"%@",log);
                if (!isShowAlert) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"warining!!!" message:log delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
                    [alert show];
                    isShowAlert = YES;
                }
            });
        }
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    isShowAlert = NO;
}

- (void)dealloc {}

@end
