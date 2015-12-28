//
//  UIView+UIAppearance_Swift.m
//  Demo
//
//  Created by 颜超 on 15/12/28.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

#import "UIView+UIAppearance_Swift.h"

@implementation UIView (UIViewAppearance_Swift)
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass {
    return [self appearanceWhenContainedIn:containerClass, nil];
}
@end
