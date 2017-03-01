//
//  LLImageModel.h
//  第三方框架异步加载图片
//
//  Created by locklight on 17/3/1.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLImageModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *download;
@property (nonatomic, copy) NSString *icon;

@end

/*
 {
 "name" : "植物大战僵尸",
 "download" : "10311万",
 "icon" : "http:\/\/p16.qhimg.com\/dr\/48_48_\/t0125e8d438ae9d2fbb.png"
 },

*/
