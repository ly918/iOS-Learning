//
//  FilterImageViewController.m
//  GPUImage-Demo
//
//  Created by Luca on 2018/9/26.
//  Copyright © 2018年 Luca. All rights reserved.
//

#import "FilterImageViewController.h"
#import "GPUImage.h"
#import "GPUImageView.h"

@interface FilterImageViewController ()
{
    GPUImagePicture *source;
    GPUImageOutput<GPUImageInput> *g_filter;
    GPUImageView *g_imageView;
    GPUImagePicture *lookupImageSource;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *infoL;
@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)sliderAction:(id)sender;

@end

@implementation FilterImageViewController
- (void)dealloc{
    NSLog(@"FilterImageViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpFilter];
    [self setupUI];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [g_filter removeAllTargets];
    [source removeAllTargets];
}

- (void)setUpFilter{
    //GPUImageView
    g_imageView = [[GPUImageView alloc]initWithFrame:self.containerView.bounds];
    g_imageView.fillMode = kGPUImageFillModePreserveAspectRatio;
    [self.containerView addSubview:g_imageView];
    
    //source
    source = [[GPUImagePicture alloc]initWithImage:self.image];
    
    //filter
    if ([self.title isEqualToString:@"着色器"]) {
        g_filter = [[GPUImageFilter alloc]initWithFragmentShaderFromFile:@"CustomFilter"];
    }
    else {
        g_filter = [[NSClassFromString(self.filter) alloc]init];
    }
    //    [g_filter forceProcessingAtSize:g_imageView.sizeInPixels];
    
    //->target
    if ([self.title hasPrefix:@"Lookup"]) {
        NSString *imageName = self.lookupImgName;
        lookupImageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:imageName]];
        [source addTarget:g_filter];
        [lookupImageSource addTarget:g_filter];
        [g_filter addTarget:g_imageView];
    } else {
        [source addTarget:g_filter];
        [g_filter addTarget:g_imageView];
    }
}

- (NSString*)lookupImgName{
    NSArray *subArr = [self.title componentsSeparatedByString:@"-"];
    if (subArr.count>=2) {
        return [NSString stringWithFormat:@"%@.png",subArr[1]];
    }
    return @"lookup.png";
}

- (void)setupUI{
    //slider
    if ([_filter isEqualToString:@"GPUImageBrightnessFilter"]) {
        _slider.value = 0;
        _slider.minimumValue = -1;
        _slider.maximumValue = 1;
    } else if ([_filter isEqualToString:@"GPUImageExposureFilter"]) {
        _slider.value = 0;
        _slider.minimumValue = -10;
        _slider.maximumValue = 10;
    } else if ([_filter isEqualToString:@"GPUImageContrastFilter"]) {
        _slider.value = 1;
        _slider.minimumValue = 0;
        _slider.maximumValue = 4;
    } else if ([_filter isEqualToString:@"GPUImageSaturationFilter"]) {
        _slider.value = 1;
        _slider.minimumValue = 0;
        _slider.maximumValue = 2;
    } else if ([_filter isEqualToString:@"GPUImageCrosshairGenerator"]) {
        _slider.value = 5;
        _slider.minimumValue = 0;
        _slider.maximumValue = 10;
        [(GPUImageCrosshairGenerator *)g_filter setCrosshairColorRed:1 green:0 blue:0];
    } else if ([self.title isEqualToString:@"形状变化2D"]) {
        _slider.value = 0.8;
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        [(GPUImageTransformFilter *)g_filter setAffineTransform:CGAffineTransformMakeRotation(_slider.value*M_PI)];
    } else if ([self.title isEqualToString:@"形状变化3D"]) {
        _slider.value = 0;
        _slider.minimumValue = -1;
        _slider.maximumValue = 1;
        [(GPUImageTransformFilter *)g_filter setTransform3D:CATransform3DMakeRotation( M_PI / 180, _slider.value, _slider.value, _slider.value)];
    } else if ([_filter isEqualToString:@"GPUImageCropFilter"]) {
        _slider.value = 0.5;
        _slider.minimumValue = 0.1;
        _slider.maximumValue = 1;
        [(GPUImageCropFilter *)g_filter setCropRegion:CGRectMake(0, 0, _slider.value, _slider.value)];
    } else if ([_filter isEqualToString:@"GPUImageGaussianBlurFilter"]) {
        _slider.value = 10;
        _slider.minimumValue = 0;
        _slider.maximumValue = 100;
        [(GPUImageGaussianBlurFilter *)g_filter setBlurRadiusInPixels:_slider.value];
    } else if ([_filter isEqualToString:@"GPUImageGaussianBlurPositionFilter"]) {
        _slider.value = 0.5;
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        [(GPUImageGaussianBlurPositionFilter *)g_filter setBlurRadius:_slider.value];
        [(GPUImageGaussianBlurPositionFilter *)g_filter setBlurSize:10];
        [(GPUImageGaussianBlurPositionFilter *)g_filter setBlurCenter:CGPointMake(0.5, 0.5)];
    } else if ([_filter isEqualToString:@"GPUImageGaussianSelectiveBlurFilter"]) {
        _slider.value = 0.5;
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        [(GPUImageGaussianSelectiveBlurFilter *)g_filter setExcludeBlurSize:0.5];
        [(GPUImageGaussianSelectiveBlurFilter *)g_filter setBlurRadiusInPixels:30];
        [(GPUImageGaussianSelectiveBlurFilter *)g_filter setExcludeCirclePoint:CGPointMake(0.5, 0.5)];
        [(GPUImageGaussianSelectiveBlurFilter *)g_filter setExcludeCircleRadius:_slider.value];
        [(GPUImageGaussianSelectiveBlurFilter *)g_filter setAspectRatio:1];
    } else if ([_filter isEqualToString:@"GPUImageMosaicFilter"]) {
        _slider.hidden = YES;
        self.infoL.hidden = YES;
        [(GPUImageMosaicFilter *)g_filter setTileSet:@"masic_set.jpg"];
    } else if ([_filter isEqualToString:@"GPUImagePixellateFilter"]) {
        _slider.value = 0.1;
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        [(GPUImagePixellateFilter *)g_filter setFractionalWidthOfAPixel:_slider.value];//宽度百分比
    }
    else {
        _slider.hidden = YES;
        self.infoL.hidden = YES;
    }
    
    //value
    self.infoL.text = @(_slider.value).stringValue;
    //process
    [source processImage];
    [lookupImageSource processImage];
}

- (IBAction)sliderAction:(UISlider *)sender {
    NSString *value = [NSString stringWithFormat:@"%.2f",sender.value];
    if ([g_filter isKindOfClass:[GPUImageBrightnessFilter class]]) {
        [(GPUImageBrightnessFilter *)g_filter setBrightness:sender.value];
        self.infoL.text = value;
    } else if ([g_filter isKindOfClass:[GPUImageExposureFilter class]]) {
        [(GPUImageExposureFilter *)g_filter setExposure:sender.value];
        self.infoL.text = value;
    } else if ([g_filter isKindOfClass:[GPUImageContrastFilter class]]) {
        [(GPUImageContrastFilter *)g_filter setContrast:sender.value];
        self.infoL.text = value;
    } else if ([g_filter isKindOfClass:[GPUImageSaturationFilter class]]) {
        [(GPUImageSaturationFilter *)g_filter setSaturation:sender.value];
        self.infoL.text = value;
    } else if ([g_filter isKindOfClass:[GPUImageCrosshairGenerator class]]) {
        [(GPUImageCrosshairGenerator *)g_filter setCrosshairWidth:sender.value];
        self.infoL.text = value;
    } else if ([g_filter isKindOfClass:[GPUImageTransformFilter class]]) {
        if ([self.title isEqualToString:@"形状变化2D"]) {
            [(GPUImageTransformFilter *)g_filter setAffineTransform:CGAffineTransformMakeRotation(_slider.value*M_PI)];
        } else if ([self.title isEqualToString:@"形状变化3D"]) {
            [(GPUImageTransformFilter *)g_filter setTransform3D:CATransform3DMakeRotation(_slider.value, 1, 1, 1)];
        }
        self.infoL.text = value;
    } else if ([g_filter isKindOfClass:[GPUImageCropFilter class]]) {
        [(GPUImageCropFilter *)g_filter setCropRegion:CGRectMake(0,0, _slider.value, _slider.value)];
        self.infoL.text = value;
    } else if ([g_filter isKindOfClass:[GPUImageGaussianBlurFilter class]]) {
        [(GPUImageGaussianBlurFilter *)g_filter setBlurRadiusInPixels:_slider.value];
        self.infoL.text = value;
    } else if ([g_filter isKindOfClass:[GPUImageGaussianBlurPositionFilter class]]) {
        [(GPUImageGaussianBlurPositionFilter *)g_filter setBlurRadius:_slider.value];
        self.infoL.text = value;
    } else if ([g_filter isKindOfClass:[GPUImageGaussianSelectiveBlurFilter class]]) {
        [(GPUImageGaussianSelectiveBlurFilter *)g_filter setExcludeCircleRadius:_slider.value];
        self.infoL.text = value;
    } else if ([g_filter isKindOfClass:[GPUImagePixellateFilter class]]) {
        [(GPUImagePixellateFilter *)g_filter setFractionalWidthOfAPixel:_slider.value];
        self.infoL.text = value;
    } 

    [source processImage];
}

@end



