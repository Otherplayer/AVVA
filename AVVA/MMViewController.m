//
//  ViewController.m
//  AVVA
//
//  Created by __无邪_ on 2017/11/29.
//  Copyright © 2017年 __无邪_. All rights reserved.
//
//
//   在此外下载最新版本库
//   http://nightlies.videolan.org/build/iOS/
//
//
//


#import "MMViewController.h"
#import "MMPlayerController.h"
#import "MMSnapshotsViewController.h"
#import "FileHelper.h"

static NSString *Identifier = @"VideoIdentifier";


@interface MMViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) BOOL isBundleResources;
@end

@implementation MMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configuration];
    [self fetchLocalDatas];
    
    /** 流媒体视频 可直接播放
    @[@"香港卫视",@"香港财经",@"韩国新唐人亚太",@"韩国KCTV-HD",@"韩国朝鲜日报",@"泰国中文台",@"美国中文电视",@"亚洲联合卫视",@"深圳"];
     NSArray *items = @[@"rtmp://live.hkstv.hk.lxdns.com/live/hks",
     @"rtmp://202.69.69.180:443/webcast/bshdlive-pc",
     @"rtmp://123.108.164.71/etv2/phd926",
     @"rtmp://122.202.129.136:1935/live/ch5",
     @"rtmp://live.chosun.gscdn.com/live/tvchosun1.stream",
     @"rtmp://110.164.48.237:1935/tcctv_ch002/tcctv02.stream_live1",
     @"rtmp://media3.sinovision.net:1935/live/livestream",
     @"rtmp://tv.unbtv.tv/app_2/ls_1.stream"];
    **/
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startLaunchingAnimation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)fetchLocalDatas {
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [FileHelper documentPath];
    NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:filePath error:&error];
    if (fileArray.count > 0) {
        self.isBundleResources = NO;
        for (NSString *fileName in fileArray) {
            NSString *path = [filePath stringByAppendingPathComponent:fileName];
            NSInteger fileSize = [FileHelper fileSizeForPath:path];
            MMModel *model = [MMModel.alloc init];
            model.name = fileName;
            model.path = path;
            model.fileSize = fileSize;
            model.thumbImage = [FileHelper getThumbImage:path];
            [self.datas addObject:model];
        }
    }else {
        self.isBundleResources = YES;
        NSString *fileName = @"iphone.mp4";
        NSString *path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
        NSInteger fileSize = [FileHelper fileSizeForPath:path];
        MMModel *model = [MMModel.alloc init];
        model.name = fileName;
        model.path = path;
        model.fileSize = fileSize;
        model.thumbImage = [FileHelper getThumbImage:path];
        [self.datas addObject:model];
        [self.datas addObject:model];
    }
    
    [self.tableView reloadData];
    
    
}

#pragma mark - Action

- (IBAction)refreshAction:(id)sender {
    [self fetchLocalDatas];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    MMModel *model = self.datas[indexPath.row];
    cell.imageView.image = model.thumbImage;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = model.name;
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isBundleResources) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MMModel *model = self.datas[indexPath.row];
        [self.datas removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [FileHelper deleteFile:model.path];
        });
    }
}
#pragma mark -

- (void)configuration {
    UIColor *bgColor = [UIColor gradientFromColor:[UIColor orangeColor] toColor:[UIColor whiteColor] height:self.view.height];
    self.view.backgroundColor = bgColor;
    // 设置navbar透明
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.backgroundColor = nil;
    self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor orangeColor]];//线色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.datas = NSMutableArray.alloc.init;
    self.tableView.tableFooterView = UIView.alloc.init;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController *destination = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"player"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        MMModel *model = self.datas[indexPath.row];
        [destination setValue:model forKey:@"model"];
    }else if ([segue.identifier isEqualToString:@"snapshots"]) {
        
    }
    
}

#pragma mark -

- (void)startLaunchingAnimation {
    
//    UIViewController *launchScreen = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
//    UIView *launchScreenView = launchScreen.view;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIImageView *launchScreenView = [[UIImageView alloc] init];
    launchScreenView.image = [UIImage imageNamed:@"IMG_0061.JPG"];
    launchScreenView.contentMode = UIViewContentModeScaleAspectFill;
    launchScreenView.frame = window.bounds;
    launchScreenView.backgroundColor = [UIColor orangeColor];
    [window addSubview:launchScreenView];
    
    [UIView animateWithDuration:.85f delay:0.5f options:MMUIViewAnimationOptionsCurveOut animations:^{
        launchScreenView.alpha = 0;
        launchScreenView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5f, 1.5f, 1.0f);
    } completion:^(BOOL finished) {
        [launchScreenView removeFromSuperview];
    }];
    
}




@end
