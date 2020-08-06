//
//  VideoBlendsViewController.m
//  GPUImage-Demo
//
//  Created by Luca on 2018/9/28.
//  Copyright © 2018年 Luca. All rights reserved.
//

#import "VideoBlendsViewController.h"
#import "GPUImage.h"
#import "GPUImageView.h"
#import "GPUImageMovie.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoBlendsViewController ()
{
    GPUImageMovie *movie;
    GPUImageUIElement *UI;
    GPUImageOutput<GPUImageInput>*filter;
    GPUImageView *g_imageView;
    GPUImageMovieWriter *writer;
    NSURL *url;
    NSString *moviePath;
}

@property (weak, nonatomic) IBOutlet UILabel *progressL;

@end

@implementation VideoBlendsViewController

- (void)dealloc{
    NSLog(@"VideoBlendsViewController Dealloc");
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    movie.audioEncodingTarget = nil;
    [filter removeAllTargets];
    [UI removeAllTargets];
    [movie removeAllTargets];
    [writer cancelRecording];
    [movie cancelProcessing];
    [writer setCompletionBlock:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    g_imageView = (GPUImageView *)self.view;
    
    filter = [[GPUImageAlphaBlendFilter alloc]init];
    [(GPUImageAlphaBlendFilter *)filter setMix:1];
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"video1" withExtension:@"mp4"];
    movie = [[GPUImageMovie alloc]initWithAsset:[AVAsset assetWithURL:url]];
    movie.runBenchmark = YES;
    movie.playAtActualSpeed = YES;
    
    //UI
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    label.text = @"我是水印";
    label.font = [UIFont boldSystemFontOfSize:30];
    label.textColor = [UIColor greenColor];
    [label sizeToFit];
    
    UIImage *image = [UIImage imageNamed:@"face.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    imageView.image = image;
    UIView *subView = [[UIView alloc] initWithFrame:self.view.bounds];
    subView.backgroundColor = [UIColor clearColor];
    imageView.center = CGPointMake(subView.bounds.size.width / 2, subView.bounds.size.height / 2);
    [subView addSubview:imageView];
    [subView addSubview:label];
    
    UI = [[GPUImageUIElement alloc]initWithView:subView];

    //writer
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.mp4",[NSUUID UUID].UUIDString]];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    url = movieURL;
    moviePath = pathToMovie;
    
    //writer
    writer = [[GPUImageMovieWriter alloc]initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
    writer.shouldPassthroughAudio = YES;
    movie.audioEncodingTarget = writer;
    [movie enableSynchronizedEncodingUsingMovieWriter:writer];
    
    //progress
    GPUImageFilter *progressFilter = [[GPUImageFilter alloc]init];
    [movie addTarget:progressFilter];
    [progressFilter addTarget:filter];
    [UI addTarget:filter];
    [filter addTarget:g_imageView];
    [filter addTarget:writer];
    
    [writer startRecording];
    [movie startProcessing];
    
    CADisplayLink *dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [dlink setPaused:NO];
    
    __weak typeof(self) weakSelf = self;

    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput * outPut, CMTime time) {
        __strong typeof(self) strongSelf = weakSelf;
        CGRect frame = imageView.frame;
        frame.origin.x += 1;
        frame.origin.y += 1;
        imageView.frame = frame;
        [strongSelf->UI updateWithTimestamp:time];
    }];
    
    [writer setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf->filter removeAllTargets];
        strongSelf->movie.audioEncodingTarget = nil;
        [strongSelf->writer finishRecordingWithCompletionHandler:^{
            [strongSelf saveVideo];
        }];
    }];

}

- (void)updateProgress{
    self.progressL.text = [NSString stringWithFormat:@"Progress:%d%%", (int)(movie.progress * 100)];
    [self.progressL sizeToFit];
}

- (void)saveVideo{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"视频录制成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
