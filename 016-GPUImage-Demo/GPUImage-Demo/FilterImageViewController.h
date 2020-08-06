//
//  FilterImageViewController.h
//  GPUImage-Demo
//
//  Created by Luca on 2018/9/26.
//  Copyright © 2018年 Luca. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterImageViewController : UIViewController

@property(nonatomic, strong)id filter;
@property(nonatomic, strong)UIImage *image;

@end

NS_ASSUME_NONNULL_END
