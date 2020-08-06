//
//  MyTabBarController.m
//  毛玻璃
//
//  Created by 米明 on 15/5/5.
//  Copyright (c) 2015年 米明. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()
@property(nonatomic)BOOL isShow;//侧边栏已经显示否？
@property(nonatomic)BOOL isCanShow;//侧边栏可以显示否？
@property(nonatomic)BOOL isCanDismiss;//可以消失否？
@property(nonatomic)CGPoint startPoint;//触摸开始的坐标
@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSideBar];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)creatSideBar{
    
    _backgroundView=[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    _backgroundView.frame=CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
    
    _backgroundView.alpha=0;
    
    _isShow=NO;
    
    [self.view addSubview:_backgroundView];
    
    _sideBar = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    _sideBar.frame=CGRectMake(-ScreenSize.width*3.0/4.0, 0, ScreenSize.width*3.0/4.0, ScreenSize.height);
    
    [self.view addSubview:_sideBar];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //获取点击事件
    UITouch * touch=[touches anyObject];
    //获取当前点坐标
    _startPoint=[touch locationInView:[touch view]];
    
    if (_isShow){//如果侧边栏已经显示 则触摸结束时 应该dimiss侧边栏
        
        _isCanDismiss=YES;
        
        _isCanShow=NO;
        
    }else{
        
        if (_startPoint.x>ScreenSize.width/2.0){//触摸位置在屏幕右侧
            _isCanShow=NO;
            _isCanDismiss=NO;
        }else{//触摸位置在屏幕左侧
            _isCanShow=YES;
            _isCanDismiss=NO;
        }
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //获取点击事件
    UITouch * touch=[touches anyObject];
    //获取当前点坐标
    CGPoint movedPoint=[touch locationInView:[touch view]];
    
    if (_isShow) {//已显示
        if (_startPoint.x>ScreenSize.width*3.0/4.0) {
            if (movedPoint.x-_startPoint.x<0) {//向左划
                _sideBar.center=CGPointMake(movedPoint.x-(_startPoint.x-ScreenSize.width*3.0/4.0)-_sideBar.frame.size.width/2.0, _sideBar.center.y);
            }
        }else{
            if (movedPoint.x-_startPoint.x<0) {//向左划
                _sideBar.center=CGPointMake(movedPoint.x+(ScreenSize.width*3.0/4.0-_startPoint.x)-_sideBar.frame.size.width/2.0, _sideBar.center.y);
            }
        }
    }else{//未显示
        if(_isCanShow&&_sideBar.frame.origin.x<=-5){
            _sideBar.center=CGPointMake(movedPoint.x-_startPoint.x-_sideBar.frame.size.width/2.0, _sideBar.center.y);
        }
    }
    
    float alphaValue = (_sideBar.frame.size.width+_sideBar.frame.origin.x)/_sideBar.frame.size.width;
    
    NSLog(@"%f",alphaValue);
    
    _backgroundView.alpha=alphaValue;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //获取点击事件
    UITouch * touch=[touches anyObject];
    //获取当前点坐标
    CGPoint endPoint=[touch locationInView:[touch view]];

    if (_isShow) {

        if ((endPoint.x-_startPoint.x)<-40) {
            if (_isCanDismiss) {
                [self dismissSideBar];
            }
        }else{
            if (_isShow) {
                [self showSideBar];
            }
            if (_startPoint.x>_sideBar.frame.size.width) {
                if (_isCanDismiss) {
                    [self dismissSideBar];
                }
            }
        }

    }else{
        if ((endPoint.x-_startPoint.x)>40) {
            if (_isCanShow) {
                [self showSideBar];
            }
        }else{
            
            [self dismissSideBar];
            
        }
    }
 
}

-(void)dismissSideBar{
    
    [UIView animateWithDuration:0.1 animations:^{
        _sideBar.frame=CGRectMake(-_sideBar.frame.size.width, 0, _sideBar.frame.size.width, _sideBar.frame.size.height);
        _backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        if (finished) {
            _isShow=NO;
            
            NSLog(@"dismiss");
        }
    }];
}

-(void)showSideBar{
    
    [UIView animateWithDuration:0.1 animations:^{
        _backgroundView.alpha=1;
        _sideBar.frame=CGRectMake(0, 0, _sideBar.frame.size.width, _sideBar.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            _isShow=YES;
            
            NSLog(@"show");
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
