//
//  GLLivePlayView.h
//  globalLive
//
//  Created by Ryeagler on 2017/11/6.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "GLRotateView.h"

@class GLPlayControlView;
@interface GLLivePlayView : GLRotateView
@property (nonatomic, strong) GLPlayControlView *playControlView;
@property (nonatomic, weak) id<GLLiveControlDelegate> playViewDelegate;

@end
