//
//  AssetsViewController.h
//  UIMenuDemo
//
//  Created by GNR on 2020/5/26.
//  Copyright © 2020 LvYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;
NS_ASSUME_NONNULL_BEGIN

@interface AssetsViewController : UICollectionViewController

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) PHFetchResult <PHAsset *>* assets;

@end

NS_ASSUME_NONNULL_END
