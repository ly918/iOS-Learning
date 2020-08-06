//
//  PhotoViewController.m
//  3DTouchTest
//
//  Created by LvYuan on 16/7/20.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "PhotoViewController.h"
#import "Macro.h"

@interface PhotoViewController ()

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UITapGestureRecognizer * tap;

@end

@implementation PhotoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,_image.size.width , _image.size.height)];
    _imageView.image = _image;
    [self.view addSubview:_imageView];
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)];
    [self.view addGestureRecognizer:_tap];
    
}

- (void)tapPress:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self hideNavBar:!self.navigationController.navigationBarHidden];
    }
}


- (void)hideNavBar:(BOOL)hide{
    [self.navigationController setNavigationBarHidden:hide animated:true];
}

- (void)relayoutSubviews{
    _imageView.center = CGPointMake(SCREENSIZEWidth/2.0, SCREENSIZEHeight/2.0);
}

@end
