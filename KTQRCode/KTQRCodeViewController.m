//
//  KTQRCodeViewController.m
//  KTDownloadDemo
//
//  Created by Kevin on 2016/10/9.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "KTQRCodeViewController.h"

@interface KTQRCodeViewController ()

@end

@implementation KTQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapCancelButton:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapSelectAlbum:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [self presentViewController:picker animated:YES completion:nil];
}

@end
