//
//  MMPlayerButton.m
//  AVVA
//
//  Created by __无邪_ on 2017/12/13.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "MMPlayerButton.h"

#define kLineWidth 4

@interface MMPlayerButton ()
@property(nonatomic) CALayer *leftLayer;
@property(nonatomic) CALayer *middleLayer;
@property(nonatomic) CALayer *rightLayer;
@property(nonatomic) BOOL showStop;
@end

@implementation MMPlayerButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.playState = MMPlayerButtonStatePlay;
        [self setup];
    }
    return self;
}

#pragma mark - Instance methods

- (void)tintColorDidChange{
    CGColorRef color = [self.tintColor CGColor];
    self.leftLayer.backgroundColor = color;
    self.middleLayer.backgroundColor = color;
    self.rightLayer.backgroundColor = color;
}
- (void)setPlayState:(MMPlayerButtonState)playState {
    _playState = playState;
    switch (playState) {
        case MMPlayerButtonStatePlay:{
            [self animate2ll];
        }
            break;
        case MMPlayerButtonStatePause:{
            [self animate2triangle];
        }
            break;
            
        default:{
            
        }
            break;
    }
}

#pragma mark - Private Instance methods

- (void)animate2ll{
    [self removeAllAnimations];
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat lineHeight = height * 2 / 3.0;
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.duration = 0.3;
    fadeAnimation.toValue = @1;
    
    CABasicAnimation *positionMiddleAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionMiddleAnimation.duration = 0.3;
    positionMiddleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((width - kLineWidth * 2)/3.0 * 2 + kLineWidth + kLineWidth/2.0, (height - lineHeight)/2.0 + lineHeight/2.0)];
    positionMiddleAnimation.removedOnCompletion = NO;
    positionMiddleAnimation.fillMode = kCAFillModeBoth;
    
    CABasicAnimation *positionBottomAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionBottomAnimation.duration = 0.3;
    positionBottomAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake((width - kLineWidth * 2)/3.0 * 2 + kLineWidth + kLineWidth/2.0, (height - lineHeight)/2.0 + lineHeight/2.0)];
    positionBottomAnimation.removedOnCompletion = NO;
    positionBottomAnimation.fillMode = kCAFillModeBoth;
    
    CASpringAnimation *transformMiddleAnimation = [CASpringAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformMiddleAnimation.toValue = @(0);
    transformMiddleAnimation.speed = 2;
    transformMiddleAnimation.damping = 20;   //阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快。默认值为10
    transformMiddleAnimation.stiffness = 500; //刚度系数，刚度系数越大，产生形变的力就越大，运动越快。
    transformMiddleAnimation.mass = 5;          //质量
    transformMiddleAnimation.initialVelocity = 10; //初始速度
    transformMiddleAnimation.removedOnCompletion = NO;
    transformMiddleAnimation.fillMode = kCAFillModeBoth;
    transformMiddleAnimation.duration = transformMiddleAnimation.settlingDuration;
    
    CASpringAnimation *transformBottomAnimation = [CASpringAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformBottomAnimation.toValue = @(0);
    transformBottomAnimation.speed = 2;
    transformBottomAnimation.damping = 20;   //阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快。默认值为10
    transformBottomAnimation.stiffness = 500; //刚度系数，刚度系数越大，产生形变的力就越大，运动越快。
    transformBottomAnimation.mass = 5;          //质量
    transformBottomAnimation.initialVelocity = 10; //初始速度
    transformBottomAnimation.removedOnCompletion = NO;
    transformBottomAnimation.fillMode = kCAFillModeBoth;
    transformBottomAnimation.duration = transformBottomAnimation.settlingDuration;
    
    [self.middleLayer addAnimation:positionMiddleAnimation forKey:@"positionMiddleAnimation"];
    [self.middleLayer addAnimation:transformMiddleAnimation forKey:@"rotateMiddleAnimation"];
    [self.leftLayer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
    [self.rightLayer addAnimation:positionBottomAnimation forKey:@"positionBottomAnimation"];
    [self.rightLayer addAnimation:transformBottomAnimation forKey:@"rotateBottomAnimation"];
}

- (void)animate2triangle{ /// 1>
    [self removeAllAnimations];
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat lineHeight = height * 2 / 3.0;
    
    CGPoint top = CGPointMake((width - kLineWidth * 2)/3.0 * 2 + kLineWidth/2.0, (height - lineHeight));
    CGPoint bottom = CGPointMake((width - kLineWidth * 2)/3.0 * 2 + kLineWidth/2.0, lineHeight);
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.duration = 0.3;
    fadeAnimation.toValue = @0.75;
    
    CABasicAnimation *positionMiddleAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionMiddleAnimation.toValue = [NSValue valueWithCGPoint:top];
    positionMiddleAnimation.duration = 0.3;
    positionMiddleAnimation.removedOnCompletion = NO;
    positionMiddleAnimation.fillMode = kCAFillModeBoth;
    
    CABasicAnimation *positionBottomAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionBottomAnimation.toValue = [NSValue valueWithCGPoint:bottom];
    positionBottomAnimation.duration = 0.3;
    positionBottomAnimation.removedOnCompletion = NO;
    positionBottomAnimation.fillMode = kCAFillModeBoth;
    
    CASpringAnimation *transformMiddleAnimation = [CASpringAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformMiddleAnimation.toValue = @(-M_PI/3);
    transformMiddleAnimation.speed = 2;
    transformMiddleAnimation.damping = 20;   //阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快。默认值为10
    transformMiddleAnimation.stiffness = 500; //刚度系数，刚度系数越大，产生形变的力就越大，运动越快。
    transformMiddleAnimation.mass = 5;          //质量
    transformMiddleAnimation.initialVelocity = 10; //初始速度
    transformMiddleAnimation.removedOnCompletion = NO;
    transformMiddleAnimation.fillMode = kCAFillModeBoth;
    transformMiddleAnimation.duration = transformMiddleAnimation.settlingDuration;
    
    CASpringAnimation *transformBottomAnimation = [CASpringAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformBottomAnimation.toValue = @(M_PI/3.0);
    transformBottomAnimation.speed = 2;
    transformBottomAnimation.damping = 20;   //阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快。默认值为10
    transformBottomAnimation.stiffness = 500; //刚度系数，刚度系数越大，产生形变的力就越大，运动越快。
    transformBottomAnimation.mass = 5;          //质量
    transformBottomAnimation.initialVelocity = 10; //初始速度
    transformBottomAnimation.removedOnCompletion = NO;
    transformBottomAnimation.fillMode = kCAFillModeBoth;
    transformBottomAnimation.duration = transformBottomAnimation.settlingDuration;
    
    [self.middleLayer addAnimation:positionMiddleAnimation forKey:@"positionMiddleAnimation"];
    [self.middleLayer addAnimation:transformMiddleAnimation forKey:@"rotateMiddleAnimation"];
    [self.leftLayer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
    [self.rightLayer addAnimation:positionBottomAnimation forKey:@"positionBottomAnimation"];
    [self.rightLayer addAnimation:transformBottomAnimation forKey:@"rotateBottomAnimation"];
}

- (void)touchUpInsideHandler:(MMPlayerButton *)sender{
    if (self.showStop) {
        [self animate2ll];
    } else {
        [self animate2triangle];
    }
    self.showStop = !self.showStop;
}

- (void)setup{
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat lineHeight = height * 2 / 3.0;
    CGFloat cornerRadius =  kLineWidth/2.0;
    CGColorRef color = [self.tintColor CGColor];
    
    self.leftLayer = [CALayer layer];
    self.leftLayer.frame = CGRectMake((width - kLineWidth * 2)/3.0, (height - lineHeight)/2.0, kLineWidth, lineHeight);
    self.leftLayer.cornerRadius = cornerRadius;
    self.leftLayer.backgroundColor = color;
    
    self.middleLayer = [CALayer layer];
    self.middleLayer.frame = CGRectMake((width - kLineWidth * 2)/3.0 * 2 + kLineWidth, (height - lineHeight)/2.0, kLineWidth, lineHeight);
    self.middleLayer.cornerRadius = cornerRadius;
    self.middleLayer.backgroundColor = color;
    
    self.rightLayer = [CALayer layer];
    self.rightLayer.frame = CGRectMake((width - kLineWidth * 2)/3.0 * 2 + kLineWidth, (height - lineHeight)/2.0, kLineWidth, lineHeight);
    self.rightLayer.cornerRadius = cornerRadius;
    self.rightLayer.backgroundColor = color;
    
    [self.layer addSublayer:self.leftLayer];
    [self.layer addSublayer:self.middleLayer];
    [self.layer addSublayer:self.rightLayer];
    
    [self addTarget:self action:@selector(touchUpInsideHandler:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)removeAllAnimations{
    [self.leftLayer removeAllAnimations];
    [self.middleLayer removeAllAnimations];
    [self.rightLayer removeAllAnimations];
}

@end
