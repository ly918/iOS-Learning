//
//  LYUser.m
//  FMDB
//
//  Created by LvYuan on 16/8/5.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "LYUser.h"

@implementation LYUser
- (NSString *)description{
    return [NSString stringWithFormat:@"{Id = %@ name = %@ tel = %@}",self.Id,self.name,self.tel];
}
@end
