//
//  PhotoViewController.m
//  SignNameBoard
//
//  Created by LvYuan on 16/7/18.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController()

@property (weak, nonatomic) IBOutlet UIImageView * photo;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)save:(id)sender;

@end

@implementation PhotoViewController

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if (_image) {
        self.photo.image = _image;
        
    }else{
        self.msgLabel.hidden = false;
    
    }
    _saveBtn.enabled = _image?true:false;
}

- (IBAction)save:(id)sender {
    /**
     *  将图片保存到iPhone本地相册
     *  UIImage *image            图片对象
     *  id completionTarget       响应方法对象
     *  SEL completionSelector    方法
     *  void *contextInfo
     */
    UIImageWriteToSavedPhotosAlbum(_image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
 
    NSString * msg = nil;
    
    if (error == nil) {
        msg = @"保存失败";
       
    }else{
        
        msg = @"保存成功";
    }
    
    [self showAlertForMsg:msg];
    
}
- (void)showAlertForMsg:(NSString *)msg{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:action];
    
    [self presentViewController:alertC animated:true completion:nil];
}
@end
