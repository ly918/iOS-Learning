//
//  ViewController.m
//  响应式编程思想
//
//  Created by LvYuan on 16/7/25.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+KVO.h"

@interface ViewController ()

@property (nonatomic,strong) Person * person;

@end

@implementation ViewController

// 1.生成一个Person类的子类 LYKVONotifying_Person
// 2.使当前对象的isa指向新的类，就会调用新类的set方法
// 3.重写NSKVONotifying_Person的setAge方法，每次调用，就调用观察者的observeValueForKeyPath方法
// 4.如何在set方法中，拿到观察者，使用[运行时]让当前对象关联观察者这个属性。

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *p = [[Person alloc] init];
    
    p.age = 0;
    
    _person = p;
    
    [p ly_addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    //[p addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    NSLog(@"Person Age %d Changed",_person.age);
}

- (IBAction)changeAge:(id)sender {
    //0~99随机数
    int newAge = arc4random_uniform(100);
    NSLog(@"New Age -> %d",newAge);
    _person.age = newAge;
}




@end
