//
//  MMPlayerView.h
//  AVVA
//
//  Created by __无邪_ on 2017/12/11.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMPlayerView;
@protocol MMPlayerViewGestureDelegate <NSObject>
@optional
- (void)playerView:(MMPlayerView *)playerView didTap:(UITapGestureRecognizer *)gesture;
- (void)playerView:(MMPlayerView *)playerView didDoubleTap:(UITapGestureRecognizer *)gesture;
- (void)playerView:(MMPlayerView *)playerView didPinch:(UIPinchGestureRecognizer *)gesture;
@end

@interface MMPlayerView : UIView
@property(nonatomic, weak) id <MMPlayerViewGestureDelegate> delegate;

@end
