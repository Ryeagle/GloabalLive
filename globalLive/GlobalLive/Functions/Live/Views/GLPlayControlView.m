//
//  GLPlayControlView.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/6.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "GLPlayControlView.h"

@interface GLPlayControlView()
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, assign) BOOL subviewsIshidden;
@property (nonatomic, assign) BOOL isObserving;
@end

@implementation GLPlayControlView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.subviewsIshidden = NO;
        [self configSubviews];
        [self addObservers];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObservers];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isEqual:[RYLiveManager sharedInstance]]) {
        if ([keyPath isEqualToString:@"isFullScreen"]) {
            NSString *imageStr;
            imageStr = [RYLiveManager sharedInstance].isFullScreen ? @"live_back" : @"live_close";
            [self.backBtn  setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        }
    }
}


- (void)addObservers
{
    if (!self.isObserving) {
        [[RYLiveManager sharedInstance] addObserver:self forKeyPath:@"isFullScreen" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.isObserving = YES;
    }
}

- (void)removeObservers
{
    if (self.isObserving) {
        [[RYLiveManager sharedInstance] removeObserver:self forKeyPath:@"isFullScreen"];
    }
}

- (void)configSubviews
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
    self.clipsToBounds = YES;
    
    [self addSubview:self.backView];
    [self addSubview:self.backBtn];
    [self addSubview:self.fullScreenBtn];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.backBtn.contentEdgeInsets = UIEdgeInsetsMake(13, 13, 13, 13);
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self);
    }];
    
    self.fullScreenBtn.contentEdgeInsets = UIEdgeInsetsMake(18, 18, 18, 18);
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.bottom.equalTo(self);
    }];
}

#pragma mark -

- (void)showSubviews:(BOOL)show withAnimation:(BOOL)animate
{
    show ? [self _showSubviews:animate] : [self _hiddenSubviews:animate];
}

#pragma mark - Private Methods

- (void)_showSubviews:(BOOL)animate
{
    self.backBtn.hidden = NO;
    self.fullScreenBtn.hidden = NO;
    self.backView.hidden = NO;
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            self.backBtn.transform = CGAffineTransformIdentity;
            self.fullScreenBtn.transform = CGAffineTransformIdentity;
            [RYLiveManager sharedInstance].hiddenStatusBar = NO;
        } completion:^(BOOL finished) {
            self.subviewsIshidden = NO;
        }];
    } else {
        self.backBtn.transform = CGAffineTransformIdentity;
        self.fullScreenBtn.transform = CGAffineTransformIdentity;
        [RYLiveManager sharedInstance].hiddenStatusBar = NO;
        self.subviewsIshidden = NO;
    }
}

- (void)_hiddenSubviews:(BOOL)animate
{
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            self.backBtn.transform = CGAffineTransformMakeTranslation(0, -80);
            self.fullScreenBtn.transform = CGAffineTransformMakeTranslation(0, 80);
            self.backView.hidden = YES;
            [RYLiveManager sharedInstance].hiddenStatusBar = YES;
        } completion:^(BOOL finished) {
            self.backBtn.hidden = YES;
            self.fullScreenBtn.hidden = YES;
            self.subviewsIshidden = YES;
        }];
    } else {
        self.backBtn.transform = CGAffineTransformMakeTranslation(0, -80);
        self.fullScreenBtn.transform = CGAffineTransformMakeTranslation(0, 80);
        self.subviewsIshidden = YES;
        [RYLiveManager sharedInstance].hiddenStatusBar = YES;
    }
}

- (void)tapAction:(UIGestureRecognizer *)gesture
{
    if (self.subviewsIshidden) {
        [self showSubviews:YES withAnimation:YES];
    } else {
        [self showSubviews:NO withAnimation:YES];
    }
}

- (void)backAction
{
    if (self.liveControlDelegate && [self.liveControlDelegate respondsToSelector:@selector(playControl:actionEvent:)]) {
        [self.liveControlDelegate playControl:self actionEvent:LiveControlBackAction];
    }
}

- (void)fullScreenAction
{
    if (self.liveControlDelegate && [self.liveControlDelegate respondsToSelector:@selector(playControl:actionEvent:)]) {
        [self.liveControlDelegate playControl:self actionEvent:LiveControlFullScreenAction];
    }
}

#pragma mark - Getter & Setter

- (UIImageView *)backView
{
    if (!_backView) {
        _backView = [[UIImageView alloc] init];
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = RYColorRGB(0x000000);
        _backView.alpha = 0.5;
    }
    
    return _backView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backBtn;
}

- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [[UIButton alloc] init];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"live_fullscreen"] forState:UIControlStateNormal];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _fullScreenBtn;
}

@end
