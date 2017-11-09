//
//  RYLiveManager.h
//  globalLive
//
//  Created by Ryeagler on 2017/11/5.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYLiveManager : NSObject
RY_SINGLETON_DEF(RYLiveManager)
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) BOOL hiddenStatusBar;
@end
