//
//  GLUserDefaultManager.h
//  globalLive
//
//  Created by Ryeagler on 2017/11/5.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "RYUserDefaultManager.h"

@interface GLUserDefaultManager : RYUserDefaultManager
RY_SINGLETON_DEF(GLUserDefaultManager)

@property (nonatomic, assign) BOOL disableLiveInWindow;

@end
