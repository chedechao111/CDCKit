//
//  UILabel+cutTextInMaxWidth.m
//  WM_Category_Lib
//
//  Created by 车德超 on 2018/5/9.
//  Copyright © 2018年 leigang. All rights reserved.
//

#import "UILabel+cutTextInMaxWidth.h"
#import "UIView+Additions.h"
//
//@implementation UILabel (cutTextInMaxWidth)
//
//-(void)cutLabelWithMaxWidth:(CGFloat)maxWidth {
//    NSString *str = [NSString stringWithString:self.text];
//    UIFont *font = self.font;
//    CGFloat strWidth = [str sizeWithMaxWidth:MAXFLOAT font:font].width;
//    if (strWidth <= maxWidth) {
//        self.width = strWidth;
//        return;
//    }
//    __block CGFloat markX = 0;
//    __block NSUInteger i = 0;
//    __block CGFloat characterW = 0;
//    [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
//        @autoreleasepool {
//            characterW = [substring sizeWithMaxWidth:MAXFLOAT font:font].width;
//            markX += characterW;
//            i++;
//            if (markX > maxWidth) {
//                --i;
//                markX -= characterW;
//                *stop = YES;
//            }
//        }
//    }];
//    self.text = [str substringWithRange:NSMakeRange(0, i)];
//    self.width = markX;
//}
//
//@end
