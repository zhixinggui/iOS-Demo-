//
//  TestPageViewController.m
//  Demo
//
//  Created by FineexMac on 16/2/22.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//

#import "TestPageViewController.h"
#import "TestAViewController.h"
#import "TestBViewController.h"

@interface TestPageViewController ()

@end

@implementation TestPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分页控制器";
    self.themeColor = [UIColor orangeColor];
    self.leftMenuTitle = @"左控制器";
    self.rightMenuTitle = @"右控制器";
    self.leftViewController = [TestAViewController new];
    self.rightViewController = [TestBViewController new];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com