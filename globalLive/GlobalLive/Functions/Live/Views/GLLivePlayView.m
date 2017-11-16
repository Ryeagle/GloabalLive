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
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
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
    [self addSubview:self.playControlView];
    
    [self.playControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - GLLiveControlDelegate

- (void)playControl:(id)playControl actionEvent:(NSString *)actionEvent
{
    if ([actionEvent isEqualToString:kLiveControlBackAction]) {
        if (self.isFullSreen) {
            [self fullScreenAction];
        } else {
            if (self.playViewDelegate && [self.playViewDelegate respondsToSelector:@selector(playControl:actionEvent:)]) {
                [self.playViewDelegate playControl:self actionEvent:actionEvent];
            }
        }
    } else if ([actionEvent isEqualToString:kLiveControlFullScreenAction]) {
        [self fullScreenAction];
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

- (GLPlayControlView *)playControlView
{
    if (!_playControlView) {
        _playControlView = [[GLPlayControlView alloc] init];
        _playControlView.liveControlDelegate = self;
    }
    
    return _playControlView;
}
@end
