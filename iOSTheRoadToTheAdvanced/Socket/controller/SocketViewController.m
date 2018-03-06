//
//  SocketViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/2/28.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "SocketViewController.h"

#import <sys/socket.h>

#import <netinet/in.h>

#import <arpa/inet.h>



@interface SocketViewController ()

@end

@implementation SocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /***
     1 封包
     
     2 解包，分包
     
     3 scoket在传输层
     
     4 学习socket就是学习网络
     
     5 传输层 socket通讯 tcp udp
     
     tcp/ip  tcp在使用过程中跟ip是不能分开的，但是在使用的时候用不到ip协议
     
     会话： 彼此交流的协议
     
     tcp：传输控制协议（电话） 大小不限制 安全可靠协议  三次握手 四次断开
     
     udp：用户数据协议 （短信） 64k大小限制 有可能丢失数据
     
     
     
     
     应用层
     
     表示层
     
     会话
     
     传输层
     
     网络层
     
     数据连接层
     
     物理层
     
     
     
     
     
     应用场景：
     
     
     1 流媒体直播  udp传输数据  画面市常卡顿
     
     2 玩游戏的游戏数据表  也是upd报文形式
     
     3 下载数据 是使用tcp 下载不允许丢包
     
     
     
     
     
     
     
     
     */
    // Do any additional setup after loading the view.
    
    [self create];
}


- (void)create {
    // 1 创建socket
    //参数1 af： 地址描述 目前仅支持AF_INET
    //   2 类型： tcp（SOCK_STREAM） udp （SOCK_DGRAM）
    //   3 协议 常用0 字段选择合适的协议 IPPROTO_TCP、IPPROTO_UDP、IPPROTO_STCP、IPPROTO_TIPC
    
    int clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    // 2 链接服务器
    //参数 1 socket
    //    2 结构体地址
    //    3
    
    struct sockaddr_in addr;
    
    addr.sin_family = AF_INET;
    addr.sin_port = htons(80);
    addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    
    int result = connect(clientSocket,(const struct sockaddr_in *)&addr, sizeof(addr));
    if (result == 0) {
        //链接成功
    }else{
        //链接失败
    }

    // 3 发送数据给服务器
    
    // 4 接受数据
    // 5 关闭
    
}

@end
