	//
//  RYLiveManager.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/5.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "RYLiveManager.h"
#import "GLLiveWindow.h"
#import "RYLiveViewController.h"

@implementation RYLiveManager
RY_SINGLETON_IMP(RYLiveManager)

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.livingStatus = GLLivingStatusNotLiving;
    }
    
    return self;
}

#pragma mark -

- (void)enterLive
{
    switch (self.livingStatus) {
        case GLLivingStatusNotLiving: {
            [self showLiveVC];
        }
        break;
        case GLLivingStatusWindowLiving: {
            [self closeLiveWindow];
            [self showLiveVC];
        }
        break;
            
        case GLLivingStatusVCLiving: {
            [self closeLiveVC];
            [self showLiveWindow];
        }
        break;

        default:
            break;
    }
}

- (void)quitLive
{
    if (![GLUserDefaultManager sharedInstance].disableLiveInWindow
        && self.livingStatus == GLLivingStatusVCLiving) {
        [self enterLive];
    } else {
        [self closeLiveVC];
        [self closeLiveWindow];
        [self resetManager];
    }
}

- (void)startRtmp
{
    
}

- (void)stopRtmp
{
    
}


#pragma mark - Private Methods

- (void)setupVideoToFatherView:(UIView *)fatherView
{
    if (fatherView && self.containerView) {
        [self.containerView removeFromSuperview];
        [fatherView addSubview:self.containerView];
        [fatherView sendSubviewToBack:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
    }
}

- (void)showLiveWindow
{
    self.livingStatus = GLLivingStatusWindowLiving;
    if (!self.liveWindow) {
        self.liveWindow = [[GLLiveWindow alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window insertSubview:self.liveWindow atIndex:0];
    }
    [self.liveWindow showWindow];
    [self setupVideoToFatherView:self.liveWindow.playView];
}

- (void)closeLiveWindow
{
    if (self.liveWindow) {
        [self.liveWindow closeWindow];
    }
}

- (void)showLiveVC
{
    self.livingStatus = GLLivingStatusVCLiving;
    [self closeLiveWindow];
    if (!self.liveVC) {
        self.liveVC = [[RYLiveViewController alloc] init];
    }
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *currentVC = [window ryGetCurrentViewController];
    [currentVC presentViewController:self.liveVC animated:YES completion:nil];
}

- (void)closeLiveVC
{
    if (self.liveVC) {
        [self.liveVC dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)resetManager
{
    self.livingStatus = GLLivingStatusNotLiving;
    if (self.liveWindow) {
        [self.liveWindow removeFromSuperview];
        self.liveWindow = nil;
    }
    if (self.liveVC) {
        self.liveVC = nil;
    }
    if (self.containerView) {
        [self.containerView removeSubviews];
        [self.containerView removeFromSuperview];
        self.containerView = nil;
    }
    [self stopRtmp];
}

#pragma mark - Getter & Setter

- (void)setHiddenStatusBar:(BOOL)hiddenStatusBar
{
    _hiddenStatusBar = hiddenStatusBar;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [[window ryGetCurrentViewController] setNeedsStatusBarAppearanceUpdate];
}

@end
