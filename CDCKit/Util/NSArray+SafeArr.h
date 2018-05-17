//
//  NSArray+SafeArr.h
//  CDCKit
//
//  Created by 车德超 on 2018/4/28.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SafeArr)

- (id)safelyAccessObjectAtIndex:(NSUInteger)index;

@end
