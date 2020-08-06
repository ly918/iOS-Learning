//
//  ViewController.m
//  LinkageTableView
//
//  Created by LvYuan on 2017/5/5.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * goodsList;
    BOOL _relate;
}
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _relate = YES;
    goodsList = @[
                      @{@"title" : @"精选特卖",
                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤", @"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤"]
                        },
                      @{@"title" : @"饭后(含有茶点)",
                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤"]
                        },
                      @{@"title" : @"茶点(含有茶点)",
                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤"]
                        },
                      @{@"title" : @"素材水果拼盘",
                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",]
                        },
                      @{@"title" : @"水果拼盘生鲜果",
                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤",]
                        },
                      @{@"title" : @"拼盘",
                        @"list" : @[@"甜点组合"]
                        },
                      @{@"title" : @"烤鱼盘",
                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤"]
                        },
                      @{@"title" : @"饮料",
                        @"list": @[@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤"]
                        },
                      @{@"title": @"小吃",
                        @"list": @[@"甜点组合", @"毛肚"]
                        },
                      @{@"title" : @"作料",
                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤"]
                        },
                      @{@"title" : @"主食",
                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤"]
                        },
                      ];
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==_leftTableView) {
        return 1;
    }
    return goodsList.count;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_leftTableView) {
        return goodsList.count;
    }
    return [[goodsList[section] objectForKey:@"list"] count];
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (tableView==_leftTableView) {
        //分类标题
        cell.textLabel.text = [goodsList[indexPath.row] objectForKey:@"title"];
    }else{
        //商品标题
        cell.textLabel.text = [[goodsList[indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row];
    }
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_leftTableView) {
        return 80;
    }
    return 100;
}

//分区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView==_rightTableView) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _rightTableView.bounds.size.width, 30)];
        view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
        UILabel * label = [[UILabel alloc] initWithFrame:view.bounds];
        [view addSubview:label];
        label.text = [goodsList[section] objectForKey:@"title"];
        return view;
    }
    return nil;
}

//分区头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_leftTableView) {
        return CGFLOAT_MIN;
    }
    return 30;
}

//脚视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return 0;
    } else {
        //重要
        return CGFLOAT_MIN;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        _relate = NO;
        //选择该行，并自动滚动至列表中心区域
        [self.leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        //右侧滚动至相应分区
        [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else {
        //取消选中
        [self.rightTableView deselectRowAtIndexPath:indexPath animated:NO];
        
    }
}

//分区头即将显示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (_relate) {
        //获取显示在最顶部的cell的分区数
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
        if (tableView == self.rightTableView) {
            //滚动该分区对应的标题至列表中部
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

//分区头已经结束显示
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    if (_relate) {
        //获取显示在最顶部的cell的分区数
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
        if (tableView == self.rightTableView) {
            //滚动该分区对应的标题至列表中部
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

//已经结束减速
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _relate = YES;
}

@end
