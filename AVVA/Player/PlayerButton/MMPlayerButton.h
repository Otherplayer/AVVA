//
//  MMPlayerButton.h
//  AVVA
//
//  Created by __无邪_ on 2017/12/13.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MMPlayerButtonState) {
    MMPlayerButtonStatePause = 0,
    MMPlayerButtonStatePlay
};

@interface MMPlayerButton : UIControl

@property(nonatomic,assign) MMPlayerButtonState playState;

@end
