//
//  UIWindow+GlobalLive.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/17.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "UIWindow+GlobalLive.h"

@implementation UIWindow (GlobalLive)

- (UIViewController *)glGetCurrentViewController
{
    UIViewController *topVC = [self rootViewController];
    while (true) {
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        } else if ([topVC isKindOfClass:[UINavigationController class]] && [(UINavigationController *)topVC topViewController]) {
            topVC = [(UINavigationController *)topVC topViewController];
        } else if ([topVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabVC = (UITabBarController *)topVC;
            topVC = tabVC.selectedViewController;
        } else {
            break;
        }
    }
    return topVC;
}

@end
