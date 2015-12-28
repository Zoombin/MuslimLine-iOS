//
//  UIView+UIAppearance_Swift.h
//  Demo
//
//  Created by 颜超 on 15/12/28.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewAppearance_Swift)
// appearanceWhenContainedIn: is not available in Swift. This fixes that.
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass;
@end
