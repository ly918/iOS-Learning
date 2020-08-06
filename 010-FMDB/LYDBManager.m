//
//  LYDBManager.m
//  FMDB
//
//  Created by LvYuan on 16/8/13.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "LYDBManager.h"
#import "FMDB.h"
#import "LYUser.h"
static LYDBManager * m = nil;

@interface LYDBManager ()

@property (nonatomic, strong) NSString * dbPath;
@property (nonatomic, strong) FMDatabase * db;
- (void)open;

@end

@implementation LYDBManager

+ (LYDBManager *)manager{
    if (!m) {
        m = [[LYDBManager alloc]init];
    }
    return m;
}

- (instancetype)init{
    if (self = [super init]) {
        [self open];
        [self createTable];
    }
    return self;
}

- (NSString *)dbPath{
    NSString * cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true).firstObject;
    _dbPath = [cachePath stringByAppendingPathComponent:@"User.sqlite"];
    return _dbPath;
}

- (FMDatabase *)db{
    if (!_db) {
        _db = [FMDatabase databaseWithPath:self.dbPath];
    }
    return _db;
}

- (void)open{
    bool ret = [self.db open];
    if (ret) {
        NSLog(@"数据库打开成功");
    }else{
        NSLog(@"数据库打开失败");
    }
}

- (void)close{
    bool ret = [self.db close];
    if (ret) {
        NSLog(@"数据库关闭成功");
    }else{
        NSLog(@"数据库关闭失败");
    }
}

- (void)createTable{
    bool created = [self.db executeUpdate:@"CREATE TABLE UserList (name text, tel text, Id text)"];
    if (created) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表失败");
    }
}

//insert
- (void)insertNewUser:(LYUser *)user{
    [self open];
    bool insert = [self.db executeUpdate:@"INSERT INTO UserList (name, tel, Id) VALUES (?,?,?)",user.name,user.tel,user.Id];
    if (insert) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
    [self close];
}

//delete
- (void)deleteUser:(LYUser *)user{
    [self open];
    bool delete = [_db executeUpdate:@"DELETE FROM UserList where Id like ?",user.Id];
    if (delete) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
    [self close];
}


//update
- (void)updateUser:(LYUser *)user{
    [self open];
    bool update = [_db executeUpdate:@"UPDATE UserList SET name = ? , tel = ?  where Id = ?",user.name,user.tel,user.Id];
    if (update) {
        NSLog(@"更新数据成功");
    }else{
        NSLog(@"更新数据失败");
    }
    [self close];
}

- (NSMutableArray *)users{
    
    [self open];
    NSMutableArray * users = [NSMutableArray array];
    
    FMResultSet * set = [self.db executeQuery:@"SELECT * FROM UserList"];
    
    while ([set next]) {
        LYUser * user = [[LYUser alloc]init];
        user.name = [set stringForColumn:@"name"];
        user.tel = [set stringForColumn:@"tel"];
        user.Id = [set stringForColumn:@"Id"];
        [users addObject:user];
    }
    
    [self close];
    return users;
}

@end
