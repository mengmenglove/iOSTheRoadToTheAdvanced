//
//  ReactiveCocoaViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2020/1/11.
//  Copyright © 2020 黄保贤. All rights reserved.
//

#import "ReactiveCocoaViewController.h"
#import <ReactiveObjC.h>


@interface ReactiveCocoaViewController ()

@property (nonatomic, strong) NSNumber * count;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation ReactiveCocoaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [RACObserve(self, count) subscribeNext:^(id  _Nullable x) {
        NSLog(@"count %@", x);
//        self.numberLabel.text = [NSString stringWithFormat:@"%@",x];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    int getCount = [self.count intValue];
    int newCount = getCount++;
    self.count = [NSNumber numberWithInt:newCount];
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
