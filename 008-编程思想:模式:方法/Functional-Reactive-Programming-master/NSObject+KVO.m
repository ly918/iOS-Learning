//
//  NSObject+KVO.m
//  响应式编程思想
//
//  Created by LvYuan on 16/7/25.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import "LYKVONotifying_Person.h"

@implementation NSObject(KVO)

- (void)ly_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    //修改isa指针，就是把当前对象指向一个新的类
    object_setClass(self, [LYKVONotifying_Person class]);
    
    //给对象绑定观察者对象
    objc_setAssociatedObject(self, @"observer", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
