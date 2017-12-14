//
//  UIColor+Categories.h
//  AVVA
//
//  Created by __无邪_ on 2017/12/11.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Categories)

+ (UIColor *)colorFromHexRGB: (NSString *)color;
+ (UIColor *)colorFromHexRGB: (NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *)RandomColor;

//渐变左右方向
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 width:(int)width;

// 自上而下
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 height:(int)height;

@end
