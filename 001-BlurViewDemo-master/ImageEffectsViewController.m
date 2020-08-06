//
//  ImageEffectsViewController.m
//  毛玻璃
//
//  Created by 米明 on 15/5/5.
//  Copyright (c) 2015年 米明. All rights reserved.
//

#import "ImageEffectsViewController.h"
#import "UIImage+ImageEffects.h"


//风格
typedef enum NSInteger{
    BlurStyleNone=0,//无
    BlurStyleLight,
    BlurStyleExtraLight,
    BlurStyleDark,
    BlurStyleTintEffect,
    BlurStyleCustom
}BlurStyle;

@interface ImageEffectsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UIButton *changeStyleButton;


@property(nonatomic)BlurStyle blurStyle;
@property(nonatomic)float value;
@property(nonatomic,retain)UIColor * arcColor;
@property(nonatomic)CGFloat r;
@property(nonatomic)CGFloat g;
@property(nonatomic)CGFloat b;
@property(nonatomic,retain)UIImage * defaultImage;

@end

@implementation ImageEffectsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //初始化
    _blurStyle=BlurStyleNone;
    _defaultImage=_imgView.image;
    _value=0;
    _styleLabel.text=@"None";
    
    _stepper.minimumValue=0;
    _stepper.maximumValue=50;
    [_stepper setStepValue:1];
    _stepper.value=_value;
    _stepper.hidden=YES;
    _stepper.continuous=YES;//连续变化

    // Do any additional setup after loading the view.
}

//更改样式
- (IBAction)changeStyle:(id)sender {
   
    if (_blurStyle==BlurStyleCustom) {
        _blurStyle=BlurStyleNone;
    }else{
        _blurStyle++;
    }
    
    _r=arc4random()%255/255.f;
    _g=arc4random()%255/255.f;
    _b=arc4random()%255/255.f;

    _arcColor=[UIColor colorWithRed:_r green:_g blue:_b alpha:0.5];
    
    NSArray *styles = @[@"None",@"LightEffect",@"ExtraLightEffect",@"DarkEffect",[NSString stringWithFormat:@"TintEffectWithColor:\nR:%.2f G:%.2f B:%.2f A:0.5",_r,_g,_b],[NSString stringWithFormat:@"Radius:\n%.2f \ntintColor:\nR:%.2f G:%.2f B:%.2f A:0.5",_value,_r,_g,_b]];
    
    _styleLabel.text=styles[_blurStyle];
    
    if (_blurStyle!=BlurStyleCustom) {
        _stepper.hidden=YES;

    }else{
        _stepper.hidden=NO;
    }
    
    //_blurStyle 代表风格
    //_defaultImage 是我们想要处理的图片
    //_value 模糊度
    //_arcColor 随机生成的颜色
    switch (_blurStyle) {
        case BlurStyleNone://原图
            _imgView.image=_defaultImage;
            break;
        case BlurStyleLight://透白风
            _imgView.image=[_defaultImage applyLightEffect];
            break;
        case BlurStyleExtraLight://亮白风
            _imgView.image=[_defaultImage applyExtraLightEffect];
            break;
        case BlurStyleDark://黑暗风
            _imgView.image=[_defaultImage applyDarkEffect];
            break;
        case BlurStyleTintEffect://自定义颜色
            _imgView.image= [_defaultImage applyTintEffectWithColor:_arcColor];
            break;
        case BlurStyleCustom://自定义颜色和模糊度
            _imgView.image=[_defaultImage applyBlurWithRadius:_value tintColor:_arcColor  saturationDeltaFactor:1.8 maskImage:nil];
            break;
        default:
            break;
    }
    
}
//改变模糊度
- (IBAction)changeRadius:(id)sender {
    
    _value=_stepper.value;
    
    _styleLabel.text=[NSString stringWithFormat:@"Radius:\n%.2f \ntintColor:\nR:%.2f G:%.2f B:%.2f A:0.5",_value,_r,_g,_b];
    
    _imgView.image=[_defaultImage applyBlurWithRadius:_value tintColor:_arcColor saturationDeltaFactor:1.8 maskImage:nil];
    
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
