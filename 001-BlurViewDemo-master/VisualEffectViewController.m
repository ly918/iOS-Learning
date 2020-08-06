//
//  VisualEffectViewController.m
//  毛玻璃
//
//  Created by 米明 on 15/5/5.
//  Copyright (c) 2015年 米明. All rights reserved.
//

#import "VisualEffectViewController.h"

@interface VisualEffectViewController ()

@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;


@property(nonatomic)int index;


@end

@implementation VisualEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"b1.jpg"]];
    
    _index=1;

    _slider.value=1.f;
    
    _valueLabel.text=[NSString stringWithFormat:@"alpha :%.2f",_slider.value];
    
    // Do any additional setup after loading the view.
}
- (IBAction)changeValue:(id)sender {
    
    _effectView.alpha=_slider.value;
    
    _valueLabel.text=[NSString stringWithFormat:@"alpha :%.2f",_slider.value];
    
    _effectView.alpha=_slider.value;
}


- (IBAction)changeBGImage:(id)sender {
    
    if (_index==3) {
        _index=1;
    }else{
        _index++;
    }

     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"b%d.jpg",_index]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
