//
//  Calulator.m
//  函数式编程思想
//
//  Created by LvYuan on 16/7/25.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "Calulator.h"

@implementation Calulator

- (Calulator *)caculator:(int (^)(int))calulator{
    
    _result += calulator(_result);
    
    return self;
}

- (Calulator *)equle:(BOOL (^)(int))operation{
    
    _isEqule = operation(_result);
    
    return self;
}

@end
