//
//  UIView+Categories.m
//  AVVA
//
//  Created by __无邪_ on 2017/12/1.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "UIView+Categories.h"

@implementation UIView (Categories)

- (void)showTip:(NSString *)message dealy:(NSTimeInterval)dealy{
    // Make toast with a custom style
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageFont = [UIFont systemFontOfSize:14];
    style.messageColor = [UIColor whiteColor];
    style.messageAlignment = NSTextAlignmentCenter;
    style.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    
    [self makeToast:message
           duration:dealy
           position:CSToastPositionTop
              style:style];
}


@end
