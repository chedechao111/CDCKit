//
//  NSArray+SafeArr.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/28.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "NSArray+SafeArr.h"

@implementation NSArray (SafeArr)

- (id)safelyAccessObjectAtIndex:(NSUInteger)index {
    
    id resultObject = nil;
    if (index >= self.count) {
        
    } else {
        resultObject = [self objectAtIndex:index];
    }
    
    return resultObject;
}

@end
