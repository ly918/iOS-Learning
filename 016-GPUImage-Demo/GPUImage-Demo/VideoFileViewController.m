//
//  VideoFileViewController.m
//  GPUImage-Demo
//
//  Created by Luca on 2018/9/27.
//  Copyright © 2018年 Luca. All rights reserved.
//

#import "VideoFileViewController.h"
#import "GPUImage.h"
#import "GPUImageView.h"
#import "GPUImageMovie.h"
#import <Photos/Photos.h>

@interface VideoFileViewController ()
{
    GPUImageMovie *movieFile;
    GPUImageView *imageView;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
    NSURL *url;
}

@end

@implementation VideoFileViewController

- (void)dealloc{
    NSLog(@"VideoFileViewController dealloc");
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [filter removeAllTargets];
    [movieFile removeAllTargets];
    [movieWriter cancelRecording];
    [movieFile cancelProcessing];
    [movieWriter setCompletionBlock:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video1" withExtension:@"mp4"];

    movieFile = [[GPUImageMovie alloc] initWithAsset:[AVAsset assetWithURL:url]];
    movieFile.shouldRepeat = YES;
    movieFile.playAtActualSpeed = YES;
    filter = [[GPUImageSketchFilter alloc] init];
    
    [movieFile addTarget:filter];
    
    GPUImageView *filterView = (GPUImageView *)self.view;
    imageView.fillMode = kGPUImageFillModePreserveAspectRatio;
    [filter addTarget:filterView];
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.mp4",[NSUUID UUID].UUIDString]];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
    [filter addTarget:movieWriter];
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    
    [movieWriter startRecording];
    [movieFile startProcessing];
    __weak typeof(self) wself = self;
    [movieWriter setCompletionBlock:^{
        __strong typeof(self) sself = wself;
        [sself->filter removeTarget:sself->movieWriter];
        [sself->movieWriter finishRecording];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"视频录制成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [sself presentViewController:alert animated:YES completion:nil];
    }];
}

@end
