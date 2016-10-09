//
//  KTQRCodeNavigationController.m
//  KTDownloadDemo
//
//  Created by Kevin on 2016/10/9.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "KTQRCodeNavigationController.h"
#import "KTQRCodeViewController.h"

@interface KTQRCodeNavigationController ()

@end

@implementation KTQRCodeNavigationController

+ (instancetype)QRCodeNavigationController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"KTQRCode" bundle:[NSBundle mainBundle]];
    KTQRCodeNavigationController *nav = [storyBoard instantiateInitialViewController];
    KTQRCodeViewController *qrVC = (KTQRCodeViewController *)[nav topViewController];
    qrVC.callbackBlock = ^(NSString *result) {
        if ([nav.QRCodeDelegate respondsToSelector:@selector(QRCodeNavigationController:didScanResult:)]) {
            [nav.QRCodeDelegate QRCodeNavigationController:nav didScanResult:result];
        }
    };
    
    return nav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
