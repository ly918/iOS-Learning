//
//  AnimationViewController.m
//  CoreAnimation
//
//  Created by LvYuan on 16/7/30.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "AnimationViewController.h"



@implementation AnimationViewController

{
    UIView * _baseV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _baseV = [[UIView alloc]init];
    _baseV.frame = CGRectMake(100, 150, 100, 100);
    _baseV.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_baseV];
    
    switch (self.row) {
        case 0:
            [self customAnimation];
            break;
            
        case 1:
            [self animationKeyFrame];
            break;
            
        case 2:
            [self animationForPath];
            break;
            
        default:
            break;
    }
    
    
}

//自定义基础动画 CABaseAnimation
- (void)customAnimation{
    
    //创建一个CABasicAnimation对象
    CABasicAnimation * animation = [CABasicAnimation animation];
    //设置颜色
    animation.toValue = (id)[UIColor redColor].CGColor;
    //动画时间
    animation.duration = 1;
    //是否反转变为原来的属性值
    animation.autoreverses = true;
    //把animation添加到图形layer中，便可以播放动画了 forkey 指定要应用次动画的属性
    [_baseV.layer addAnimation:animation forKey:@"backgroundColor"];
    
}


//关键帧动画 CAKeyframeAnimation
- (void)animationKeyFrame{
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    //设置属性值
    animation.values = [NSArray arrayWithObjects:(id)_baseV.layer.backgroundColor,[UIColor yellowColor].CGColor,[UIColor greenColor].CGColor,[UIColor blueColor].CGColor, nil];
    animation.duration = 3;
    animation.autoreverses = true;
    //关键帧添加到layer中
    [_baseV.layer addAnimation:animation forKey:@"backgroundColor"];
    
}

//路径动画 CAKeyframeAnimation
- (void)animationForPath{
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    //初始化路径
    CGMutablePathRef path = CGPathCreateMutable();
    //动画起点
    CGPathMoveToPoint(path, nil, 100, 150);
    CGPathAddCurveToPoint(path, nil, 160, 30, 220, 220, 240, 380);
    animation.path = path;
    animation.duration = 10;
    //设置为渐出
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //自动旋转方向
    animation.rotationMode = @"auto";
    
    [_baseV.layer addAnimation:animation forKey:@"position"];
}



@end
