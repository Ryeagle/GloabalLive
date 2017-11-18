//
//  GLPlayControlView.h
//  globalLive
//
//  Created by Ryeagler on 2017/11/6.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLPlayControlView : UIView
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, weak) id<GLLiveControlDelegate> liveControlDelegate;

- (void)showSubviews:(BOOL)show withAnimation:(BOOL)animate;
@end
