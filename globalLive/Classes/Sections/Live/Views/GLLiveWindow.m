//
//  GLLiveWindow.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/9.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "GLLiveWindow.h"

#define GLLiveWindowHeight self.frame.size.height
#define GLLiveWindowWidth self.frame.size.width

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
    NSLog(@"%@ dealloced", [self class]);
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

- (void)config
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(enterLiveRoomAction)];
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] init];
    [panGesture addTarget:self action:@selector(panGestureAction:)];
    [self addGestureRecognizer:panGesture];
}

- (void)configSubviews
{
    self.frame = CGRectMake(100, 100, 170, 100);
    [self addSubview:self.playView];
    [self addSubview:self.closeBtn];
    self.playView.backgroundColor = GLLiveViewColor;
    
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

- (void)quitLiveAction
{
    [[RYLiveManager sharedInstance] quitLive];
}

- (void)enterLiveRoomAction
{
    [[RYLiveManager sharedInstance] enterLive];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)p
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint panPoint = [p locationInView:window];

    if(p.state == UIGestureRecognizerStateBegan)
    {
        
    }
    if(p.state == UIGestureRecognizerStateChanged)
    {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        if(panPoint.x <= GL_SCREEN_WIDTH/2)
        {
            if(panPoint.y <= 40+GLLiveWindowHeight/2 && panPoint.x >= 20+GLLiveWindowWidth/2)
            {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(panPoint.x, GLLiveWindowHeight/2+25);
                }];
            }
            else if(panPoint.y >= GL_SCREEN_HEIGHT-GLLiveWindowHeight/2-40 && panPoint.x >= 20+GLLiveWindowWidth/2)
            {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(panPoint.x, GL_SCREEN_HEIGHT-GLLiveWindowHeight/2-25);
                }];
            }
            else if (panPoint.x < GLLiveWindowWidth/2+15 && panPoint.y > GL_SCREEN_HEIGHT-GLLiveWindowHeight/2)
            {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(GLLiveWindowWidth/2+25, GL_SCREEN_HEIGHT-GLLiveWindowHeight/2-25);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y < GLLiveWindowHeight/2 ? GLLiveWindowHeight/2 :panPoint.y;
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(GLLiveWindowWidth/2+25, pointy);
                }];
            }
        }
        else if(panPoint.x > GL_SCREEN_WIDTH/2)
        {
            if(panPoint.y <= 40+GLLiveWindowHeight/2 && panPoint.x < GL_SCREEN_WIDTH-GLLiveWindowWidth/2-20 )
            {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(panPoint.x, GLLiveWindowHeight/2 + 25);
                }];
            }
            else if(panPoint.y >= GL_SCREEN_HEIGHT-40-GLLiveWindowHeight/2 && panPoint.x < GL_SCREEN_WIDTH-GLLiveWindowWidth/2-20)
            {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(panPoint.x, GL_SCREEN_HEIGHT-GLLiveWindowHeight/2 - 25);
                }];
            }
            else if (panPoint.x > GL_SCREEN_WIDTH-GLLiveWindowWidth/2 - 15 && panPoint.y < GLLiveWindowHeight/2)
            {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(GL_SCREEN_WIDTH-GLLiveWindowWidth/2 - 25, GLLiveWindowHeight/2 + 25);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y > GL_SCREEN_HEIGHT-GLLiveWindowHeight/2 ? GL_SCREEN_HEIGHT-GLLiveWindowHeight/2 :panPoint.y;
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(GL_SCREEN_WIDTH-GLLiveWindowWidth/2 - 25, pointy);
                }];
            }
        }
    }

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
