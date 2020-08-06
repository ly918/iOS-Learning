//
//  Macro.h
//  3DTouchTest
//
//  Created by LvYuan on 16/7/21.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#define kHomeSBId @"ViewController"

#define kShowVCId @"ShowViewController"

#define kSegueId @"ToShow"

#define kMAXROW 100

#define SCREENSIZEWidth  [UIScreen mainScreen].bounds.size.width

#define SCREENSIZEHeight  [UIScreen mainScreen].bounds.size.height

#define ControllerForSBId(Id) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:Id]

#define Valid3DTouch self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable


#endif /* Macro_h */
