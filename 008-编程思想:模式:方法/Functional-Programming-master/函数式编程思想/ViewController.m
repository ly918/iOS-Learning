//
//  ViewController.m
//  函数式编程思想
//
//  Created by LvYuan on 16/7/25.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "ViewController.h"
#import "Calulator.h"

@interface ViewController ()

@end

@implementation ViewController

// 把每一个操作都写成一连串的函数或者方法，使代码高度聚合，便于管理.
// 每次都可以调用方法，因此肯定要每次都返回自己。

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 3 * 6 == 18
    
    Calulator * c = [[Calulator alloc]init];
    
    // 计算 3 * 6 判断是否等于10
    
    BOOL isequle = [[[c caculator:^int(int result) {//计算3 * 6
        
        result += 3;
        result *= 6;
        return result;
        
    }] equle:^BOOL(int result) {//计算结果是否为18
        
        return  result == 18;
        
    }] isEqule];//最后获取该bool值
    
    NSLog(@"%d",isequle);
    
}


@end
