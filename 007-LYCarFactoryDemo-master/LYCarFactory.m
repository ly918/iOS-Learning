//
//  LYFactory.m
//  Test1
//
//  Created by LvYuan on 16/7/9.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "LYCarFactory.h"

/**
    工厂
 */
@interface LYCarFactory ()

@end

@implementation LYCarFactory

+ (LYCarFactory *)carWithBrand:(LYCarBrand)brand{
    switch (brand) {
        case LYCarBrandFerrari:
            return [[LYFerrari alloc]init];
            break;
        case LYCarBrandLamborghini:
            return [[LYLamborghini alloc]init];
            break;
        case LYCarBrandBMW:
            return [[LYBMW alloc]init];
            break;
        default:
            break;
    }
}

- (double)price{
    return 0;
}

- (NSString *)brandName{
    return nil;
}

- (void)run{

    NSLog(@"%@ 狂奔中...\n",self.brandName);
    NSLog(@"%.2f 大洋，好便宜啊！！！",self.price);
    [_delegate running:[self class]];
    
}

@end



/**
 *  法拉利
 */
@implementation LYFerrari

- (double)price{
    return 10;
}

- (NSString *)brandName{
    return @"法拉利";
}

@end

/**
 *  兰博基尼
 */
@implementation LYLamborghini

- (double)price{
    return 20;
}

- (NSString *)brandName{
    return @"兰博基尼";
}

@end

/**
 *  宝马
 */
@implementation LYBMW

- (double)price{
    return 30;
}

- (NSString *)brandName{
    return @"宝马";
}

@end



