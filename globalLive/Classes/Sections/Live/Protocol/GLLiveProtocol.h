//
//  GLLiveProtocol.h
//  globalLive
//
//  Created by Ryeagler on 2017/11/8.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#ifndef GLLiveProtocol_h
#define GLLiveProtocol_h

static NSString *const kLiveControlBackAction = @"LiveControlBackAction";
static NSString *const kLiveControlFullScreenAction = @"LiveControlFullScreenAction";


@protocol GLLiveControlDelegate <NSObject>
- (void)playControl:(id)playControl actionEvent:(NSString *)actionEvent;
@end


@class GLRotateView;
@protocol GLRotateViewDelegate
- (void)rotateView:(GLRotateView *)rotateView didFullScreenAction:(BOOL)isFullScreen;
@end

#endif /* GLLiveProtocol_h */
