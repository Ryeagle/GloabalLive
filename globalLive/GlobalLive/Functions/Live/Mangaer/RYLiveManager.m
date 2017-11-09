	//
//  RYLiveManager.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/5.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "RYLiveManager.h"

@implementation RYLiveManager
RY_SINGLETON_IMP(RYLiveManager)

- (void)setHiddenStatusBar:(BOOL)hiddenStatusBar
{
    _hiddenStatusBar = hiddenStatusBar;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [[window ryGetCurrentViewController] setNeedsStatusBarAppearanceUpdate];
}
@end
