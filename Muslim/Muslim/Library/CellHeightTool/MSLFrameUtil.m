//
//  MSViewFrameUtil.m
//  MeEngine
//
//  Created by xmload on 12-9-25.
//  Copyright (c) 2012年 xmload. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import "MSLFrameUtil.h"

@implementation MSLFrameUtil

+ (int)setTop:(int)top UI:(UIView *)view{
    CGRect frame = view.frame;
    frame.origin.y = top;
    view.frame = frame;
    return top+frame.size.height;
}

+ (int)setLeft:(int)left UI:(UIView *)view{
    CGRect frame = view.frame;
    frame.origin.x = left;
    view.frame = frame;
    return left+frame.size.width;
}

+ (int)setRight:(int)right UI:(UIView *)view{
    CGRect frame = view.frame;
    frame.origin.x = right-frame.size.width;
    view.frame = frame;
    return right-frame.size.width;
}

+ (int)setHeight:(int)height UI:(UIView *)view{
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
    return height+frame.origin.y;
}

+ (int)setWidth:(int)width UI:(UIView *)view{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
    return width+frame.origin.x;
}

+ (int)getLabHeight:(NSString *)text FontSize:(int)size Width:(int)width {
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return titleSize.height + 5;
}

+ (void)setCornerRadius:(int)width UI:(UIView *)view{
    CALayer *viewLayer = view.layer;
    viewLayer.masksToBounds = YES;
    viewLayer.cornerRadius = width;
}

+ (void)setBorder:(int)width Color:(UIColor *)color UI:(UIView *)view{
    CALayer *viewLayer = view.layer;
    viewLayer.borderWidth = width;
    viewLayer.borderColor = [color CGColor];
    
}
+ (CGPoint)getViewCenter:(UIView *)view{
    CGRect frame = view.frame;
    CGPoint center = CGPointMake(frame.size.width/2, frame.size.height/2);
    return center;
}
@end
