//
//  MPlayerButton.m
//  AVVA
//
//  Created by __无邪_ on 2017/12/13.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "MPlayerButton.h"

@implementation MPlayerButton


- (void)setButtonState:(MPlayerButtonState)buttonState {
    _buttonState = buttonState;
    switch (buttonState) {
        case MPlayerButtonStatePlay:{
            [self animateToType:buttonPausedType];
        }
            break;
        case MPlayerButtonStatePause:{
            [self animateToType:buttonRightTriangleType];
        }
            break;
            
        default:{
            
        }
            break;
    }
}


@end
