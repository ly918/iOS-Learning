//
//  Calulator.h
//  函数式编程思想
//
//  Created by LvYuan on 16/7/25.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calulator : NSObject

@property (nonatomic, assign) BOOL isEqule;
@property (nonatomic, assign) int result;

- (Calulator *)caculator:(int (^)(int result))calulator;

- (Calulator *)equle:(BOOL (^)(int result))operation;

@end
