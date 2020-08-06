//
//  ViewController.m
//  ApplePayTest
//
//  Created by LvYuan on 16/7/26.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "ViewController.h"

//引入PassKit
@import PassKit;

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *payView;

@end


@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1 判断当前设备是否支持applePay
    if ([PKPaymentAuthorizationViewController canMakePayments]==NO) {
        
        NSLog(@"当前设备不支持ApplePay");
        
    }else if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay]]) {//2 判断是否添加了相应的银行卡 去设置按钮
        
        //不支持 去设置
        PKPaymentButton * jump = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleWhiteOutline];
        
        [jump addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
        
        jump.frame = self.payView.bounds;
        
        [self.payView addSubview:jump];
        
    }else{//3 添加了相应的银行卡 显示购买按钮
        
        //支持 购买
        PKPaymentButton * buy = [PKPaymentButton buttonWithType:PKPaymentButtonTypeBuy style:PKPaymentButtonStyleBlack];
        
        [buy addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
        
        buy.frame = self.payView.bounds;
        
        [self.payView addSubview:buy];
        
    }
    
    
}


#pragma mark - 跳转
- (void)jump:(id)sender{
    
    PKPassLibrary * pk = [[PKPassLibrary alloc]init];
    
    [pk openPaymentSetup];
    
}

#pragma mark - 购买请求
- (void)buy:(id)sender{
    
    //开始购买
    //1 创建一个支付请求
    PKPaymentRequest * request = [[PKPaymentRequest alloc]init];
    
    //2 配置支付请求
    // 配置商家id
    request.merchantIdentifier = @"merchant.com.occode.ApplePayTest";
    
    //国家代码
    request.countryCode = @"CN";
    //货币代码
    request.currencyCode = @"CNY";
    
    //支持的支付网络
    request.supportedNetworks = @[PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
    
    //支付的处理方式
    request.merchantCapabilities = PKMerchantCapability3DS;
    
    //3 商品列表
    NSDecimalNumber * number = [NSDecimalNumber decimalNumberWithString:@"6000.0"];
    PKPaymentSummaryItem * item = [PKPaymentSummaryItem summaryItemWithLabel:@"苹果6S" amount:number];
    
    NSDecimalNumber * number11 = [NSDecimalNumber decimalNumberWithString:@"6800.0"];
    PKPaymentSummaryItem * item11 = [PKPaymentSummaryItem summaryItemWithLabel:@"苹果6S+" amount:number11];
    
    NSDecimalNumber * number1 = [NSDecimalNumber decimalNumberWithString:@"12800.0"];
    PKPaymentSummaryItem * item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"魔笛" amount:number1];
    
    request.paymentSummaryItems = @[item,item11,item1];
    
    //4 附加项
    //是否显示发票收货地址 显示哪些选项
    request.requiredBillingAddressFields = PKAddressFieldAll;
    
    //是否显示快递地址
    request.requiredShippingAddressFields = PKAddressFieldAll;
    
    //配置快递方式
    NSDecimalNumber * number2 = [NSDecimalNumber decimalNumberWithString:@"12.0"];
    PKShippingMethod * m1 = [PKShippingMethod summaryItemWithLabel:@"顺丰快递" amount:number2];
    m1.identifier = @"Shunfeng";
    m1.detail = @"24小时送货上门";
    
    NSDecimalNumber * number3 = [NSDecimalNumber decimalNumberWithString:@"10.0"];
    PKShippingMethod * m2 = [PKShippingMethod summaryItemWithLabel:@"韵达快递" amount:number3];
    m2.identifier = @"Yunda";
    m2.detail = @"送货上门";
    request.shippingMethods = @[m1,m2];
    
    //配置快递类型
    request.shippingType = PKShippingTypeStorePickup;
    
    //5 附加信息
    request.applicationData = [@"buyId=12345" dataUsingEncoding:NSUTF8StringEncoding];
    
    //6 验证用户的支付授权
    PKPaymentAuthorizationViewController * avc = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:request];
    
    avc.delegate = self;
    
    [self presentViewController:avc animated:true completion:nil];
    
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate

/**
 *  用户授权成功 就会调用这个方法
 *
 *  @param controller 授权控制器
 *  @param payment    支付对象
 *  @param completion 系统给定的回调代码块 需要执行它 来告诉 系统当前的支付状态是否支付成功
 */

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion{

    NSLog(@"TOKEN transactionIdentifier: %@",payment.token.transactionIdentifier);
    NSLog(@"TOKEN PayData :%@",payment.token.paymentData);
    
    //拿到支付信息 给服务器处理 服务器会返回一个状态 告诉客户端 是否支付成功 有客户端进行处理
    
    BOOL isSuccess = YES;
    
    if (isSuccess) {
        completion(PKPaymentAuthorizationStatusSuccess);
    }else{
        completion(PKPaymentAuthorizationStatusFailure);
    }
    
}

//当用户授权成功 或者 取消授权
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    
    NSLog(@"授权结束");
    [controller dismissViewControllerAnimated:true completion:nil];
    
}





@end
