//
//  GLMacro.h
//  globalLive
//
//  Created by Ryeagler on 2017/11/17.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#ifndef GLMacro_h
#define GLMacro_h

#import "GLColorMacro.h"

#undef GL_SINGLETON_DEF
#define GL_SINGLETON_DEF( __class ) \
+(__class *)sharedInstance;

#undef GL_SINGLETON_IMP
#define GL_SINGLETON_IMP( __class ) \
+ ( __class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
return __singleton__; \
}

#define GL_SCREEN_WIDTH     ([[UIScreen mainScreen]bounds].size.width)
#define GL_SCREEN_HEIGHT    ([[UIScreen mainScreen]bounds].size.height)


#define GLColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:((rgb & 0xff) / 255.0f) alpha:1.0f])
#define GLColorRGBA(rgb,a) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:((rgb & 0xff) / 255.0f) alpha:a])

#endif /* GLMacro_h */
