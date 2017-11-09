//
//  GLLiveWindow.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/9.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "GLLiveWindow.h"

@interface GLLiveWindow()
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation GLLiveWindow

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self config];
        [self configSubviews];
    }
    
    return self;
}

- (void)dealloc
{
}

#pragma mark -

- (void)showWindow
{
    self.hidden = NO;
}

- (void)closeWindow
{
    self.hidden = YES;
}

#pragma mark - Private Method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
}

- (void)config
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(enterLiveRoomAction)];
    [self addGestureRecognizer:tapGesture];
}

- (void)configSubviews
{
    self.frame = CGRectMake(100, 100, 170, 100);
    [self addSubview:self.playView];
    [self addSubview:self.closeBtn];
    self.playView.backgroundColor = RYColorRGB(0x72c3fc);
    
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(20));
        make.top.equalTo(self);
        make.right.equalTo(self);
    }];
}

- (void)addLiveModelObserver
{
}

- (void)quitLiveAction
{
    [[RYLiveManager sharedInstance] quitLive];
}

- (void)enterLiveRoomAction
{
    [[RYLiveManager sharedInstance] enterLive];
}

#pragma mark - Getter & Setter

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"lvie_window_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(quitLiveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeBtn;
}

- (UIView *)playView
{
    if (!_playView) {
        _playView = [[UIView alloc] init];
    }
    
    return _playView;
}

@end
