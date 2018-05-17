//
//  CDDynamicView.h
//  CDCKit
//
//  Created by 车德超 on 2018/4/4.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDDynamicViewDelegate <NSObject>
- (UIScrollView *)firstScrollView;
- (UIScrollView *)secondScrollView;
@end

@interface CDDynamicView : UIView

@property (weak,nonatomic) id<CDDynamicViewDelegate> delegate;

@end
