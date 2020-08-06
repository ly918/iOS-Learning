//
//  ViewController.m
//  autoLayoutTest2
//
//  Created by LY on 15/4/19.
//  Copyright (c) 2015年 YQC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewTopSpace;
@property (weak, nonatomic) IBOutlet UIView *middelView;

@end

@implementation ViewController
{
    CGFloat _middleViewTopSpaceLayoutConstant;
    CGFloat _middleViewOriginY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.panGesture addTarget:self action:@selector(pan)];
    _middleViewTopSpaceLayoutConstant = self.middleViewTopSpace.constant;
    _middleViewOriginY = self.middelView.frame.origin.y;
}

- (void)pan{
    if (self.panGesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = self.middelView.frame;
            frame.origin.y = _middleViewOriginY;
            self.middelView.frame = frame;
        } completion:^(BOOL finished) {
            if (finished) {
                self.middleViewTopSpace.constant = _middleViewTopSpaceLayoutConstant;
            }
        }];
    }
    CGFloat y = [self.panGesture translationInView:self.view].y;
    self.middleViewTopSpace.constant = _middleViewTopSpaceLayoutConstant + y;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
