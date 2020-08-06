//
//  AppDelegate.m
//  3DTouchTest
//
//  Created by LvYuan on 16/7/19.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "AppDelegate.h"
#import "ShowViewController.h"
#import "Macro.h"


@interface AppDelegate ()
@property (nonatomic,retain)UINavigationController * rootVC;
@end

@implementation AppDelegate

/**
 *  窗口
 */
- (UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_window makeKeyAndVisible];
    }
    return _window;
}
/**
 *  根视图控制器
 */
- (UINavigationController *)rootVC{
    if (!_rootVC) {
        _rootVC = [[UINavigationController alloc]initWithRootViewController:ControllerForSBId(kHomeSBId)];
    }
    return _rootVC;
}

/**
 *  启动时调用的
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.rootViewController = self.rootVC;
    
    //代码方式动态添加Item
    [self codeAddItems];
    
    //如果是从快捷选项标签启动app，则根据不同标识执行不同操作，然后返回NO
    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    
    if (shortcutItem) {
        [self showForItem:shortcutItem];
        return NO;
    }
    
    return YES;
}
- (void)showForItem:(UIApplicationShortcutItem *)shortcutItem{

    ShowViewController * svc = (ShowViewController *)ControllerForSBId(kShowVCId);
    
    svc.text = shortcutItem.type;
    svc.title = shortcutItem.localizedTitle;
    svc.view.backgroundColor = [UIColor grayColor];
    
    [[self rootVC] showViewController:svc sender:nil];
}

/*
 
 如果app在后台，通过快捷选项标签进入app，则调用该方法，如果app已死，则处理通过快捷选项标签进入app的逻辑在
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions中

 */

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {

    //判断先前我们设置的快捷选项标签唯一标识，根据不同标识执行不同操作
    [self showForItem:shortcutItem];
    
    if (completionHandler) {
        completionHandler(YES);
    }
}

/**
 *  /创建图标3DTouch 菜单
 */
- (void)codeAddItems{
    
    /*
        常用键值对
     
     <key>UIApplicationShortcutItemTitle</key>  标题

     <key>UIApplicationShortcutItemType</key>   类型可以设置标识符
   
     <key>UIApplicationShortcutItemIconType</key>   图标类型，可设置系统图标样式

     <key>UIApplicationShortcutItemSubtitle</key>   副标题

     <key>UIApplicationShortcutItemUserInfo</key>   可存放一个字典，通过这个传值

     */
    
    //系统风格的icon
    UIApplicationShortcutIcon *share = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    //使用自定义图标
    UIApplicationShortcutIcon *saoyisao = [UIApplicationShortcutIcon iconWithTemplateImageName:@"erweima"];
    //创建快捷选项 type 标识符
    UIApplicationShortcutItem * item1 = [[UIApplicationShortcutItem alloc]initWithType:@"com.occode.app.share" localizedTitle:@"分享" localizedSubtitle:@"分享副标题" icon:share userInfo:nil];
    UIApplicationShortcutItem * item2 = [[UIApplicationShortcutItem alloc]initWithType:@"com.mycompany.app.saoyisao" localizedTitle:@"扫一扫" localizedSubtitle:@"扫一扫副标题" icon:saoyisao userInfo:nil];
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[item1,item2];
    
}

@end
