//
//  LLImageDownloader.m
//  仿写SDWebImage框架(实现cell的异步加载)
//
//  Created by locklight on 17/3/2.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import "LLImageDownloader.h"
#import "NSString+NSString_LLAddition.h"

@interface LLImageDownloader ()

@property (nonatomic, copy) NSString *imgString;
@property (nonatomic, copy) void(^bk)(UIImage *iconImg);

@end

@implementation LLImageDownloader

- (instancetype)initWithString:(NSString *)imgString andCompleteBlock:(void(^)(UIImage *iconImg))bk{
    LLImageDownloader *obj = [[LLImageDownloader alloc]init];
    obj.imgString = imgString;
    obj.bk = bk;
    
    return obj;
}

- (void)main{
    //根据url下载图片
    UIImage *iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgString]]];
    
    if(iconImage){
        //写入沙盒
        NSString *path = [self.imgString ll_GetImgPath];
        
        //获取json二进制数据
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgString]];
        
        [data writeToFile:path atomically:YES];
    }

//    NSLog(@"img = %@, %@",iconImage,[NSThread currentThread]);
    
    //更新UI
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.bk(iconImage);
    }];
}

@end
