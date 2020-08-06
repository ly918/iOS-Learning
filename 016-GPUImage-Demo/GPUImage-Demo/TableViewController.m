//
//  TableViewController.m
//  GPUImage-Demo
//
//  Created by Luca on 2018/9/26.
//  Copyright © 2018年 Luca. All rights reserved.
//

#import "TableViewController.h"
#import "FilterImageViewController.h"
#import "TakePhotoViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    self.title = @"Filter";
}

- (void)showImageWithFilter:(NSString *)filter title:(NSString *)title{
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FilterImageViewController *imgVC = [SB instantiateViewControllerWithIdentifier:@"FilterImageViewController"];
    imgVC.title = title;
    imgVC.filter = filter;
    imgVC.image = [UIImage imageNamed:@"face.jpg"];
    [self.navigationController pushViewController:imgVC animated:YES];
}

- (void)showRealFilterWithName:(NSString *)name title:(NSString *)title{
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * imgVC = [SB instantiateViewControllerWithIdentifier:name];
    imgVC.title = title;
    [self.navigationController pushViewController:imgVC animated:YES];
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath{
    NSString * title = nil;
    NSInteger section = indexPath.section;
    if (section==0) {
        title = [self.colorFilters[indexPath.row] allKeys].firstObject;
    }
    if (section==1) {
        title = [self.imageFilters[indexPath.row] allKeys].firstObject;
    }
    if (section==2) {
        title = [self.visualEffectFilters[indexPath.row] allKeys].firstObject;
    }
    if (section==3) {
        title = [self.blendFilters[indexPath.row] allKeys].firstObject;
    }
    if (section==4) {
        title = [self.customFilters[indexPath.row] allKeys].firstObject;
    }
    return title;
}

- (NSString *)filterAtIndexPath:(NSIndexPath *)indexPath{
    NSString * filter = nil;
    NSInteger section = indexPath.section;
    if (section==0) {
        filter = [self.colorFilters[indexPath.row] allValues].firstObject;
    } else if (section==1) {
        filter = [self.imageFilters[indexPath.row] allValues].firstObject;
    } else if (section==2) {
        filter = [self.visualEffectFilters[indexPath.row] allValues].firstObject;
    } else if (section==3) {
        filter = [self.blendFilters[indexPath.row] allValues].firstObject;
    }
    else if (section==4) {
        filter = [self.customFilters[indexPath.row] allValues].firstObject;
    }
    return filter;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return [self colorFilters].count;
    }
    if (section==1) {
        return [self imageFilters].count;
    }
    if (section==2) {
        return [self visualEffectFilters].count;
    }
    if (section==3) {
        return [self blendFilters].count;
    }
    if (section==4) {
        return [self customFilters].count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.textLabel.text = [self titleAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * filter = [self filterAtIndexPath:indexPath];
    NSString * title = [self titleAtIndexPath:indexPath];
    if (indexPath.section==3) {
        [self showRealFilterWithName:filter title:title];
    } else {
        [self showImageWithFilter:filter title:title];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self sectionTitles][section];
}

//Filters
- (NSArray *)colorFilters{
    return @[
             @{@"亮度":@"GPUImageBrightnessFilter"},
             @{@"曝光度":@"GPUImageExposureFilter"},
             @{@"对比度":@"GPUImageContrastFilter"},
             @{@"饱和度":@"GPUImageSaturationFilter"},
             @{@"反转":@"GPUImageColorInvertFilter"},
             @{@"褐色":@"GPUImageSepiaFilter"},
             @{@"亮度平均值(黑白)":@"GPUImageAverageLuminanceThresholdFilter"},
             ];
}

- (NSArray *)imageFilters{
    return @[
             @{@"形状变化2D":@"GPUImageTransformFilter"},
             @{@"形状变化3D":@"GPUImageTransformFilter"},
             @{@"裁剪":@"GPUImageCropFilter"},
             @{@"高斯模糊":@"GPUImageGaussianBlurFilter"},
             @{@"高斯模糊(选取部分模糊)":@"GPUImageGaussianBlurPositionFilter"},
             @{@"高斯模糊(选取部分清晰)":@"GPUImageGaussianSelectiveBlurFilter"},
             ];
}

- (NSArray *)visualEffectFilters{
    return @[
             @{@"素描":@"GPUImageSketchFilter"},
             @{@"卡通效果":@"GPUImageToonFilter"},
             @{@"卡通效果(更细腻)":@"GPUImageSmoothToonFilter"},
             @{@"马赛克":@"GPUImageMosaicFilter"},
             @{@"像素风":@"GPUImagePixellateFilter"},
             @{@"膨胀失真(鱼眼效果)":@"GPUImageBulgeDistortionFilter"},
             @{@"收缩失真(凹面镜)":@"GPUImagePinchDistortionFilter"},
             ];
}

- (NSArray *)blendFilters{
    return @[
             @{@"拍摄":@"TakePhotoViewController"},
             @{@"视频文件":@"VideoFileViewController"},
             @{@"视频水印/贴图":@"VideoBlendsViewController"},
             ];
}

- (NSArray *)customFilters{
    return @[
             @{@"美颜":@"GPUImageBeautifyFilter"},
             @{@"着色器":@"GPUImageFilter"},
             @{@"Lookup-YuanQi":@"GPUImageLookupFilter"},
             @{@"Lookup-Pink":@"GPUImageLookupFilter"},
             @{@"Lookup-Custom1":@"GPUImageLookupFilter"},
             @{@"Lookup-Custom2":@"GPUImageLookupFilter"},
             ];
}

- (NSArray *)sectionTitles{
    return @[
             @"颜色调整",
             @"图像处理",
             @"视觉特效",
             @"实时滤镜",
             @"自定义滤镜",
             ];
}

@end
