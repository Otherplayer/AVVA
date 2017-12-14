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
    self.datas = [[NSMutableArray alloc] init];
    self.tableView.tableFooterView = [UIView.alloc init];
    
    [self fetchLocalDatas];
    
    //流媒体视频
//    @[@"香港卫视",@"香港财经",@"韩国新唐人亚太",@"韩国KCTV-HD",@"韩国朝鲜日报",@"泰国中文台",@"美国中文电视",@"亚洲联合卫视",@"深圳"];
//    NSArray *items = @[@"rtmp://live.hkstv.hk.lxdns.com/live/hks",
//                       @"rtmp://202.69.69.180:443/webcast/bshdlive-pc",
//                       @"rtmp://123.108.164.71/etv2/phd926",
//                       @"rtmp://122.202.129.136:1935/live/ch5",
//                       @"rtmp://live.chosun.gscdn.com/live/tvchosun1.stream",
//                       @"rtmp://110.164.48.237:1935/tcctv_ch002/tcctv02.stream_live1",
//                       @"rtmp://media3.sinovision.net:1935/live/livestream",
//                       @"rtmp://tv.unbtv.tv/app_2/ls_1.stream"];
    
//    可直接播放
    
    
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
    cell.textLabel.textColor = [UIColor lightGrayColor];
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
        [FileHelper deleteFile:model.path];
        [self.datas removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark - 

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





@end