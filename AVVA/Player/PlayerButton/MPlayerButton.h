//
//  MPlayerButton.h
//  AVVA
//
//  Created by __无邪_ on 2017/12/13.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "VBFPopFlatButton.h"

typedef NS_ENUM(NSUInteger, MPlayerButtonState) {
    MPlayerButtonStatePause = 0,
    MPlayerButtonStatePlay
};

@interface MPlayerButton : VBFPopFlatButton

@property (nonatomic, assign)MPlayerButtonState buttonState;


@end
