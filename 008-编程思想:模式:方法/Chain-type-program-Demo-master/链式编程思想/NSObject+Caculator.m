//
//  NSObject+Caculator.m
//  链式编程思想
//
//  Created by LvYuan on 16/7/25.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "NSObject+Caculator.h"

@implementation NSObject(Caculator)

+ (int)makeCaculator:(void (^)(CaculatorMaker *))caculatorMaker{
    
    CaculatorMaker * maker = [[CaculatorMaker alloc]init];
    
    caculatorMaker(maker);
    
    return maker.result;
}

@end
