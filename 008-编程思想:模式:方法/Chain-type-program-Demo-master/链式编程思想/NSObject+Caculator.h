//
//  NSObject+Caculator.h
//  链式编程思想
//
//  Created by LvYuan on 16/7/25.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CaculatorMaker.h"

@interface NSObject(Caculator)

//计算
+ (int)makeCaculator:(void(^)(CaculatorMaker * maker))caculatorMaker;

@end
