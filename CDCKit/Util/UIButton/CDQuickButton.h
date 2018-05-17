//
//  CDQuickButton.h
//  CDCKit
//
//  Created by 车德超 on 2018/4/10.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickedBlock)(id sender);
@interface CDQuickButton : UIButton
+ (CDQuickButton *)createBtnWithName:(NSString *)str WithBlock:(clickedBlock)block;
@end
