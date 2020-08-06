//
//  ViewController.m
//  链式编程思想
//
//  Created by LvYuan on 16/7/25.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

#import "NSObject+Caculator.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ------- Masonry -------
    
    // 创建控件
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    // 设置控件的约束
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 存放redView设置约束的代码
        make.left.top.equalTo(@10);
        make.right.bottom.equalTo(@-10);
        
    }];
    
    // ------- 计算器 -------
    
    //(1 + 2 + 3 + 4) * 5
    int result = [NSObject makeCaculator:^(CaculatorMaker *maker) {
       
        maker.add(1).add(2).add(3).add(4).muilt(5);
        
    }];
    
    NSLog(@"(1 + 2 + 3 + 4) * 5 = %d",result);
}



@end
