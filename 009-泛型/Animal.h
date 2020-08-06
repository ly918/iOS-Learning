//
//  Animal.h
//  泛型
//
//  Created by LvYuan on 16/7/23.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animal<ObjectType> : NSObject

@property (nonatomic,strong)ObjectType food;

@end
