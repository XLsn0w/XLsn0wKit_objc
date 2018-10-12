//
//  ViewController.m
//  XLsn0wKit_objc
//
//  Created by XLsn0w on 2017/6/13.
//  Copyright © 2017年 XLsn0w. All rights reserved.
//

#import "ViewController.h"
#import "XLsn0wKit_objc.h"
//#import <Masonry.h>

@interface ViewController () <XLsn0wCycleDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XLsn0wLog(@"XLsn0wKit For Objective-C");
    [self addXLsn0wCycle];
}

- (void)addXLsn0wCycle {
    XLsn0wCycle* _cycle = [XLsn0wCycle cycleWithFrame:CGRectMake(0, 100, kScreenWidth, 200) imageURLStringsGroup:@[@"http://s13.sinaimg.cn/mw690/001sIaVVzy7okJqOSRu3c&690", @"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=3781606618,3124498988&fm=175&app=25&f=JPEG?w=640&h=853&s=E424D55FA46200B4248C60DA0300C092"]];
    [self.view addSubview:_cycle];
    _cycle.delegate = self;
    _cycle.pageControlStyle = PageContolStylePageNumber;
}

- (void)cycle:(XLsn0wCycle *)cycle didSelectItemAtIndex:(NSInteger)index {
    XLsn0wLog(@"index=== %ld", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
