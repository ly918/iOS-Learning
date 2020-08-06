//
//  LYPointVIew.h
//  SignName
//
//  Created by Misaya on 16/5/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LYDrawBoard : UIView

//用于存放路径
@property(nonatomic,retain)NSMutableArray * points;
//画线的宽度 这里用IBInspectable来将该属性绑定到IB
@property(nonatomic,assign)IBInspectable CGFloat lineWidth;
//线的颜色
@property(nonatomic,strong)IBInspectable UIColor * color;

//退回到上一步
- (void)back;
//擦除所有
- (void)clear;

@end
