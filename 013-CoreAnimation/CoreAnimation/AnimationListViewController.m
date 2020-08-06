
//
//  AnimationListViewController.m
//  CoreAnimation
//
//  Created by LvYuan on 16/7/30.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "AnimationListViewController.h"
#import "AnimationViewController.h"
@interface AnimationListViewController ()

@end

@implementation AnimationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSArray *)titles{
    return @[@"自定义动画",
             @"关键帧动画",
             @"使用路径制作动画"];
}

- (NSArray *)descs{
    return @[@"CABasicAnimation",
             @"CAKeyframeAnimation",
             @"CAKeyframeAnimation"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self titles].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self titles] objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = [[self descs] objectAtIndex:indexPath.row];
    
    return cell;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    AnimationViewController * avc = (AnimationViewController *)segue.destinationViewController;
    avc.row = [[self.tableView indexPathForSelectedRow] row];
    
}


@end
