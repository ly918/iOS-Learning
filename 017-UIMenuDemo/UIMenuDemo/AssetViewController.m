//
//  AssetViewController.m
//  UIMenuDemo
//
//  Created by GNR on 2020/5/26.
//  Copyright © 2020 LvYuan. All rights reserved.
//

#import "AssetViewController.h"
#import "UIViewController+Share.h"
@import Photos;
@import PhotosUI;

@interface AssetViewController ()

@property (strong, nonatomic) PHLivePhotoView *livePhotoView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) AVPlayer *avPlyer;
@property (strong, nonatomic) AVPlayerLayer *avPlyerLayer;

@end

@implementation AssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItems];
    [self requestAsset];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupNavigationItems {
    NSMutableArray *items = @[
        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionPressed:)],
    ].mutableCopy;
    if (self.asset.mediaType == PHAssetMediaTypeVideo) {
        [items addObject:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)]];
    }
    self.navigationItem.rightBarButtonItems = items;
}

- (void)requestAsset {
    if (!self.asset) return;
    
    __weak typeof(self) wself = self;
    
    if ((self.asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) == 0) {
        self.imageView.hidden = NO;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.resizeMode = PHImageRequestOptionsResizeModeNone;
        [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset
                                                          targetSize:self.imageView.bounds.size
                                                         contentMode:PHImageContentModeAspectFit
                                                             options:options
                                                       resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"info %@", info);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result) wself.imageView.image = result;
            });
        }];
        
        if (self.asset.mediaType == PHAssetMediaTypeVideo) {
            [[PHCachingImageManager defaultManager] requestPlayerItemForVideo:self.asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    wself.avPlyer = [AVPlayer playerWithPlayerItem:playerItem];
                    wself.avPlyerLayer = [AVPlayerLayer playerLayerWithPlayer:wself.avPlyer];
                    wself.avPlyerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                    wself.avPlyerLayer.frame = wself.imageView.bounds;
                    [wself.imageView.layer addSublayer:wself.avPlyerLayer];
                    [wself.avPlyer play];
                });
            }];
        }
        
    } else {
        self.livePhotoView = [[PHLivePhotoView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:self.livePhotoView];
        self.imageView.hidden = YES;

        PHLivePhotoRequestOptions *option = [[PHLivePhotoRequestOptions alloc]init];
        [[PHCachingImageManager defaultManager] requestLivePhotoForAsset:self.asset targetSize:self.livePhotoView.bounds.size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
            NSLog(@"livephoto info %@", info);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (livePhoto) {
                    wself.livePhotoView.livePhoto = livePhoto;
                }
            });
        }];
    }
}

- (void)actionPressed:(id)sender {
    __weak typeof(self) wself = self;
    [self share:self.asset completionHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself showAlertTitle:completed ? @"分享成功" : @"分享失败"];
        });
    }];
}

- (void)savePressed:(id)sender {
    __weak typeof(self) wself = self;
    [self saveLivePhoto:self.asset completion:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself showAlertTitle:success ? @"LivePhoto保存成功" : @"LivePhoto保存失败"];
        });
    }];
}

@end
