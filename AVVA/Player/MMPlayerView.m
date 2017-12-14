//
//  MMPlayerView.m
//  AVVA
//
//  Created by __无邪_ on 2017/12/11.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "MMPlayerView.h"

@interface MMPlayerView ()
@property(nonatomic, strong)UITapGestureRecognizer   *tapGesture;
@property(nonatomic, strong)UITapGestureRecognizer   *tapDoubleGesture;
@property(nonatomic, strong)UIPinchGestureRecognizer *pinchGesture;
@property(nonatomic, strong)UIPanGestureRecognizer   *panGesture;
@end

@implementation MMPlayerView


- (void)awakeFromNib {
    [super awakeFromNib];
    [self configurationGesture];
}

#pragma mark - Action

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:didTap:)]) {
        [self.delegate playerView:self didTap:gesture];
    }
}
- (void)tapDoubleAction:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:didDoubleTap:)]) {
        [self.delegate playerView:self didDoubleTap:gesture];
    }
}
- (void)pinchAction:(UIPinchGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:didPinch:)]) {
        [self.delegate playerView:self didPinch:gesture];
    }
}
- (void)panAction:(UIPanGestureRecognizer *)gesture {
    //CGPoint translation = [gesture translationInView:self];
    //CGPoint velocity = [gesture velocityInView:gesture.view];
    //NSLog(@"===%@",NSStringFromCGPoint(translation));
    //NSLog(@"---%@",NSStringFromCGPoint(velocity));
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        
    }
}

#pragma mark - Gesture

- (void)configurationGesture {
    self.tapGesture = ({
        _tapGesture = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(tapAction:)];
        _tapGesture;
    });
    self.tapDoubleGesture = ({
        _tapDoubleGesture = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(tapDoubleAction:)];
        _tapDoubleGesture.numberOfTapsRequired = 2;
        _tapDoubleGesture;
    });
    self.pinchGesture = ({
        _pinchGesture = [UIPinchGestureRecognizer.alloc initWithTarget:self action:@selector(pinchAction:)];
        _pinchGesture;
    });
    self.panGesture = ({
        _panGesture = [UIPanGestureRecognizer.alloc initWithTarget:self action:@selector(panAction:)];
        _panGesture;
    });
    
    [self addGestureRecognizer:self.tapGesture];
    [self addGestureRecognizer:self.tapDoubleGesture];
    [self addGestureRecognizer:self.pinchGesture];
    [self addGestureRecognizer:self.panGesture];
    [self.tapGesture requireGestureRecognizerToFail:self.tapDoubleGesture];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
