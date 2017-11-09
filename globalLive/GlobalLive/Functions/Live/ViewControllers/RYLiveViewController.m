//
//  RYLiveViewController.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/5.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "RYLiveViewController.h"
#import "GLLivePlayView.h"

@interface RYLiveViewController ()
@property (nonatomic, strong) UIView *liveContainerView;
@property (nonatomic, strong) GLLivePlayView *playView;
@end

@implementation RYLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
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

- (void)configSubviews
{
    self.view.backgroundColor = RYColorRGB(0xe9ecef);
    [self.view addSubview:self.liveContainerView];
    
    [self.liveContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RY_SCREEN_WIDTH, RY_SCREEN_WIDTH * 9 / 16));
        make.top.left.equalTo(self.view);
    }];
    
    self.playView = [[GLLivePlayView alloc] init];
    self.playView.fatherView = self.liveContainerView;
}


#pragma mark - Getter & Setter

- (UIView *)liveContainerView
{
    if (!_liveContainerView) {
        _liveContainerView = [[UIView alloc] init];
    }
    
    return _liveContainerView;
}

@end
