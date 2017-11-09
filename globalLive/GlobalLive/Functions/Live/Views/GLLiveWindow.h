//
//  GLLiveWindow.h
//  globalLive
//
//  Created by Ryeagler on 2017/11/9.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLLiveWindow : UIView
@property (nonatomic, strong) UIView *playView;

- (void)showWindow;
- (void)closeWindow;
@end
