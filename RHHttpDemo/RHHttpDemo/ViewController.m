//
//  ViewController.m
//  RHHttpDemo
//
//  Created by zhuruhong on 15/8/21.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "ViewController.h"
#import "RHHttpGetOperation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //
    RHHttpGetOperation *get = [[RHHttpGetOperation alloc] init];
    get.urlString = @"http://mobile.ximalaya.com/mobile/others/ca/album/track/280961/true/1/30?device=iPhone";
    [get setCacheBlock:^(id request, id response) {
        RHHttpLog(@"setCacheBlock: %@", response);
    }];
    [get setSuccessBlock:^(id request, id response) {
        NSString *result = response;
        RHHttpLog(@"setSuccessBlock: %@", result);
    }];
    [get setFailureBlock:^(id request, NSError *error) {
        RHHttpLog(@"setFailureBlock: %@", error);
    }];
    [get start];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
