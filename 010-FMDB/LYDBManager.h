//
//  LYDBManager.h
//  FMDB
//
//  Created by LvYuan on 16/8/13.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYUser;
@interface LYDBManager : NSObject

+ (LYDBManager *)manager;

- (void)insertNewUser:(LYUser *)user;
- (void)deleteUser:(LYUser *)user;
- (void)updateUser:(LYUser *)user;
- (NSMutableArray *)users;

@end
