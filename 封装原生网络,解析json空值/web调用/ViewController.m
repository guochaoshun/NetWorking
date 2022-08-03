//
//  ViewController.m
//  web调用
//
//  Created by 郭朝顺 on 2018/4/21星期六.
//  Copyright © 2018年 乐乐. All rights reserved.
//

#import "ViewController.h"
#import "NSNumber+EqualString.h"
#import "Person.h"
#import "NetWork.h"
#import "PingHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PingHelper *pingHelper = [[PingHelper alloc] init];
    pingHelper.host = @"www.baidu.com";
    [pingHelper pingWithBlock:^(BOOL isSuccess, NSTimeInterval latency) {

    }];
}

- (void)testMalloc {
    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        char *s = NULL;
        s = malloc(1024 * 1024 * 100);
        strcpy(s, [NSUUID UUID].UUIDString.UTF8String);
        // 必须需要释放, 不释放会有内存泄漏
        free(s);
        s = NULL;
    }];
}

- (void)testJson {
    [self loadData:nil];

    NSDictionary * dic = @{
                           @"person":[[Person alloc]init]
                           };
    NSLog(@"%@",dic);

    NSLog(@"--------------");

    NSNumber * num = @(99.99);
    //    NSLog(@"num = %@",num);
    NSString * money = [NSString stringWithFormat:@"¥ %@",num];
    NSLog(@"money = %@",money);
    NSLog(@"--------------");

    NSLog(@"%@",@(99.99).description);
    NSLog(@"%@",@(99.99).moneyDescription);
    NSLog(@"%@",@(99.99));

    NSLog(@"%@",@(67.96).description);
    NSLog(@"%@",@(67.96).moneyDescription);
    NSLog(@"%@",@(67.96));
    NSLog(@"%@",@(2.2));
    NSLog(@"%@",@(199));
    NSLog(@"%@",@(321));
}

- (IBAction)loadData:(id)sender {
    
    NetWork * network = [[NetWork alloc] init] ;
    network.urlString = @"http://qz.test.internet.zhiwangyilian.com/api/client-community/client/community/hot/hotList";
    network.parameters = @{@"pageIndex":@"0",
                           @"pageSize":@"20",
                           };
    network.success = ^(NSDictionary * data) {
        
    };
    network.fail = ^(NSError * error) {
        NSLog(@"%@",error);
    };
    [network startLoadData];
    
}

@end
