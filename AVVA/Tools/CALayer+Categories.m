//
//  CALayer+Categories.m
//  AVVA
//
//  Created by __无邪_ on 2017/12/1.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "CALayer+Categories.h"

@implementation CALayer (Categories)
- (void)setBorderColorFromUIColor:(UIColor *)color{
    self.borderColor = color.CGColor;
}
@end
