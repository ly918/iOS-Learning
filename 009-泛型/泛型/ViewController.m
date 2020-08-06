//
//  ViewController.m
//  泛型
//
//  Created by LvYuan on 16/7/23.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "ViewController.h"
#import "Animal.h"
#import "Meat.h"
#import "Grass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //需求：假设有个Animal，它有个属性是食物，但是我们定义时并不能确定，只有在创建的时候才能确定，
    //food 如果用id 来定义，就可以传入任何对象
    //如果用泛型声明，在创建的时候确定泛型，复制的时候就有提示了。
    
    Animal <Meat *> * dog = [[Animal alloc]init];
    
    dog.food = [[Meat alloc]init];
    

    
    Animal <Grass *> * sheep = [[Animal alloc]init];
    
    sheep.food = [[Grass alloc]init];

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
