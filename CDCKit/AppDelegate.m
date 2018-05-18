//
//  AppDelegate.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/3.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "AppDelegate.h"
#import "CDMainViewController.h"
#import "CDTableViewController.h"
#import "CDCheckSubThreadOperation.h"
#import "CDCircleFromController.h"
#import "presentView.h"
#import "ASTestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    CDTableViewController *mainVC = [CDTableViewController new];
//    CDCircleFromController *mainVC = [CDCircleFromController new];
//    CDMainViewController *mainVC = [CDMainViewController new];
    ASTestViewController *mainVC = [ASTestViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [presentView changePresentMethod];
    return YES;
}
@end
