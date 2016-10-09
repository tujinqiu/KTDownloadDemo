//
//  KTQRCodeNavigationController.h
//  KTDownloadDemo
//
//  Created by Kevin on 2016/10/9.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTQRCodeNavigationController;

@protocol KTQRCodeNavigationControllerDelegate <NSObject>

@optional
- (void)QRCodeNavigationController:(KTQRCodeNavigationController *)navigationController didScanResult:(NSString *)result;

@end

@interface KTQRCodeNavigationController : UINavigationController

@property (nonatomic, weak) id<KTQRCodeNavigationControllerDelegate> QRCodeDelegate;

+ (instancetype)QRCodeNavigationController;

@end
