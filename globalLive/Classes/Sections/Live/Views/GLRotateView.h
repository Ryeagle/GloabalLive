//
//  GLRotateView.h
//  globalLive
//
//  Created by Ryeagler on 2017/11/6.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLRotateView : UIView <GLRotateViewDelegate>
@property (nonatomic, assign) BOOL isFullSreen;
@property (nonatomic, assign) BOOL didEnterBackground;
@property (nonatomic, weak) UIView *fatherView;

- (void)addViewToFatherView:(UIView *)fatherView;
- (void)fullScreenAction;
@end
