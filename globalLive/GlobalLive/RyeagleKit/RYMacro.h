//
//  RYMacro.h
//  globalLive
//
//  Created by Ryeagler on 2017/11/5.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#ifndef RYMacro_h
#define RYMacro_h

#undef RY_SINGLETON_DEF
#define RY_SINGLETON_DEF( __class ) \
+(__class *)sharedInstance;

#undef RY_SINGLETON_IMP
#define RY_SINGLETON_IMP( __class ) \
+ ( __class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
return __singleton__; \
}

#define RY_SCREEN_WIDTH     ([[UIScreen mainScreen]bounds].size.width)
#define RY_SCREEN_HEIGHT    ([[UIScreen mainScreen]bounds].size.height)


#define RYColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:((rgb & 0xff) / 255.0f) alpha:1.0f])
#define RYColorRGBA(rgb,a) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:((rgb & 0xff) / 255.0f) alpha:a])

#endif /* RYMacro_h */
