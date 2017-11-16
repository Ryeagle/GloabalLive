//
//  RYLiveManager.h
//  globalLive
//
//  Created by Ryeagler on 2017/11/5.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GLLiveWindow, RYLiveViewController;
@interface RYLiveManager : NSObject
RY_SINGLETON_DEF(RYLiveManager)

typedef NS_ENUM(NSInteger, GLLivingStatus) {
    GLLivingStatusNotLiving = 0,
    GLLivingStatusWindowLiving = 1,
    GLLivingStatusVCLiving = 2
};

@property (nonatomic, strong) NSString *liveId;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) BOOL hiddenStatusBar;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) GLLivingStatus livingStatus;
@property (nonatomic, assign) BOOL liveVCIsFromWindow;


@property (nonatomic, strong) GLLiveWindow *liveWindow;
@property (nonatomic, strong) RYLiveViewController *liveVC;

- (void)setupVideoToFatherView:(UIView *)fatherView;
- (void)enterLiveWithId:(NSString *)liveId;
- (void)enterLive;
- (void)quitLive;
- (void)startRtmp;
- (void)stopRtmp;

@end
