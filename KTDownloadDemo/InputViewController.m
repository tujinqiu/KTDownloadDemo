//
//  InputViewController.m
//  KTDownloadDemo
//
//  Created by Kevin on 2016/10/9.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.inputTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapCancelButton:(id)sender {
    [self.inputTextField resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapDoneButton:(id)sender {
    [self.inputTextField resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.callbackBlock && self.inputTextField.text.length > 0) {
        self.callbackBlock(self.inputTextField.text);
    }
}

@end
