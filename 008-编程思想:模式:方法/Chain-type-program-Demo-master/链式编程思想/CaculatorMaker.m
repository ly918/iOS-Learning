//
//  CaculatorMaker.m
//  链式编程思想
//
//  Created by LvYuan on 16/7/25.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "CaculatorMaker.h"

@implementation CaculatorMaker

- (CaculatorMaker *(^)(int))add{
    
    return ^CaculatorMaker *(int value) {
        
        self.result += value;
        
        return self;
    };
}

- (CaculatorMaker *(^)(int))muilt{
    
    return ^CaculatorMaker *(int value) {
        
        self.result *= value;
        
        return self;
    };
}

- (CaculatorMaker *(^)(int))sub{
    
    return ^CaculatorMaker *(int value) {
        
        self.result -= value;
        
        return self;
    };
}

- (CaculatorMaker *(^)(int))divide{
    
    return ^CaculatorMaker *(int value) {
        
        self.result /= value;
        
        return self;
    };
}

@end
