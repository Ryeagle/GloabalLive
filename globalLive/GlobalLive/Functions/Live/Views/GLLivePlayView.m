//
//  GLLivePlayView.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/6.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "GLLivePlayView.h"
#import "GLPlayControlView.h"

@interface GLLivePlayView()<GLLiveControlDelegate>
@end;

@implementation GLLivePlayView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self configSubviews];
    }
    
    return self;
}

- (void)configSubviews
{
    self.backgroundColor = RYColorRGB(0x72c3fc);

    [self addSubview:self.previewView];
    [self addSubview:self.playControlView];
    
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.playControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - GLLiveControlDelegate

- (void)playControl:(id)playControl actionEvent:(NSString *)actionEvent
{
    if ([actionEvent isEqualToString:LiveControlBackAction]) {
        if (self.isFullSreen) {
            [self fullScreenAction];
        } else {
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            UIViewController *vc = [window ryGetCurrentViewController];
            [vc dismissViewControllerAnimated:YES completion:^{
                if (self) {
                    [self removeFromSuperview];
                }
            }];
        }
    } else if ([actionEvent isEqualToString:LiveControlFullScreenAction]) {
        [self fullScreenAction];
    }
    if (self.playViewDelegate && [self.playViewDelegate respondsToSelector:@selector(playControl:actionEvent:)]) {
        [self.playViewDelegate playControl:self actionEvent:actionEvent];
    }
}

#pragma mark - GLRotateViewDelegate

- (void)rotateView:(GLRotateView *)rotateView didFullScreenAction:(BOOL)isFullScreen
{
    if (isFullScreen) {
    } else {
    }
}


#pragma mark - Getter & Setter

- (UIView *)previewView
{
    if (!_previewView) {
        _previewView = [[UIView alloc] init];
        _previewView.backgroundColor = RYColorRGB(0x495057);
    }
    
    return _previewView;
}

- (GLPlayControlView *)playControlView
{
    if (!_playControlView) {
        _playControlView = [[GLPlayControlView alloc] init];
        _playControlView.liveControlDelegate = self;
    }
    
    return _playControlView;
}
@end
