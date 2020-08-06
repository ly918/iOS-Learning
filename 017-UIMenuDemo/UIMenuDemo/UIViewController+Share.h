//
//  UIViewController+Share.h
//  UIMenuDemo
//
//  Created by GNR on 6/16/20.
//  Copyright © 2020 LvYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Share)

- (void)share:(PHAsset *)asset completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)completionHandler;

- (void)saveLivePhoto:(PHAsset *)asset completion:(void(^)(BOOL success))completion;

- (void)showAlertTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
