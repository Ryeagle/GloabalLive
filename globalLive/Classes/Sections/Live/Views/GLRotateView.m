//
//  GLRotateView.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/6.
//  Reference:https://github.com/renzifeng/ZFPlayer
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "GLRotateView.h"

@implementation GLRotateView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self addNotifications];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void)fullScreenAction
{
    if (self.isFullSreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        self.isFullSreen = NO;
    } else {
        UIDeviceOrientation orientaion = [UIDevice currentDevice].orientation;
        if (orientaion == UIDeviceOrientationLandscapeRight) {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
        self.isFullSreen = YES;
    }
}

- (void)addViewToFatherView:(UIView *)fatherView
{
    if (fatherView) {
        [self removeFromSuperview];
        [fatherView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(fatherView);
        }];
    }
}

#pragma mark - Private Method

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackGround) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)appDidEnterBackGround
{
    self.didEnterBackground = NO;
}

- (void)appDidEnterPlayGround
{
    self.didEnterBackground = YES;
}

- (void)onStatusBarOrientationChange
{
    if (self.didEnterBackground) {
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self setOrientationPortraitConstraint];
        } else {
            if (currentOrientation == UIInterfaceOrientationLandscapeRight) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            } else {
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
        }
    }
}

#pragma mark - Screen Rotate Method
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        [self setOrientationLandscapeConstraint:orientation];
    } else if (orientation == UIInterfaceOrientationPortrait) {
        [self setOrientationPortraitConstraint];
    }
}

- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation
{
    [self toOrientation:orientation];
    self.isFullSreen = YES;
}

- (void)setOrientationPortraitConstraint
{
    [self addViewToFatherView:self.fatherView];
    [self toOrientation:UIInterfaceOrientationPortrait];
    self.isFullSreen = NO;
}

- (void)toOrientation:(UIInterfaceOrientation)orientation
{
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == orientation) { return; }

    if (orientation != UIInterfaceOrientationPortrait) {
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self removeFromSuperview];
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
                make.size.mas_equalTo(CGSizeMake(GL_SCREEN_HEIGHT, GL_SCREEN_WIDTH));
            }];
        }
    }

    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];

    self.transform = CGAffineTransformIdentity;
    self.transform = [self getTransformRotationAngle];

    [UIView commitAnimations];
}

- (CGAffineTransform)getTransformRotationAngle
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI_2);
    }

    return CGAffineTransformIdentity;

}

#pragma mark - GLRotateViewDelegate

- (void)rotateView:(GLRotateView *)rotateView didFullScreenAction:(BOOL)isFullScreen{}

#pragma mark - Getter & Setter

- (void)setIsFullSreen:(BOOL)isFullSreen
{
    _isFullSreen = isFullSreen;
    [RYLiveManager sharedInstance].isFullScreen = isFullSreen;
    if ([self respondsToSelector:@selector(rotateView:didFullScreenAction:)]) {
        [self rotateView:self didFullScreenAction:isFullSreen];
    }
}

- (void)setFatherView:(UIView *)fatherView
{
    _fatherView = fatherView;
    [self addViewToFatherView:_fatherView];
}

@end
