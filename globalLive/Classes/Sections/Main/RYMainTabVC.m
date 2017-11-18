//
//  RYMainTabVC.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/5.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "RYMainTabVC.h"

@interface RYMainTabVC ()

@end

@implementation RYMainTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configTabVCs];
}

- (void)configTabVCs
{
    //@"vcClassName, tabBarTitle, tabbarImage"
    NSArray *vcs = @[@"RYFirstViewController,Live,home,home_sel", @"RYAccountViewController,Account,account,account_sel"];
    NSMutableArray *viewControllers = [NSMutableArray array];
    [vcs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *configs = [obj componentsSeparatedByString:@","];
        if (configs.count == 4) {
            NSString *vcClassName = configs[0];
            NSString *tabbarTitle = configs[1];
            NSString *tabbarImage = configs[2];
            NSString *tabbarImageSelect = configs[3];
            UIViewController *vc = [[NSClassFromString(vcClassName) alloc] init];
            vc.title = tabbarTitle;
            vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabbarTitle image:[UIImage imageNamed:tabbarImage] selectedImage:[UIImage imageNamed:tabbarImageSelect]];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.view.backgroundColor = GLAppBgColor;
            NSDictionary *titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
            nav.navigationBar.titleTextAttributes = titleTextAttributes;
            [nav.navigationBar setBarTintColor:GLNavColor];
            [viewControllers addObject:nav];
        }
    }];
    
    self.viewControllers = viewControllers;
    
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = GLTabBarColor;
    self.tabBar.translucent = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
