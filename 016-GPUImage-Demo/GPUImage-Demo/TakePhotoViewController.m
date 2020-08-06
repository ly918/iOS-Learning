//
//  TakePhotoViewController.m
//  GPUImage-Demo
//
//  Created by Luca on 2018/9/27.
//  Copyright © 2018年 Luca. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "GPUImage.h"
#import "GPUImageView.h"
#import <Photos/Photos.h>
#import "GPUImageBeautifyFilter.h"
@interface TakePhotoViewController ()
{
    GPUImageStillCamera *camera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageBeautifyFilter *beautifulFilter;
    __weak IBOutlet GPUImageView *imageView;
    GPUImageMovieWriter *writer;
    NSURL *url;
    __block NSString *currentFilterCls;
}
@property (weak, nonatomic) IBOutlet UIView *takeBtn;
@property (weak, nonatomic) IBOutlet UIButton *beautifulBtn;

- (IBAction)takePhotoAction:(id)sender;

- (IBAction)recordVideoAction:(UIButton *)sender;

- (IBAction)endRecord:(id)sender;

- (IBAction)switchFilterAction:(id)sender;

- (IBAction)beautifulAction:(UIButton *)sender;

@end

@implementation TakePhotoViewController

- (void)dealloc{
    NSLog(@"TakePhotoViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)];
    [_takeBtn addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress= [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [_takeBtn addGestureRecognizer:longPress];
    
    camera = [[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    camera.horizontallyMirrorFrontFacingCamera = YES;
    camera.horizontallyMirrorRearFacingCamera = YES;
    
    imageView.fillMode = kGPUImageFillModePreserveAspectRatio;

    [self switchFilter:[[self filters].firstObject allValues].firstObject];
    
    [camera startCameraCapture];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [filter removeAllTargets];
    [camera removeAllTargets];
    [camera stopCameraCapture];
    camera.audioEncodingTarget = nil;
}

//屏幕方向
- (void)deviceOrientationDidChange:(NSNotification *)notify{
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    camera.outputImageOrientation = orientation;
}


- (IBAction)takePhotoAction:(UIButton*)sender {
    [camera capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        NSLog(@"processedImage %@",processedImage);
        runOnMainQueueWithoutDeadlocking(^{
            [self saveImage:processedImage];
        });
    }];
}

- (IBAction)recordVideoAction:(UIButton *)sender {
    NSLog(@"start recording");
    //重新生产writer
    //Video path
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.mp4",[NSUUID UUID].UUIDString]];
    unlink([path UTF8String]);
    url = [NSURL fileURLWithPath:path];

    writer = [[GPUImageMovieWriter alloc] initWithMovieURL:url size:CGSizeMake(480.0, 640.0)];
    writer.encodingLiveVideo = YES;
    camera.audioEncodingTarget = writer;
    [filter removeAllTargets];
    [camera removeAllTargets];
    [filter addTarget:writer];
    [filter addTarget:imageView];
    [camera addTarget:filter];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->writer startRecording];
    });
}

- (IBAction)endRecord:(id)sender {
    [writer finishRecording];
    [self saveVideo];
}

- (void)saveVideo{
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:self->url];
    } error:&error];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:!error?@"保存成功":@"保存失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image{
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } error:&error];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:!error?@"保存成功":@"保存失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)switchFilterAction:(id)sender {
    [self switchFilterActionSheet];
}

- (IBAction)beautifulAction:(UIButton *)sender {
    if (!beautifulFilter) {
        beautifulFilter = [[GPUImageBeautifyFilter alloc]init];
    }
    if (self.beautifulBtn.selected==NO) {
        [filter removeAllTargets];
        [camera removeAllTargets];
        [camera addTarget:beautifulFilter];
        [beautifulFilter addTarget:filter];
        [filter addTarget:imageView];
        self.beautifulBtn.selected = YES;
    } else {
        [filter removeAllTargets];
        [camera removeAllTargets];
        [camera addTarget:filter];
        [filter addTarget:imageView];
        self.beautifulBtn.selected = NO;
    }
}

- (void)tapPress:(UITapGestureRecognizer *)sender{
    if (sender.state==UIGestureRecognizerStateEnded) {
        [self takePhotoAction:nil];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)sender{
    if (sender.state==UIGestureRecognizerStateBegan) {
        [self recordVideoAction:nil];
    } else if (sender.state==UIGestureRecognizerStateEnded||
               sender.state==UIGestureRecognizerStateCancelled) {
        [self endRecord:nil];
    }
}

- (void)switchFilterActionSheet{
    __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取滤镜" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __block NSMutableArray *actions = [NSMutableArray array];
    [[self filters] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj.allKeys.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull act) {
            [self switchFilter:obj.allValues.firstObject];
        }];
        [actions addObject:action];
        [alert addAction:action];
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actions addObject:action];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)switchFilter:(NSString *)filterCls{
    if (!filterCls) return;
    [filter removeAllTargets];
    [camera removeAllTargets];
    filter = [[NSClassFromString(filterCls) alloc]init];
    if ([filterCls isEqualToString:@"GPUImageGaussianBlurFilter"]) {
        [(GPUImageGaussianBlurFilter *)filter setBlurRadiusInPixels:20];
    }
    if (self.beautifulBtn.selected) {
        [camera addTarget:beautifulFilter];
        [beautifulFilter addTarget:filter];
    } else {
        [camera addTarget:filter];
    }
    [filter addTarget:imageView];
    
    currentFilterCls = filterCls;
}

- (NSArray *)filters{
    return @[
             @{@"无":@"GPUImageFilter"},
             @{@"褐色":@"GPUImageSepiaFilter"},
             @{@"亮度平均值(黑白)":@"GPUImageAverageLuminanceThresholdFilter"},
             @{@"高斯模糊":@"GPUImageGaussianBlurFilter"},
             @{@"素描":@"GPUImageSketchFilter"},
             @{@"卡通效果(更细腻)":@"GPUImageSmoothToonFilter"},
             @{@"像素风":@"GPUImagePixellateFilter"},
             @{@"膨胀失真(鱼眼效果)":@"GPUImageBulgeDistortionFilter"},
             @{@"收缩失真(凹面镜)":@"GPUImagePinchDistortionFilter"},
             ];
}

- (NSString*)beatifulFilter{
    return @"GPUImageBeautifyFilter";
}

@end
