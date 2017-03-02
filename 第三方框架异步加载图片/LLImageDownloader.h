//
//  LLImageDownloader.h
//  仿写SDWebImage框架(实现cell的异步加载)
//
//  Created by locklight on 17/3/2.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import <UiKit/UIkit.h>

@interface LLImageDownloader : NSOperation

- (instancetype)initWithString:(NSString *)imgString andCompleteBlock:(void(^)(UIImage *image))bk;

@end
