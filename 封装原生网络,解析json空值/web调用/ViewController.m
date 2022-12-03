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
#import "ULPingHelper.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <errno.h>
#include <arpa/inet.h>
#include<netdb.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ULPingHelper *pingHelper = [[ULPingHelper alloc] init];
    pingHelper.host = @"www.baidu.com";

    [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"开始");
        [pingHelper pingWithBlock:^(BOOL isSuccess, NSString * _Nonnull ipString, NSTimeInterval latency) {
            NSLog(@"完成 %d %@  %d ms",isSuccess,ipString,(int)latency);
        }];
    }];


//    [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [self dnsFun1];
//        [self dnsFun3];
//    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {


}

// https://blog.csdn.net/weixin_33785972/article/details/87996257
- (void)dnsFun3 {
    Boolean result,bResolved;
    CFHostRef hostRef;
    CFArrayRef addresses = NULL;
    NSMutableArray * ipsArr = [[NSMutableArray alloc] init];

    CFStringRef hostNameRef = CFStringCreateWithCString(kCFAllocatorDefault, "www.baidu.com", kCFStringEncodingASCII);

    hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNameRef);
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
    if (result == TRUE) {
        addresses = CFHostGetAddressing(hostRef, &result);
    }
    bResolved = result == TRUE ? true : false;

    if(bResolved)
    {
        struct sockaddr_in* remoteAddr;
        for(int i = 0; i < CFArrayGetCount(addresses); i++)
        {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);

            if(remoteAddr != NULL)
            {
                //获取IP地址
                char ip[16];
                strcpy(ip, inet_ntoa(remoteAddr->sin_addr));
                NSString * ipStr = [NSString stringWithCString:ip encoding:NSUTF8StringEncoding];
                [ipsArr addObject:ipStr];
            }
        }
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"33333 === ip === %@ === time cost: %0.3fs", ipsArr,end - start);
    CFRelease(hostNameRef);
    CFRelease(hostRef);
}

- (void)dnsFun1 {
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    char   *ptr, **pptr;
    struct hostent *hptr;
    char   str[32];
    ptr = "www.baidu.com";
    NSMutableArray * ips = [NSMutableArray array];
    if((hptr = gethostbyname(ptr)) == NULL) {
        return;
    }
    for(pptr=hptr->h_addr_list; *pptr!=NULL; pptr++) {
        NSString * ipStr = [NSString stringWithCString:inet_ntop(hptr->h_addrtype, *pptr, str, sizeof(str)) encoding:NSUTF8StringEncoding];
        [ips addObject:ipStr?:@""];
    }

    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"22222 === ip === %@ === time cost: %0.3fs", ips,end - start);

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
