//
//  EditViewController.m
//  FMDB
//
//  Created by LvYuan on 16/8/5.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "EditViewController.h"
#import "LYUser.h"

#import "LYDBManager.h"

@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UIView *userLeftView;
@property (weak, nonatomic) IBOutlet UIView *pasLeftView;

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pasField;
@property (weak, nonatomic) IBOutlet UIButton *btn;
- (IBAction)action:(id)sender;


@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userField.leftView = _userLeftView;
    _userField.leftViewMode = UITextFieldViewModeAlways;
    
    _pasField.leftView = _pasLeftView;
    _pasField.leftViewMode = UITextFieldViewModeAlways;
    
    [self setUp];
}

- (void)setUp{
    
    NSString * title = nil;
    NSString * btnTip = nil;
    if (self.user) {
        title = @"编辑";
        btnTip = @"保存";
        _userField.text = _user.name;
        _pasField.text = _user.tel;
    }else{
        title = @"添加";
        btnTip = @"添加";
    }
    self.title = title;
    [self.btn setTitle:btnTip forState:UIControlStateNormal];
}


- (IBAction)action:(id)sender {
    
    if (!_userField.text.length
        ||!_pasField.text.length) {
        return;
    }
    
    if (self.user) {
        [self updateUser];
    }else{
        [self insertNewUser];
    }
    [self.navigationController popViewControllerAnimated:true];
    
}

- (NSString *)newID{
    NSArray * users= [LYDBManager manager].users;
    __block NSString * tmpID = @"1";
    [users enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj Id].intValue > tmpID.intValue) {
            tmpID = [obj Id];
        }
    }];
    return @(tmpID.intValue+1).stringValue;
}

/**
 *  添加
 */
- (void)insertNewUser{
    
    LYUser * newUser = [[LYUser alloc]init];
    newUser.name = _userField.text;
    newUser.tel = _pasField.text;
    newUser.Id = [self newID];
    NSLog(@"NEW ID %@",newUser.Id);
    [[LYDBManager manager]insertNewUser:newUser];
    
}

/**
 *  编辑
 */
- (void)updateUser{
    self.user.name = _userField.text;
    self.user.tel = _pasField.text;
    
    [[LYDBManager manager]updateUser:self.user];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

@end
