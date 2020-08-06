//
//  NSObject+KVO.h
//  响应式编程思想
//
//  Created by LvYuan on 16/7/25.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(KVO)

- (void)ly_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end
