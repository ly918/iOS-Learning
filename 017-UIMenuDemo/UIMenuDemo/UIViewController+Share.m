//
//  UIViewController+Share.m
//  UIMenuDemo
//
//  Created by GNR on 6/16/20.
//  Copyright © 2020 LvYuan. All rights reserved.
//

#import "UIViewController+Share.h"

@implementation UIViewController (Share)

- (void)share:(PHAsset *)asset completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)completionHandler {
    if (!asset) return;
    __block UIImage *image = nil;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = YES;
    
    [[PHCachingImageManager defaultManager] requestImageDataAndOrientationForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
        image = [UIImage imageWithData:imageData];
    }];
    
    if (!image) return;
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[image] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks, UIActivityTypeMarkupAsPDF];
    activityVC.completionWithItemsHandler = completionHandler;
    [self showDetailViewController:activityVC sender:nil];
}

- (void)saveLivePhoto:(PHAsset *)asset completion:(void(^)(BOOL success))completion {
    if (!asset) return;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = YES;
    
    __block NSData *coverData = nil;
    [[PHCachingImageManager defaultManager] requestImageDataAndOrientationForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        coverData = UIImageJPEGRepresentation(image, 0.9);
    }];
    NSString *temRootPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"mylivephoto"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:temRootPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:temRootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *coverTemPath = [temRootPath stringByAppendingPathComponent:@"temp.JPG"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:coverTemPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:coverTemPath error:nil];
    }
    NSURL *imageUrl = [NSURL fileURLWithPath:coverTemPath];
    BOOL writed = [coverData writeToURL:imageUrl atomically:YES];
    if (!writed) {
        NSLog(@"write image error!");
        if (completion) completion(NO);
        return;
    }
    
    PHVideoRequestOptions *videoOption = [[PHVideoRequestOptions alloc]init];
    videoOption.networkAccessAllowed = YES;
    [[PHCachingImageManager defaultManager] requestExportSessionForVideo:asset options:videoOption exportPreset:AVAssetExportPresetPassthrough resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
        if (!exportSession) {
            if (completion) completion(NO);
            return;
        }
        
        NSString *temPath = [temRootPath stringByAppendingPathComponent:@"temp.MOV"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:temPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:temPath error:nil];
        }
        NSURL *videoUrl = [NSURL fileURLWithPath:temPath];
        exportSession.outputURL = videoUrl;
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch (exportSession.status) {
                case AVAssetExportSessionStatusCompleted:
                {
                    NSLog(@"imageUrl %@", imageUrl);
                    NSLog(@"videoUrl %@", videoUrl);
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
                        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                        [request addResourceWithType:PHAssetResourceTypePhoto fileURL:imageUrl options:options];
                        [request addResourceWithType:PHAssetResourceTypePairedVideo fileURL:videoUrl options:options];
                        
                    } completionHandler:^(BOOL success, NSError * _Nullable error) {
                        if (completion) completion(success);
                        if (success) {
                            NSLog(@"success!");
                        } else {
                            NSLog(@"error %@", error.localizedDescription);
                        }
                    }];
                }
                    break;
                case AVAssetExportSessionStatusFailed:
                case AVAssetExportSessionStatusCancelled:
                {
                    if (completion) completion(NO);
                }
                    break;
                default:
                {
                    NSLog(@"exportSession status %d", (int)exportSession.status);
                }
                    break;
            }
        }];
    }];
}

- (void)showAlertTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction: [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self showDetailViewController:alert sender:nil];
}

@end
