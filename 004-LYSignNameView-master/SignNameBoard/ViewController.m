//
//  ViewController.m
//  SignNameBoard
//
//  Created by LvYuan on 16/7/18.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "ViewController.h"
#import "LYDrawBoard.h"
#import "PhotoViewController.h"
#import "UIView+Extension.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LYDrawBoard *pointView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

- (IBAction)previous:(id)sender;
- (IBAction)clear:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)previous:(id)sender {
    [_pointView back];
}

- (IBAction)clear:(id)sender {
    [_pointView clear];
}

//传递image
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    PhotoViewController * pvc = (PhotoViewController *)segue.destinationViewController;
    
    if (_pointView.points.count) {
        pvc.image = [UIView captureWithView:_pointView];
    }
    
}

@end
