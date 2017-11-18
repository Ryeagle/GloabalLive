//
//  GLLiveUrlConfig.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/10.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "GLLiveUrlConfig.h"

@implementation GLLiveUrlConfig

GL_SINGLETON_IMP(GLLiveUrlConfig)


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"liveUrlConfig" ofType:@"plist"];
        _liveUrlDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    return self;
}


#pragma mark -

- (NSString *)getLiveUrlWithId:(NSString *)liveId
{
    return [self.liveUrlDict stringForKey:liveId withDefault:@""];
}
@end
