//
//  AlbumViewCell.h
//  UIMenuDemo
//
//  Created by GNR on 2020/5/25.
//  Copyright © 2020 LvYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;
NS_ASSUME_NONNULL_BEGIN

@interface AlbumViewCell : UITableViewCell

@property (nonatomic, copy) NSString *assetId;
@property (nonatomic, assign) CGSize thumbSize;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *livephotoIcon;

- (void)configAssetCollection:(PHAssetCollection *)collection assets:(PHFetchResult <PHAsset *>*)assets;

@end

NS_ASSUME_NONNULL_END
