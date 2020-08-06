//
//  LYKVONotifying_Person.m
//  响应式编程思想
//
//  Created by LvYuan on 16/7/25.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "LYKVONotifying_Person.h"

#import <objc/runtime.h>

@implementation LYKVONotifying_Person

- (void)setAge:(int)age{
    
    [super setAge:age];
    //KVO
    //获取观察者
    id observer = objc_getAssociatedObject(self, @"observer");
    
    //调用观察者方法
    [observer observeValueForKeyPath:@"age" ofObject:observer change:nil context:nil];
}

@end
