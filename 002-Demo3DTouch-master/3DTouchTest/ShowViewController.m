//
//  ShowViewController.m
//  3DTouchTest
//
//  Created by LvYuan on 16/7/19.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "ShowViewController.h"
#import "PhotoViewController.h"
#import "Macro.h"

@interface ShowViewController()<UIViewControllerPreviewingDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ShowViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _textLabel.text = _text;
    _textLabel.textColor = [UIColor redColor];
    
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:arc4random_uniform(2)?@"meinv.jpg":@"jay.jpg"]];
    _imageView.center = CGPointMake(SCREENSIZEWidth/2.0, SCREENSIZEHeight/2.0+100);
    _imageView.userInteractionEnabled = true;
    [self.view addSubview:_imageView];
    
    //给imageView注册
    if(Valid3DTouch){
        [self registerForPreviewingWithDelegate:self sourceView:_imageView];
    }
}

#pragma mark - 自定义的导航栏用于Peek时显示
UIView * navBar = nil;
- (void)showTitle{
    
    navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENSIZEWidth, 44)];
    [self.view addSubview:navBar];
    
    //line
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREENSIZEWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [navBar addSubview:line];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENSIZEWidth, 44)];
    title.text = self.title;
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    [navBar addSubview:title];
    
}
- (void)hideTitle{
    [navBar removeFromSuperview];
}


#pragma mark - peek 时上滑出现的菜单
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    // 普通样式
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Aciton1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton1");
    }];
    
    //已被选择的样式 后面有个对勾
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Aciton2" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton2");
    }];
    
    //警示样式 红色字样
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Aciton3" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton3");
    }];
    
    NSArray *actions = @[action1,action2,action3];
    return actions;
}


#pragma mark - previewing delegate
// peek 预览
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    
    //预览界面
    PhotoViewController * pvc = [[PhotoViewController alloc]init];
    pvc.image = _imageView.image;
    
    //设置预览视图的比例 可以看出 预览视图的宽高比例 图片的比例是一致的
    pvc.preferredContentSize = CGSizeMake(_imageView.image.size.width, _imageView.image.size.height);
    
    return pvc;
}

//pop 进入
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    PhotoViewController * pvc = (PhotoViewController * )viewControllerToCommit;
    [pvc relayoutSubviews];
    [self showViewController:pvc sender:self];
}

#pragma mark - 压力越大 颜色越黑
- (UIColor *)colorForForce:(CGFloat)force{
    return [UIColor colorWithWhite:1.f - force/6.6667 alpha:1];
}

#pragma mark - 捕捉“压力”值
//需要注意的是 这里的force ”压力“值 并不是以 牛顿 为单位的 物理上的力
//而代表的是一个相对的参考系 我们通过0.666... ~ 6.666... 来模拟压力的小和大
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSArray *arrayTouch = [touches allObjects];
    UITouch *touch = (UITouch *)[arrayTouch lastObject];
    
    NSLog(@"Began压力 ＝ %f",touch.force);
    _textLabel.text = [NSString stringWithFormat:@"压力%f",touch.force];
    self.view.backgroundColor = [self colorForForce:touch.force];
    
}

//按住移动or压力值改变时的回调
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    
    NSArray *arrayTouch = [touches allObjects];
    UITouch *touch = (UITouch *)[arrayTouch lastObject];

    NSLog(@"Moved压力 ＝ %f",touch.force);
    //label显示压力值
    _textLabel.text = [NSString stringWithFormat:@"压力%f",touch.force];
    self.view.backgroundColor = [self colorForForce:touch.force];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSArray *arrayTouch = [touches allObjects];
    UITouch *touch = (UITouch *)[arrayTouch lastObject];
    
    NSLog(@"End压力 ＝ %f",touch.force);
    _textLabel.text = [NSString stringWithFormat:@"压力%f",touch.force];
    self.view.backgroundColor = [self colorForForce:touch.force];

}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSArray *arrayTouch = [touches allObjects];
    
    UITouch *touch = (UITouch *)[arrayTouch lastObject];

    NSLog(@"Cancel压力 ＝ %f",touch.force);
    _textLabel.text = [NSString stringWithFormat:@"压力%f",touch.force];
    
}

@end
