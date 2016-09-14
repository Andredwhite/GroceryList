//
//  UPCScannerViewController.m
//  GroceryList
//
//  Created by Andre White on 8/9/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "UPCScannerViewController.h"
#import "AppDelegate.h"
#import "GLDataController.h"
#import "User+CoreDataProperties.h"
@interface UPCScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic) BOOL isReading;
-(BOOL)startReading;
-(void)stopReading;
@property(nonatomic, strong) AVCaptureSession *captureSession;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer* videoPreviewLayer;
@property(nonatomic, strong) User* user;
@property(nonatomic, assign) BOOL deviceAuthorized;
@end

@implementation UPCScannerViewController
@synthesize viewPreview;
@synthesize delegate;


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //AppDelegate* appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [[self navigationItem]setTitle:@"Scan Item"];
    [self startReading];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) startReading{
    AVCaptureDevice* captureDevice= [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        NSError *error = nil;
        if ([captureDevice lockForConfiguration:&error]) {
            CGPoint autofocusPoint = CGPointMake(0.5f, 0.5f);
            [captureDevice setFocusPointOfInterest:autofocusPoint];
            [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }                                
    NSError* error=nil;
    AVCaptureDeviceInput* input=[AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"Unable to add Device: %@",[error localizedDescription]);
    }
    _captureSession= [[AVCaptureSession alloc]init];
    
    if([_captureSession canAddInput:input]){
            [_captureSession addInput:input];
    }
    else{
        NSLog(@"Unable to add Input: %@",[error localizedDescription]);
    }
    
    AVCaptureMetadataOutput* captureMetadataOutput= [[AVCaptureMetadataOutput alloc]init];
    if ([_captureSession canAddOutput:captureMetadataOutput]) {
        [_captureSession addOutput:captureMetadataOutput];
    }
    else{
        NSLog(@"Unable to add Output: %@",[error localizedDescription]);
    }
    [captureMetadataOutput setMetadataObjectsDelegate:delegate queue:dispatch_get_main_queue()];
    [captureMetadataOutput setMetadataObjectTypes:@[ AVMetadataObjectTypeEAN13Code]];
    _videoPreviewLayer= [[AVCaptureVideoPreviewLayer alloc]initWithSession:_captureSession];
    [viewPreview.layer addSublayer:_videoPreviewLayer];
    viewPreview.clipsToBounds=YES;
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResize];
    [_videoPreviewLayer setFrame:viewPreview.layer.bounds];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CameraAuthorized"]) {
        [_captureSession startRunning];
    }
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [self stopReading];
}

-(void) stopReading{
    [_captureSession stopRunning];
    _captureSession=nil;
    [_videoPreviewLayer removeFromSuperlayer];
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
