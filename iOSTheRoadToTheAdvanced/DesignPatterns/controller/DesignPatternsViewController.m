//
//  DesignPatternsViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/3/6.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "DesignPatternsViewController.h"

@interface DesignPatternsViewController ()

@end

@implementation DesignPatternsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设计模式： 未解决特定场景提出的解决方案
    // Do any additional setup after loading the view.
    
 /*
  
  1 设计模式优点： 1 项目清晰
                2 便于维护
  
  
  基本原则： 1 开闭原则  ： 对模块扩展开发的时候，修改关闭，尽量不要修改原有的代码 .m文件实现的时候不改变（比较理想化）
                        可以通过继承等实现
  
           2 里氏代换原则： 任何类出现的地方，子类一定可以出现，子类父类的可以相互替换，子类可以用父类的所有方法，要求子类尽量不要重新或者覆盖父类的方法
  
           3 依赖倒置原则 ： 抽象不依赖细节，但是细节依赖抽象
                          A类为接口，B，C为实现类， 则可以通过修改B，C来避免修改A，不要是不修改接口
  
           4 接口隔离原则：接口里面只做必要的事情，不做多余的事情（按照需求要求，不做多余事情）
  
           5 合成/聚合 复用原则 ： 添加新功能，尽量使用方法，少用继承
  
           6 最小知识原则： 2各类尽量不要直接通信，二是使用第三个类通信
  
           7 单一职责原则： 每个方法尽量只负责一件事 一个类也是
  
  */
    
    
    // 1 抽象方法，申明方法，不实现
    
    
}

//开闭原则
- (void)design {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
