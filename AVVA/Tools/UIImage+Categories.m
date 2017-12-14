//
//  UIImage+Categories.m
//  AVVA
//
//  Created by __无邪_ on 2017/12/14.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "UIImage+Categories.h"

@implementation UIImage (Categories)
+ (UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1.0f);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
