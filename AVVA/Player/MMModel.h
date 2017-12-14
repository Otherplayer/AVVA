//
//  MMModel.h
//  AVVA
//
//  Created by __无邪_ on 2017/11/30.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMModel : NSObject

@property(nonatomic, copy)NSString *name;
@property(nonatomic, assign)NSInteger fileSize;
@property(nonatomic, strong)UIImage *thumbImage;

@property(nonatomic, copy)NSString *path;
@property(nonatomic, copy)NSString *url;

@end
