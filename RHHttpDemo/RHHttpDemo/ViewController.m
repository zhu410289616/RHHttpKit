//
//  ViewController.m
//  RHHttpDemo
//
//  Created by zhuruhong on 15/8/21.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "ViewController.h"
#import "RHHttpTest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    RHHttpTest *test = [[RHHttpTest alloc] init];
    test.url = @"http://mobile.ximalaya.com/mobile/others/ca/album/track/280961/true/1/30?device=iPhone";
    [test setSuccessBlock:^(id<RHHttpProtocol> request, id response) {
        NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        RHHttpLog(@"setSuccessBlock: %@", result);
    }];
    [test setFailureBlock:^(id<RHHttpProtocol> request, NSError *error) {
        RHHttpLog(@"setFailureBlock: %@", error);
    }];
    [test start];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
