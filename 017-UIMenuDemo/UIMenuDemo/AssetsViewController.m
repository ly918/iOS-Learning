//
//  AssetsViewController.m
//  UIMenuDemo
//
//  Created by GNR on 2020/5/26.
//  Copyright © 2020 LvYuan. All rights reserved.
//

#import "AssetsViewController.h"
#import "AssetViewController.h"
#import "UIViewController+Share.h"
#import "AssetsGridCell.h"

@interface AssetsViewController ()
@property (nonatomic, assign) CGSize thumbSize;
@end

@implementation AssetsViewController

static NSString * const reuseIdentifier = @"AssetsGridCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.assetCollection.localizedTitle ?: @"All Photos";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    self.thumbSize = CGSizeMake(layout.itemSize.width * UIScreen.mainScreen.scale, layout.itemSize.height * UIScreen.mainScreen.scale);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetsGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PHAsset *asset = self.assets[indexPath.item];
    cell.thumbSize = self.thumbSize;
    [cell configAsset:asset];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    
    __weak typeof(self) wself = self;
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:indexPath previewProvider:nil actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        UIMenu *editMenu = [UIMenu menuWithTitle:@"Edit..." image:nil identifier:nil options:0 children:@[
            [UIAction actionWithTitle:@"Copy" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            
            }],
            [UIAction actionWithTitle:@"Duplicate" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            
            }]
        ]];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"" image:nil identifier:nil options:UIMenuOptionsDisplayInline children:@[
            [UIAction actionWithTitle:@"Share" image:[UIImage systemImageNamed:@""] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                [wself share:wself.assets[indexPath.item] completionHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [wself showAlertTitle:completed ? @"分享成功" : @"分享失败"];
                    });
                }];
            }],
            editMenu,
            [UIAction actionWithTitle:@"Delete" image:[UIImage systemImageNamed:@""] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                
            }]
        ]];
        return menu;
    }];
    return configuration;
}

- (UITargetedPreview *)collectionView:(UICollectionView *)collectionView previewForHighlightingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration {
    
    AssetsGridCell *cell = (AssetsGridCell *)[collectionView cellForItemAtIndexPath:(NSIndexPath *)configuration.identifier];
    UITargetedPreview *preview = [[UITargetedPreview alloc] initWithView:cell.photoView];
    return preview;
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    AssetsGridCell *cell = (AssetsGridCell *)[collectionView cellForItemAtIndexPath:(NSIndexPath *)configuration.identifier];

    [animator addCompletion:^{
        [self performSegueWithIdentifier:@"toAssetViewController" sender:cell];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue.identifier isEqualToString:@"toAssetViewController"]) return;
    if (![[segue destinationViewController] isKindOfClass:AssetViewController.class]) return;
    if (![sender isKindOfClass:AssetsGridCell.class]) return;
    AssetsGridCell *cell = (AssetsGridCell *)sender;
    PHAsset *asset = [self.assets objectAtIndex:[self.collectionView indexPathForCell:cell].item];
    if (!asset) return;
    AssetViewController *assetVC = (AssetViewController *)segue.destinationViewController;
    assetVC.asset = asset;
}

@end
