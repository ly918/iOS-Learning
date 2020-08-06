//
//  AlbumsViewController.m
//  UIMenuDemo
//
//  Created by GNR on 2020/5/25.
//  Copyright © 2020 LvYuan. All rights reserved.
//

#import "AlbumsViewController.h"
#import "AssetsViewController.h"
#import "AlbumViewCell.h"
@import Photos;

static NSInteger const kAlbubmSectionNumber = 3;

@interface AlbumsViewController ()

@property (nonatomic, assign) CGSize thumbSize;
@property (nonatomic, strong) PHFetchResult <PHAsset *>* allAlbum;
@property (nonatomic, strong) PHFetchResult <PHAssetCollection *>* smartAlbums;
@property (nonatomic, strong) PHFetchResult <PHCollection *>*userAlbums;

@end

@implementation AlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.clearsSelectionOnViewWillAppear = YES;
    self.thumbSize = CGSizeMake(100 * UIScreen.mainScreen.scale, 100 * UIScreen.mainScreen.scale);
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(reloadAlbums) forControlEvents:UIControlEventValueChanged];
    [self reloadAlbums];
}

- (void)reloadAlbums {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                self.allAlbum = [PHAsset fetchAssetsWithOptions:[self defaultOptions]];
                self.smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
                self.userAlbums = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.refreshControl endRefreshing];
                    [self.tableView reloadData];
                });
            });
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kAlbubmSectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.smartAlbums.count;
        default:
            return self.userAlbums.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumViewCell" forIndexPath:indexPath];
    PHAssetCollection *assetCollection = nil;
    NSString *title = nil;
    
    __block PHFetchResult <PHAsset *>*assets = nil;
    __block PHAsset *asset = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            assets = self.allAlbum;
            asset = self.allAlbum.firstObject;
            title = @"All Photos";
        }
            break;
        case 1:
        {
            assetCollection = self.smartAlbums[indexPath.item];
            title = assetCollection.localizedTitle;
        }
            break;
        default:
        {
            PHCollection *collection = self.userAlbums[indexPath.item];
            if ([collection isKindOfClass:PHAssetCollection.class]) {
                assetCollection = (PHAssetCollection *)collection;
                title = assetCollection.localizedTitle;
            }
        }
            break;
    }
    
    cell.thumbSize = self.thumbSize;
    cell.nameLabel.text = title ?: @"";
    [cell configAssetCollection:assetCollection assets:assets];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue.destinationViewController isKindOfClass:AssetsViewController.class]) return;
    if (![sender isKindOfClass:AlbumViewCell.class]) return;
    AlbumViewCell *cell = (AlbumViewCell *)sender;
    AssetsViewController *assetsViewController = (AssetsViewController *)segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PHFetchResult <PHAsset *>* assets = nil;
    PHAssetCollection *assetCollection = nil;
    switch (indexPath.section) {
        case 0:
        {
            assets = self.allAlbum;
        }
            break;
        case 1:
        {
            assetCollection = self.smartAlbums[indexPath.item];
        }
            break;
        default:
        {
            PHCollection *collection = self.userAlbums[indexPath.item];
            if ([collection isKindOfClass:PHAssetCollection.class]) {
                assetCollection = (PHAssetCollection *)collection;
            }
        }
            break;
    }
    
    if (assetCollection) {
        PHFetchOptions *options = [[PHFetchOptions alloc]init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    } else if (!assets.count) {
        assets = [PHAsset fetchAssetsWithOptions:[self defaultOptions]];
    }
    assetsViewController.assets = assets;
    assetsViewController.assetCollection = assetCollection;
}

- (PHFetchOptions *)defaultOptions {
    PHFetchOptions *options = [[PHFetchOptions alloc]init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    return options;
}

@end
