//
//  GLLiveUrlConfig.h
//  globalLive
//
//  Created by Ryeagler on 2017/11/10.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLLiveUrlConfig : NSObject
GL_SINGLETON_DEF(GLLiveUrlConfig)
@property (nonatomic, strong) NSDictionary *liveUrlDict;

- (NSString *)getLiveUrlWithId:(NSString *)liveId;
@end
