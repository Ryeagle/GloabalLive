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

@interface RYLiveManager()<TXLivePlayListener, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) TXLivePlayer      *txPlayer;
@property (nonatomic, strong) TXLivePlayConfig  *txPlayConfig;
@property (nonatomic, strong) NSString *liveUrl;
@end

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

- (void)enterLiveWithId:(NSString *)liveId
{
    if (self.liveId && liveId != _liveId) {
        [self quitLive];
        [self enterLiveWithId:liveId];
    } else {
        self.liveId = liveId;
        [self enterLive];
    }
}

- (void)enterLive
{
    switch (self.livingStatus) {
        case GLLivingStatusNotLiving: {
            [self showLiveVCWithCompletion:nil];
        }
        break;
        case GLLivingStatusWindowLiving: {
            [self closeLiveWindow];
            [self showLiveVCWithCompletion:^{
                [self.liveVC configPlayer];
            }];
        }
        break;
            
        case GLLivingStatusVCLiving: {
            [self closeLiveVCWithCompletion:^{
                [self showLiveWindow];
            }];
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
        [self closeLiveVCWithCompletion:^{
        }];
        [self closeLiveWindow];
        [self resetManager];
    }
}

- (void)startRtmp
{
    self.liveUrl = [[GLLiveUrlConfig sharedInstance] getLiveUrlWithId:self.liveId];
    if (!self.liveUrl) {
        return;
    }
    if (!self.containerView) {
        self.containerView = [[UIView alloc] init];
    }
    
    if (!self.txPlayer) {
        self.txPlayConfig = [[TXLivePlayConfig alloc] init];
        self.txPlayConfig.bAutoAdjustCacheTime   = YES;
        self.txPlayConfig.minAutoAdjustCacheTime = 1;
        self.txPlayConfig.maxAutoAdjustCacheTime = 5;
        self.txPlayer = [[TXLivePlayer alloc] init];
        [self.txPlayer setRenderMode:RENDER_MODE_FILL_EDGE];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            self.txPlayer.enableHWAcceleration = YES;
        }
        
        [self.txPlayer removeVideoWidget];
        [self.txPlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:self.containerView insertIndex:0];
        [self.txPlayer setConfig:self.txPlayConfig];
        self.txPlayer.delegate = self;
        [self.txPlayer startPlay:self.liveUrl type:PLAY_TYPE_VOD_MP4];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}

- (void)stopRtmp
{
    if (self.txPlayer) {
        [self.txPlayer removeVideoWidget];
        [self.txPlayer stopPlay];
        self.txPlayConfig = nil;
        self.txPlayer.delegate = nil;
        self.txPlayer = nil;
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
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
    self.liveVCIsFromWindow = YES;
    if (!self.liveWindow) {
        self.liveWindow = [[GLLiveWindow alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window insertSubview:self.liveWindow atIndex:0];
        [window bringSubviewToFront:self.liveWindow];
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

- (void)showLiveVCWithCompletion:(void (^ __nullable)(void))completion
{
    self.livingStatus = GLLivingStatusVCLiving;
    [self closeLiveWindow];
    if (!self.liveVC) {
        self.liveVC = [[RYLiveViewController alloc] init];
        self.liveVC.transitioningDelegate = self;
    }
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *currentVC = [window ryGetCurrentViewController];
    [currentVC presentViewController:self.liveVC animated:YES completion:completion];
}

- (void)closeLiveVCWithCompletion:(void (^ __nullable)(void))completion
{
    if (self.liveVC) {
        [self.liveVC dismissViewControllerAnimated:YES completion:completion];
        self.liveVC.transitioningDelegate = nil;
        self.liveVC = nil;
    }
}

- (void)resetManager
{
    self.livingStatus = GLLivingStatusNotLiving;
    [self stopRtmp];
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
    self.liveId = nil;
    self.liveUrl = nil;
    self.liveVCIsFromWindow = NO;
}


#pragma mark - TXLivePlayListener

- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary*)param
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT) {
        } else if (EvtID == PLAY_WARNING_AUDIO_DECODE_FAIL || EvtID == PLAY_WARNING_VIDEO_DECODE_FAIL) {
        }
    });
}

- (void)onNetStatus:(NSDictionary *)param {
}


#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.liveVCIsFromWindow ? self : nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC =  [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] ;
    UIView *containerView = transitionContext.containerView;

    if (toVC.isBeingPresented) {
        UIView *windowView = (UIView *)[RYLiveManager sharedInstance].liveWindow;
        CGRect windowFrame = CGRectMake(windowView.frame.origin.x, windowView.frame.origin.y + 10, 160, 90);
        CGRect finalFrameForVC = CGRectMake(0, 0, RY_SCREEN_WIDTH, RY_SCREEN_WIDTH * 9 / 16);
        
        containerView.frame = [UIScreen mainScreen].bounds;
        [containerView addSubview:toVC.view];
        [containerView sendSubviewToBack:toVC.view];
        UIView *videoView = [[UIView alloc] initWithFrame:windowFrame];
        videoView.backgroundColor = RYColorRGB(0x495057);
        videoView.backgroundColor = RYColorRGB(0x2f9e44);
        [self setupVideoToFatherView:videoView];
        [containerView addSubview:videoView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGFloat scale =  RY_SCREEN_WIDTH / 160;
            videoView.transform = CGAffineTransformScale(videoView.transform, scale, scale);
            CGFloat tranlateX = (finalFrameForVC.origin.x - videoView.origin.x) / scale;
            CGFloat tranlateY = (finalFrameForVC.origin.y - videoView.origin.y) / scale;
            CGAffineTransform translateTransForm = CGAffineTransformTranslate(videoView.transform, tranlateX, tranlateY);
            videoView.transform = translateTransForm;
        } completion:^(BOOL finished) {
            [videoView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
    
    if (fromVC.isBeingDismissed) {
        UIView *windowView = (UIView *)[RYLiveManager sharedInstance].liveWindow;
        CGRect finalFrameForVC = [RYLiveManager sharedInstance].liveWindow ? CGRectMake(windowView.frame.origin.x, windowView.frame.origin.y + 10, 160, 90) : CGRectMake(100, 110, 160, 90);
        
        containerView.frame = [UIScreen mainScreen].bounds;
        [containerView addSubview:toVC.view];
        [containerView sendSubviewToBack:toVC.view];
        UIView *videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RY_SCREEN_WIDTH, RY_SCREEN_WIDTH * 9 / 16)];
        videoView.backgroundColor = RYColorRGB(0x495057);
        [self setupVideoToFatherView:videoView];
        [containerView addSubview:videoView];
        fromVC.view.alpha = 0;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGFloat scale = 160 / RY_SCREEN_WIDTH;
            videoView.transform = CGAffineTransformScale(videoView.transform, scale, scale);
            CGFloat tranlateX = (finalFrameForVC.origin.x - videoView.origin.x) / scale;
            CGFloat tranlateY = (finalFrameForVC.origin.y - videoView.origin.y) / scale;
            CGAffineTransform translateTransForm = CGAffineTransformTranslate(videoView.transform, tranlateX, tranlateY);
            videoView.transform = translateTransForm;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

#pragma mark - Getter & Setter

- (void)setHiddenStatusBar:(BOOL)hiddenStatusBar
{
    _hiddenStatusBar = hiddenStatusBar;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [[window ryGetCurrentViewController] setNeedsStatusBarAppearanceUpdate];
}

@end
