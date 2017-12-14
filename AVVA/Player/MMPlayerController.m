//
//  MMPlayerController.m
//  AVVA
//
//  Created by __无邪_ on 2017/11/30.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "MMPlayerController.h"
#import <VideoToolbox/VideoToolbox.h>
#import <MobileVLCKit/MobileVLCKit.h>
#import "FileHelper.h"
#import "MMPlayerView.h"
#import "MPlayerButton.h"

@interface MMPlayerController ()<VLCMediaPlayerDelegate,MMPlayerViewGestureDelegate>
@property (nonatomic, strong) VLCMediaPlayer *player;

@property (weak, nonatomic) IBOutlet MMPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIView *playerHeaderView;
@property (weak, nonatomic) IBOutlet UIView *playerFooterView;

@property (weak, nonatomic) IBOutlet UILabel  *labTime;
@property (weak, nonatomic) IBOutlet UILabel  *labRemainingTime;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UISlider *sliderProgress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerViewHeaderConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerViewFooterConstraintHeight;
@property (weak, nonatomic) IBOutlet MPlayerButton *btnPlayer;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;

@property (nonatomic, assign) BOOL controlViewISShowing;
@property (nonatomic, assign) BOOL progressISAdjusting;

@end

@implementation MMPlayerController

#pragma mark - lifecircle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self install];
    [self configuration];
    [self addObserver];
    [self addNotification];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.player willPlay];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player play];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeObserver];
    [self removeNotification];
    [self.player stop];
    [self.player setDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    self.player = nil;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)statusAction:(id)sender {
    NSString *status = VLCMediaPlayerStateToString(self.player.state);
    status = [status stringByReplacingOccurrencesOfString:@"VLCMediaPlayerState" withString:@"状态: "];
    [self.view showTip:status dealy:1.5];
}

- (IBAction)startAction:(id)sender {
    if (self.player.isPlaying) {
        [self.player pause];
    }else{
        if (self.player.state == VLCMediaPlayerStateStopped || self.player.state == VLCMediaPlayerStateError) {
            [self backAction:nil];
        }else {
            [self.player play];
        }
    }
}
//退 10秒钟
- (IBAction)shortJumpBackwardAction:(id)sender {
    [self.player shortJumpBackward];
    if (!self.player.isPlaying) {
        [self.player play];
    }
}
//进 10秒钟
- (IBAction)shortJumpForwardAction:(id)sender {
    [self.player shortJumpForward];
    if (!self.player.isPlaying) {
        [self.player play];
    }
}
//快退 1分钟
- (IBAction)longJumpBackwardAction:(id)sender {
    [self.player mediumJumpBackward];
    if (!self.player.isPlaying) {
        [self.player play];
    }
}
//快进 1分钟
- (IBAction)longJumpForwardAction:(id)sender {
    [self.player mediumJumpForward];
    if (!self.player.isPlaying) {
        [self.player play];
    }
}
//拖动进度条
- (IBAction)progressValueDidChanged:(UISlider *)sender {
    if (self.player.isSeekable) {
        self.player.position = sender.value;
    }else{
        [self.player play];
    }
}
- (IBAction)progressValueDidStart:(id)sender {
    self.progressISAdjusting = YES;
}
- (IBAction)progressValueDidFinish:(id)sender {
    double delayInSeconds = 0.5;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^(void){
        self.progressISAdjusting = NO;
    });
}



#pragma mark - VLCMediaPlayerDelegate
/**
 * Sent by the default notification center whenever the player's state has changed.
 * \details Discussion The value of aNotification is always an VLCMediaPlayerStateChanged notification. You can retrieve
 * the VLCMediaPlayer object in question by sending object to aNotification.
 */
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
    NSLog(@"mediaPlayerStateChanged 状态：%ld",(long)self.player.state);
    switch (self.player.state) {
        case VLCMediaPlayerStateStopped:///0
            [self.btnPlayer setButtonState:MPlayerButtonStatePause];
//            [self.btnPlayer setTitle:@"◉" forState:UIControlStateNormal];
//            [self.btnPlayer setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
//            [self.btnStatus setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
            break;
        case VLCMediaPlayerStateOpening:  ///1
        case VLCMediaPlayerStateBuffering:///2
        case VLCMediaPlayerStatePlaying:  ///5
            [self.btnPlayer setButtonState:MPlayerButtonStatePlay];
//            [self.btnPlayer setTitle:@"Ⅱ" forState:UIControlStateNormal];
//            [self.btnPlayer setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//            [self.btnStatus setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            break;
        case VLCMediaPlayerStateEnded:///3
            [self.btnPlayer setButtonState:MPlayerButtonStatePause];
//            [self.btnPlayer setTitle:@"◉" forState:UIControlStateNormal];
//            [self.btnPlayer setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//            [self.btnStatus setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            break;
        case VLCMediaPlayerStateError:///4
            [self.btnPlayer setButtonState:MPlayerButtonStatePause];
//            [self.btnPlayer setTitle:@"✖" forState:UIControlStateNormal];
//            [self.btnPlayer setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            [self.btnStatus setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            break;
        case VLCMediaPlayerStatePaused:///6
            [self.btnPlayer setButtonState:MPlayerButtonStatePause];
//            [self.btnPlayer setTitle:@"S" forState:UIControlStateNormal];
//            [self.btnPlayer setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
//            [self.btnStatus setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    
}

/**
 * Sent by the default notification center whenever the player's time has changed.
 * \details Discussion The value of aNotification is always an VLCMediaPlayerTimeChanged notification. You can retrieve
 * the VLCMediaPlayer object in question by sending object to aNotification.
 */
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    //NSLog(@"%s %@\n%@\n%@",__func__,aNotification.name,aNotification.object,aNotification.userInfo);
}
#pragma mark - gesture
- (void)playerView:(MMPlayerView *)playerView didTap:(UITapGestureRecognizer *)gesture {
    [self.view bringSubviewToFront:self.playerView];
    [UIView animateWithDuration:.2 animations:^{
        
        if (self.controlViewISShowing) {
            self.playerViewHeaderConstraintHeight.constant = 0;
            self.playerViewFooterConstraintHeight.constant = 0;
        }else{
            self.playerViewHeaderConstraintHeight.constant = 80;
            self.playerViewFooterConstraintHeight.constant = 60;
        }
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.controlViewISShowing = !self.controlViewISShowing;
    }];
}
- (void)playerView:(MMPlayerView *)playerView didDoubleTap:(UITapGestureRecognizer *)gesture {
    NSString *path = [FileHelper libSnapshotsPath];
    
    [self.player saveVideoSnapshotAt:path withWidth:self.player.videoSize.width andHeight:self.player.videoSize.height];
    
    double delayInSeconds = 0.5f;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        FileHelper *fileHelper = [FileHelper.alloc init];
        NSString *filePath = [FileHelper libSnapshotsPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
        for (NSString *fileName in fileArray) {
            NSString *path = [filePath stringByAppendingPathComponent:fileName];
            [fileHelper saveImage2Album:path completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    [FileHelper deleteFile:path];
                }
            }];
        }
        
    });
    
    [self.view showTip:@"截图成功" dealy:1.5];
}
- (void)playerView:(MMPlayerView *)playerView didPinch:(UIPinchGestureRecognizer *)gesture {
    if (gesture.scale < 1) {
        self.player.scaleFactor = 0;
    }else{
        self.player.scaleFactor = gesture.scale;
    }
}
//调整屏幕亮度
- (IBAction)adjustBrightnessGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    //    CGFloat light = [UIScreen mainScreen].brightness;
    //    //设置屏幕亮度
    //    [UIScreen mainScreen].brightness = light;
}

#pragma mark - private
- (void)addObserver {
    [self.player addObserver:self forKeyPath:@"remainingTime" options:0 context:nil];
    [self.player addObserver:self forKeyPath:@"isPlaying" options:0 context:nil];
}

- (void)removeObserver {
    [self.player removeObserver:self forKeyPath:@"remainingTime"];
    [self.player removeObserver:self forKeyPath:@"isPlaying"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    //NSLog(@"Position %f",self.player.position);
    //NSLog(@"Time %@",self.player.time.stringValue);
    //NSLog(@"Remaining %@",self.player.remainingTime.stringValue);
    
    if (self.progressISAdjusting) {
        return;
    }
    [self.labTime setText:self.player.time.stringValue];
    [self.labRemainingTime setText:self.player.remainingTime.stringValue];
    [self.sliderProgress setValue:self.player.position animated:YES];
    
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self.player play];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self.player pause];
    }];
}
- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view bringSubviewToFront:self.playerView];
}

#pragma mark - init

- (void)install {
    
    UIColor *darkColor = [UIColor colorWithWhite:0 alpha:0.5];
    UIColor *lightColor = [UIColor clearColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.view setBackgroundColor:UIColor.blackColor];
    
    [self.labTitle setText:self.model.name];
    [self.sliderProgress setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
    [self.sliderProgress setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateHighlighted];
    [self setControlViewISShowing:NO];
    [self.playerHeaderView setBackgroundColor:[UIColor gradientFromColor:darkColor toColor:lightColor height:self.playerHeaderView.height]];
    [self.playerFooterView setBackgroundColor:[UIColor gradientFromColor:lightColor toColor:darkColor height:self.playerFooterView.height]];
    
    [self.btnPlayer setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.85]] forState:UIControlStateHighlighted];
    [self.btnPlayer.layer setCornerRadius:self.btnPlayer.width/2.0];
    [self.btnPlayer.layer setMasksToBounds:YES];
}
- (void)configuration{
    VLCMedia *media = ({
        if (self.model.path) {
            media = [VLCMedia mediaWithPath:self.model.path];
        }else if (self.model.url){
            media = [VLCMedia mediaWithURL:[NSURL URLWithString:self.model.url]];
        }else {
            media = [VLCMedia.alloc init];
            NSLog(@"ERROR:%@",self.model);
        }
        media;
    });
    self.player = ({
        _player = VLCMediaPlayer.alloc.init;
        _player.drawable = self.view;
        _player.delegate = self;
        _player.media = media;
        _player;
    });
    self.playerView.delegate = self;
}

#pragma mark - system
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;//UIInterfaceOrientationMaskAll
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}



@end
