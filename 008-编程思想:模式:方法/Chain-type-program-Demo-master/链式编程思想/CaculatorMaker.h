//
//  CaculatorMaker.h
//  链式编程思想
//
//  Created by LvYuan on 16/7/25.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaculatorMaker : NSObject

@property (nonatomic, assign) int result;

//加法
- (CaculatorMaker *(^)(int))add;
- (CaculatorMaker *(^)(int))sub;
- (CaculatorMaker *(^)(int))muilt;
- (CaculatorMaker *(^)(int))divide;

@end
