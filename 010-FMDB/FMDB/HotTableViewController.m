//
//  HotTableViewController.m
//  FMDB
//
//  Created by LvYuan on 16/8/5.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "HotTableViewController.h"
#import "LYUser.h"
#import "EditViewController.h"
#import "LYDBManager.h"

@interface HotTableViewController ()

@property (nonatomic,retain) NSMutableArray * users;

@end

@implementation HotTableViewController

- (NSMutableArray *)users{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.rowHeight = 60;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.users removeAllObjects];
    [self readUsers];
}

- (void)readUsers{
    _users = [LYDBManager manager].users.mutableCopy;
    [self.tableView reloadData];
    NSLog(@"Users %@",_users);
}


//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    EditViewController * evc = (EditViewController *)segue.destinationViewController;
    
    NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
    
    LYUser * user = nil;
    
    if (indexPath) {
        user = [_users objectAtIndex:indexPath.row];
    }
    
    evc.user = user;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    LYUser * user = _users[indexPath.row];
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel * label = obj;
        if (obj.tag == 1) {
            label.text = user.name;
        }
        else if (obj.tag == 2) {
            label.text = user.Id;
        }
        else if (obj.tag == 3) {
            label.text = user.tel;
        }
    }];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[LYDBManager manager] deleteUser:_users[indexPath.row]];
        [_users removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



@end
