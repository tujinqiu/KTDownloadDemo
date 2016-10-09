//
//  ViewController.m
//  KTDownloadDemo
//
//  Created by Kevin on 2016/10/9.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "ViewController.h"
#import "InputViewController.h"
#import "AFNetworking.h"
#import "KTQRCodeNavigationController.h"

@interface ViewController ()<KTQRCodeNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic, assign) BOOL isStartState;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapQRButton:(id)sender {
    KTQRCodeNavigationController *nav = [KTQRCodeNavigationController QRCodeNavigationController];
    nav.QRCodeDelegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)QRCodeNavigationController:(KTQRCodeNavigationController *)navigationController didScanResult:(NSString *)result
{
    [navigationController dismissViewControllerAnimated:YES completion:nil];
    self.urlLabel.text = result;
}

- (IBAction)tapStartButton:(UIButton *)sender {
    if (self.isStartState) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:self.urlLabel.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            self.progressView.progress = downloadProgress.fractionCompleted;
            self.progressLabel.text = [NSString stringWithFormat:@"%d", (int)(downloadProgress.fractionCompleted * 100)];
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (error) {
                [self showError:error];
            } else {
                self.isStartState = YES;
                NSString *name = response.suggestedFilename;
                NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                NSString *destPath = [docPath stringByAppendingPathComponent:name];
                [[NSFileManager defaultManager] moveItemAtURL:filePath toURL:[NSURL fileURLWithPath:destPath] error:nil];
            }
        }];
        [self.downloadTask resume];
    } else {
        [self.downloadTask cancel];
    }
    self.isStartState = !self.isStartState;
}

- (void)showError:(NSError *)error
{
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    self.isStartState = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"input"]) {
        UINavigationController *nav = segue.destinationViewController;
        InputViewController *inputVC = (InputViewController *)nav.topViewController;
        inputVC.callbackBlock = ^(NSString *urlString) {
            self.urlLabel.text = urlString;
        };
    }
}

- (void)setIsStartState:(BOOL)isStartState
{
    _isStartState = isStartState;
    if (isStartState) {
        [self.startButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        [self.startButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

@end
