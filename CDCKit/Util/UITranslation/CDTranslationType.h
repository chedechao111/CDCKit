//
//  CDTranslationType.h
//  CDCKit
//
//  Created by 车德超 on 2018/4/11.
//  Copyright © 2018年 车德超. All rights reserved.
//

#ifndef CDTranslationType_h
#define CDTranslationType_h

typedef NS_ENUM(NSUInteger, InteractiveDirection) {
    InteractiveDirection_Left,
    InteractiveDirection_Right,
    InteractiveDirection_Up,
    InteractiveDirection_Down,
    InteractiveDirection_None,
};

typedef NS_ENUM(NSUInteger, InteractivePublicOperation) {
    InteractivePublicOperation_Push,
    InteractivePublicOperation_Persent,
};

#endif /* CDTranslationType_h */
