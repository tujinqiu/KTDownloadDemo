//
//  KTQRCodeViewController.h
//  KTDownloadDemo
//
//  Created by Kevin on 2016/10/9.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTQRCodeViewController : UIViewController

@property (nonatomic, copy) void(^callbackBlock)(NSString *result);

@end
