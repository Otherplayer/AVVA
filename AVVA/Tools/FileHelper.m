//
//  FileHelper.m
//  AVVA
//
//  Created by __无邪_ on 2017/11/30.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "FileHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation FileHelper


+ (BOOL)fileExists:(NSString *)path {
    return  [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)deleteFile:(NSString *)path {
    if ([self fileExists:path]) {
        NSFileManager* fileManager=[NSFileManager defaultManager];
        return  [fileManager removeItemAtPath:path error:nil];
    }
    return YES;
}

+ (long long)fileSizeForPath:(NSString *)path {
    long long fileSize = 0;
    if([self fileExists:path]){
        NSError *error = nil;
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}


+ (NSString *)homePath{
    return NSHomeDirectory();
}
+ (NSString *)applicationPath{
    return [NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)libraryPath{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)documentPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)libPreferencesPath{
    return [[FileHelper libraryPath] stringByAppendingPathComponent:@"Preferences"];
}
+ (NSString *)libCachePath{
    return [[FileHelper libraryPath] stringByAppendingPathComponent:@"Caches"];
}
+ (NSString *)libSnapshotsPath{
    BOOL isDir;
    NSString *path = [[FileHelper libCachePath] stringByAppendingPathComponent:@"comSnapshots"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
    
}
+ (NSString *)tmpPath{
    return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}



+ (UIImage *)getThumbImage:(NSString *)videoPath {
    
    if (videoPath) {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
        
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        
        // 设定缩略图的方向
        // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
        gen.appliesPreferredTrackTransform = YES;
        
        // 设置图片的最大size(分辨率)
        gen.maximumSize = CGSizeMake(300, 169);
        
        CMTime time = CMTimeMakeWithSeconds(5.0, 600); //一秒钟600帧，取第10帧。
        
        NSError *error = nil;
        
        CMTime actualTime;
        
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        
        if (error) {
            UIImage *placeHoldImg = [UIImage imageNamed:@"posters_default_horizontal"];
            return placeHoldImg;
        }
        
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        
        CGImageRelease(image);
        
        return thumb;
        
    } else {
        
        UIImage *placeHoldImg = [UIImage imageNamed:@"posters_default_horizontal"];
        return placeHoldImg;
    }
    
}


- (void)saveImage2Album:(NSString *)path completionHandler:(void(^)(BOOL success, NSError *error))completionHandler{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL URLWithString:path]];
    } completionHandler:completionHandler];
}


@end
