//
//  AssetsGridCell.h
//  UIMenuDemo
//
//  Created by GNR on 2020/5/26.
//  Copyright © 2020 LvYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;
NS_ASSUME_NONNULL_BEGIN

@interface AssetsGridCell : UICollectionViewCell

@property (copy, nonatomic) NSString *assetId;
@property (nonatomic, assign) CGSize thumbSize;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIImageView *photoliveIcon;

- (void)configAsset:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
