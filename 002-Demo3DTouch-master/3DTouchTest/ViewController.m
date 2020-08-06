//
//  ViewController.m
//  3DTouchTest
//
//  Created by LvYuan on 16/7/19.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "ViewController.h"
#import "ShowViewController.h"
#import "Macro.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return kMAXROW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self selectedTextForRow:indexPath.row];
    
    if (Valid3DTouch) {
        //给这个cell注册3dTouch预览功能
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath * indexPath = [_tableView indexPathForSelectedRow];
    ShowViewController * showVC = (ShowViewController *)segue.destinationViewController;
    showVC.text = [self selectedTextForRow:indexPath.row];
    showVC.title = showVC.text;
}

- (NSString *)selectedTextForRow:(NSInteger)row{
    return [NSString stringWithFormat:@"第%02d行",(int)row];
}


#pragma mark - previewing delegate
// peek 预览
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    //按压的行
    NSIndexPath * indexPath = [_tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    //预览界面
    ShowViewController * showVC = (ShowViewController *)ControllerForSBId(kShowVCId);
    showVC.title = @"我是按进来的";
    showVC.text = [self selectedTextForRow:indexPath.row];
    //显示自定义的导航栏
    [showVC showTitle];
    
    return showVC;
}
//pop 进入
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    ShowViewController * showVC = (ShowViewController *)viewControllerToCommit;
    //隐藏自定义的导航栏
    [showVC hideTitle];
    [self showViewController:viewControllerToCommit sender:self];
}
@end
