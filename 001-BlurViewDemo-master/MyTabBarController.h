//
//  MyTabBarController.h
//  毛玻璃
//
//  Created by 米明 on 15/5/5.
//  Copyright (c) 2015年 米明. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenSize [UIScreen mainScreen].bounds.size
@interface MyTabBarController : UITabBarController
//背景
@property(nonatomic,retain)UIVisualEffectView * backgroundView;
//侧边栏
@property(nonatomic,retain)UIVisualEffectView * sideBar;
@end
