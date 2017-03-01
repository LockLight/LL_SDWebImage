//
//  NSString+NSString_LLAddition.m
//  仿写SDWebImage框架(实现cell的异步加载)
//
//  Created by locklight on 17/3/1.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import "NSString+NSString_LLAddition.h"

@implementation NSString (NSString_LLAddition)

- (instancetype)ll_GetImgPath{
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *lastName = [self lastPathComponent];
    //拼接文件名
    return  [cachesPath stringByAppendingString:lastName];
}

@end
