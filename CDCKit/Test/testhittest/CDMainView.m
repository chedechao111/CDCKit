//
//  CDMainView.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/25.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDMainView.h"
#import "CDAView.h"
#import "CDBView.h"

@implementation CDMainView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    NSLog(@"i'm main view, %@",view);
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUi];
    }
    return self;
}

- (void)createUi {
    CDAView *view1 = [[CDAView alloc] initWithFrame:CGRectMake(0, 100, self.width * .5, 200)];
    view1.backgroundColor = [UIColor redColor];
    [self addSubview:view1];
    
    CDBView *view2 = [[CDBView alloc] initWithFrame:CGRectMake(view1.right, 100, view1.width, view1.height)];
    view2.backgroundColor = [UIColor blueColor];
    [self addSubview:view2];
}

@end
