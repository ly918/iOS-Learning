//
//  LYFactory.h
//  Test1
//
//  Created by LvYuan on 16/7/9.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LYCarBrand){
    LYCarBrandFerrari,
    LYCarBrandLamborghini,
    LYCarBrandBMW,
};

@protocol LYCarDelegate <NSObject>

- (void)running:(Class)cls;

@end

@interface LYCarFactory : NSObject

@property (nonatomic,weak) id<LYCarDelegate> delegate;

+ (LYCarFactory *)carWithBrand:(LYCarBrand)brand;

- (void)run;

- (double)price;

- (NSString *)brandName;

@end


/**
 *  法拉利
 */
@interface LYFerrari : LYCarFactory

@end

/**
 *  兰博基尼
 */
@interface LYLamborghini : LYCarFactory

@end

/**
 *  宝马
 */
@interface LYBMW : LYCarFactory

@end
