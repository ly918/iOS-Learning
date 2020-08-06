//
//  AssetsGridCell.m
//  UIMenuDemo
//
//  Created by GNR on 2020/5/26.
//  Copyright © 2020 LvYuan. All rights reserved.
//

#import "AssetsGridCell.h"

@implementation AssetsGridCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.photoView.image = nil;
    self.photoliveIcon.hidden = YES;
}

- (void)configAsset:(PHAsset *)asset {
    if (!asset) return;
    __weak typeof(self) wself = self;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    self.assetId = asset.localIdentifier;
    
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:self.thumbSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if ([wself.assetId isEqualToString:asset.localIdentifier]) {
            wself.photoView.image = result;
            wself.photoliveIcon.hidden = (asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) == 0;
        }
    }];
}

@end
