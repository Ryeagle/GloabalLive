//
//  RYLiveViewController.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/5.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "RYLiveViewController.h"
#import "GLLivePlayView.h"

@interface RYLiveViewController ()<GLLiveControlDelegate>
@property (nonatomic, strong) UIView *liveContainerView;
@property (nonatomic, strong) GLLivePlayView *playView;
@end

@implementation RYLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self configSubviews];
    [self configPlayer];
}

- (void)dealloc
{
    NSLog(@"%@ dealloced", [self class]);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return [RYLiveManager sharedInstance].hiddenStatusBar;
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - Private Method

- (void)config
{
}

- (void)configSubviews
{
    self.view.backgroundColor = RYColorRGB(0xe9ecef);
    [self.view addSubview:self.liveContainerView];
    
    [self.liveContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RY_SCREEN_WIDTH, RY_SCREEN_WIDTH * 9 / 16));
        make.top.left.equalTo(self.view);
    }];
    
    self.playView.fatherView = self.liveContainerView;
}

- (void)configPlayer
{
    if (![RYLiveManager sharedInstance].liveVCIsFromWindow) {
        [[RYLiveManager sharedInstance] startRtmp];
    }
    [[RYLiveManager sharedInstance] setupVideoToFatherView:self.playView];
}

#pragma mark - GLLiveControlDelegate

- (void)playControl:(id)playControl actionEvent:(NSString *)actionEvent
{
    if ([actionEvent isEqualToString:kLiveControlBackAction]) {
        if (![RYLiveManager sharedInstance].isFullScreen) {
            [[RYLiveManager sharedInstance] quitLive];
        }
    }
}

#pragma mark - Getter & Setter

- (UIView *)liveContainerView
{
    if (!_liveContainerView) {
        _liveContainerView = [[UIView alloc] init];
    }
    
    return _liveContainerView;
}

- (GLLivePlayView *)playView
{
    if (!_playView) {
        _playView = [[GLLivePlayView alloc] init];
        _playView.playViewDelegate = self;
        _playView.backgroundColor = RYColorRGB(0x495057);
    }
    return _playView;
}
@end
