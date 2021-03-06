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
#import "KTQRCodeController.h"

@interface ViewController ()<KTQRCodeControllerDelegate>

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
    
    self.urlLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"KTDownloadURL"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleExit:) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleExit:(NSNotification *)notif
{
    if (self.urlLabel.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.urlLabel.text forKey:@"KTDownloadURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)tapQRButton:(id)sender {
    KTQRCodeController *nav = [KTQRCodeController QRCodeController];
    nav.QRCodeDelegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)QRCodeController:(KTQRCodeController *)QRCodeController didScanResult:(NSString *)result
{
    [QRCodeController dismissViewControllerAnimated:YES completion:nil];
    self.urlLabel.text = result;
}

- (IBAction)tapStartButton:(UIButton *)sender {
    if (self.isStartState) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:self.urlLabel.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.progress = downloadProgress.fractionCompleted;
                self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(downloadProgress.fractionCompleted * 100)];
            });
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (error) {
                [self showError:error];
            } else {
                NSString *name = response.suggestedFilename;
                NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                NSString *destPath = [docPath stringByAppendingPathComponent:name];
                [[NSFileManager defaultManager] moveItemAtURL:filePath toURL:[NSURL fileURLWithPath:destPath] error:nil];
                [self showSuccess:name];
            }
        }];
        [self.downloadTask resume];
    } else {
        [self.downloadTask cancel];
    }
    self.isStartState = !self.isStartState;
}

- (void)showSuccess:(NSString *)fileName
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下载完成" message:fileName preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    self.isStartState = YES;
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
