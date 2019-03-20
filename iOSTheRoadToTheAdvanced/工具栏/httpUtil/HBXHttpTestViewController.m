//
//  HBXHttpTestViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/12/8.
//  Copyright © 2018 黄保贤. All rights reserved.
//

#import "HBXHttpTestViewController.h"
#import "YTKNetworkConfig.h"
#import "HBXBaseRequest.h"

@interface HBXHttpTestViewController ()

@end

@implementation HBXHttpTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = @"http://suo.im";
//    config.cdnUrl = @"http://fen.bi";
    
    // Do any additional setup after loading the view.
}

- (IBAction)requestButtonClick:(id)sender {
    
    NSString *url = @"http%3a%2f%2fwww.baidu.com";
    HBXBaseRequest *api = [[HBXBaseRequest alloc] initWithUrl:url];
    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"request.responseString : %@", request.responseString);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"request.error.userInfo: %@", request.error.userInfo);
    }];
    [api start];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
