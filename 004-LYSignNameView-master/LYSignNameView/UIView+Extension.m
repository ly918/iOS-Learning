//
//  UIView+Extension.m
//  SignName
//
//  Created by Misaya on 16/5/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView(Extension)

+(UIImage*)captureWithView:(UIView *)view
{
    /**
     *  开启上下文
     */
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    
    /**
     *  将控制器的view的layer渲染到上下文
     */
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    /**
     *  取出图片
     */
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    /**
     *  结束上下文
     */
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
