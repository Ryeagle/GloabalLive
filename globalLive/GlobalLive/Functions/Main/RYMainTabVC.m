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
    NSArray *vcs = @[@"RYFirstViewController,First", @"RYSecondViewController,Second", @"RYThirdViewController,Third"];
    NSMutableArray *viewControllers = [NSMutableArray array];
    [vcs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *configs = [obj componentsSeparatedByString:@","];
        if (configs.count == 2) {
            NSString *vcClassName = configs[0];
            NSString *tabbarTitle = configs[1];
            UIViewController *vc = [[NSClassFromString(vcClassName) alloc] init];
            vc.title = tabbarTitle;
            vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"tabbarTitle" image:nil selectedImage:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.view.backgroundColor = [UIColor whiteColor];
            [viewControllers addObject:nav];
        }
    }];
    
    self.viewControllers = viewControllers;
}

@end
