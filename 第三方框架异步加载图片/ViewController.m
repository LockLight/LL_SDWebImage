//
//  ViewController.m
//  第三方框架异步加载图片
//
//  Created by locklight on 17/3/1.
//  Copyright © 2017年 LockLight. All rights reserved.
//  https://raw.githubusercontent.com/luowenqi/SZiOS09/master/apps.json

#import "ViewController.h"
#import "LLImageModel.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "YYModel.h"
#import "NSString+NSString_LLAddition.h"


@interface ViewController ()
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableDictionary *cacheImageList;
@property (nonatomic, strong) NSMutableDictionary *operationList;
@end

@implementation ViewController{
    NSArray<LLImageModel *> *_imgArr;
}

- (NSOperationQueue *)queue{
    if(_queue == nil){
        _queue = [NSOperationQueue new];
    }
    return _queue;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",NSHomeDirectory());
    
    
    //实例化图片缓存字典
    _cacheImageList = [NSMutableDictionary dictionary];
    //实例化操作队列列表
    _operationList = [NSMutableDictionary dictionary];
    [self loadData];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imgArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"apps" forIndexPath:indexPath];
    
    // 设置 Cell...
    LLImageModel *model = _imgArr[indexPath.row];
    
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.download;
    
    //判断图片缓存池内是否存在
    UIImage *cacheImg = _cacheImageList[model.icon];
    if(cacheImg){
        cell.imageView.image = cacheImg;
        return cell;
    }
    
    //判断沙盒内是否存在该图片
    NSString *path = [model.icon ll_GetImgPath];
    UIImage *sandBoxImage = [UIImage imageWithContentsOfFile:path];
    if(sandBoxImage){
        cell.imageView.image = sandBoxImage;
        return cell;
    }

    //占位图
    cell.imageView.image = [UIImage imageNamed:@"user_default"];
    
    //SDWebImage框架方法
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"user_default"]];
    
    //MARK:仿写框架底层方法
    //异步加载网络图片
    
    //判断是否存在该异步操作
    if(_operationList[model.icon] != nil){
        return cell;
    }
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.icon]]];
        
        if(iconImage){
            //写入沙盒
            NSString *path = [model.icon ll_GetImgPath];
            
            //获取json二进制数据
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.icon]];
            
            [data writeToFile:path atomically:YES];
        }
        
        //主线程更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{

            //加入图片缓存
            [_cacheImageList setObject:iconImage forKey:model.icon];
            //更新图片
            //cell.imageView.image = iconImage;   不建议直接赋值
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
    //添加到操作列表
    [_operationList setObject:op forKey:model.icon];
    
    //添加到操作队列
    [self.queue addOperation:op];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}


- (void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"https://raw.githubusercontent.com/luowenqi/SZiOS09/master/apps.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"响应请求成功：%@  %@  %@",[responseObject class],responseObject,[NSThread currentThread]);
        
        _imgArr = [NSArray yy_modelArrayWithClass:[LLImageModel class] json:responseObject];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"---错误:%@",error);
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    //清除图片缓存
    [_cacheImageList removeAllObjects];
    //清除操作列表
    [_operationList removeAllObjects];
    
    //清除沙盒缓存
    NSFileManager *file = [NSFileManager defaultManager];

    for (LLImageModel *model in _imgArr) {
        NSString *path = [model.icon ll_GetImgPath];
        [file  removeItemAtPath:path error:nil];
    }
}


@end
