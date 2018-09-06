//
//  HomeQRCodeController.m
//  MYCS
//  扫描界面
//  Created by AdminZhiHua on 15/11/13.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "HomeQRCodeController.h"
#import <AVFoundation/AVFoundation.h>
#import "ConstKeys.h"

@interface HomeQRCodeController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *scanImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginConst;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *dataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureConnection *connection;

@end

@implementation HomeQRCodeController


#pragma mark – life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self startScan];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self lineAnimation];
}

#pragma mark – Delegate
//数据输出的代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;

    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue                                         = metadataObject.stringValue;
    }

    [_session stopRunning];


    [self dismissViewControllerAnimated:YES completion:^{
        [self.scanImageView.layer removeAllAnimations];

        if ([self.delegate respondsToSelector:@selector(scanResultWith:resultString:)])
        {
            [self.delegate scanResultWith:self resultString:stringValue];
        }

    }];
}


#pragma mark – Event
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)applicationWillEnterForeground:(NSNotification *)noti {
    [self lineAnimation];
}

#pragma mark - Network


#pragma mark – Private
- (void)startScan {
    if (![self isAuthor]) return;

    if (![self.session canAddInput:self.deviceInput])
    {
        [self alertWith:@"系统提示" message:@"无法添加输入设备"];

        return;
    }

    [self.session addInput:self.deviceInput];

    if (![self.session canAddOutput:self.dataOutput])
    {
        [self alertWith:@"系统提示" message:@"无法添加输出设备"];

        return;
    }

    [self.session addOutput:self.dataOutput];

    //设置识别类型
    self.dataOutput.metadataObjectTypes = @[ AVMetadataObjectTypeQRCode ];
    [self.dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    ///添加预览图层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];

    ///链接
    self.connection = [self.dataOutput connectionWithMediaType:AVMediaTypeVideo];

    self.view.backgroundColor = [UIColor clearColor];

    [self.session startRunning];
}

///判断是否授权访问摄像头
- (BOOL)isAuthor {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (authStatus == AVAuthorizationStatusDenied)
    {
        [self alertWith:@"系统提示" message:@"您已关闭相机使用权限，请至手机“设置->隐私->相机”中打开"];

        return NO;
    }

    return YES;
}

- (void)alertWith:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

    [alert show];
}

- (void)lineAnimation {
    [self.scanImageView.layer removeAllAnimations];

    self.topMarginConst.constant = 0;

    [self.view layoutIfNeeded];

    [UIView animateWithDuration:3 animations:^{

        [UIView setAnimationRepeatCount:MAXFLOAT];

        self.topMarginConst.constant = 200;

        [self.view layoutIfNeeded];

    }];
}


#pragma mark – Getter/Setter
- (AVCaptureSession *)session {
    if (!_session)
    {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureDeviceInput *)deviceInput {
    if (!_deviceInput)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

        _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    }
    return _deviceInput;
}

- (AVCaptureMetadataOutput *)dataOutput {
    if (!_dataOutput)
    {
        _dataOutput = [[AVCaptureMetadataOutput alloc] init];
    }
    return _dataOutput;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer)
    {
        _previewLayer              = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame        = self.view.bounds;
    }
    return _previewLayer;
}


@end
