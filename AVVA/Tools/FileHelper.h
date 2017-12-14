//
//  FileHelper.h
//  AVVA
//
//  Created by __无邪_ on 2017/11/30.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+ (BOOL)fileExists:(NSString *)path;
+ (BOOL)deleteFile:(NSString *)path;

+ (long long)fileSizeForPath:(NSString *)path;


+ (NSString *)homePath;            // 程序主目录，可见子目录(3个):Documents、Library、tmp
+ (NSString *)applicationPath;     // 程序目录，不能存任何东西
+ (NSString *)documentPath;        // 文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据
+ (NSString *)libraryPath;
+ (NSString *)libPreferencesPath;  // 配置目录，配置文件存这里
+ (NSString *)libCachePath;        // 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)tmpPath;             // 临时缓存目录，APP退出后，系统可能会删除这里的内容

+ (NSString *)libSnapshotsPath;    // 截图保存目录,没有时会自动创建

+ (UIImage *)getThumbImage:(NSString *)videoPath;

- (void)saveImage2Album:(NSString *)path completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;

@end
