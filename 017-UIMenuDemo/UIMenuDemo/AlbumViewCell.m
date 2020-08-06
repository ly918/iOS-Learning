//
//  AlbumViewCell.m
//  UIMenuDemo
//
//  Created by GNR on 2020/5/25.
//  Copyright © 2020 LvYuan. All rights reserved.
//

#import "AlbumViewCell.h"

@implementation AlbumViewCell

- (void)configAssetCollection:(PHAssetCollection *)collection assets:(PHFetchResult <PHAsset *>*)assets {
    if (assets.count) {
        [self reloadWithAssets:assets];
    } else if (collection) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
            PHFetchOptions *options = [[PHFetchOptions alloc]init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult <PHAsset *>* assets = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self reloadWithAssets:assets];
            });
            
        });
    }
}

- (void)reloadWithAssets:(PHFetchResult <PHAsset *> *)assets {
    __weak typeof(self) wself = self;
    self.countLabel.text = [NSString stringWithFormat:@"共%d张", (int)assets.count];
    if (assets.count == 0) {
        self.livephotoIcon.hidden = YES;
        return;
    }
    self.assetId = assets.firstObject.localIdentifier;
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc]init];
    imageOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHCachingImageManager defaultManager] requestImageForAsset:assets.firstObject targetSize:self.thumbSize contentMode:PHImageContentModeAspectFill options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if ([wself.assetId isEqualToString:assets.firstObject.localIdentifier]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.photoView.image = result;
                wself.photoView.contentMode = UIViewContentModeScaleAspectFill;
                wself.livephotoIcon.hidden = (assets.firstObject.mediaSubtypes & PHAssetMediaSubtypePhotoLive) == 0;
                
            });
        }
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.livephotoIcon.hidden = YES;
    self.photoView.image = nil;
    self.nameLabel.text = @"";
    self.countLabel.text = @"";
    self.photoView.image = [UIImage systemImageNamed:@"photo.fill"];
    self.photoView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
