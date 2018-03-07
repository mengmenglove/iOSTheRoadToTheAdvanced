//
//  DesignClassViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/3/6.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "DesignClassViewController.h"

@interface DesignClassViewController ()

@end

@implementation DesignClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     设计模式的类型： 主要是解决模块耦合，类与类的耦合
     
     
     1 设计模式
     
        单列
        抽象工厂
        建造者模式
        原型模式
     
     
     2 并发设计模式
        代理 delegete
        组合
        桥接
        享元
        外观
        装饰
        适配器  delegete
     
     
     
     3 框架级别设计模式
        观察者  kv0 Notification
        访问者
        解释器
        策略   if-else  switch-case 定义一系列算法，并且将算法封装起来，算法之间可以互相替换
        迭代器
        命令模式
        状态  target Action
        备忘录
        模板方法
        责任链
        中介者  mvc中的c，控制2方数据传输
     
     */
    // Do any additional setup after loading the view.
}

/*
    mvc  最基本的设计模式
 
 */


/*
 UML建模语言 工具startUML
 面向对象软件标准化建模语言
 可视化的展示项目模块类之间的区别
 
 
 */
- (void)uml {
    
    
}

- (void)mvcDesign {
    
    
}


/**
 1 2个类交互解耦方式：
        a： 代理
        b: block
        c: 通知  解决2者之间的互相引用
 
 */



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
