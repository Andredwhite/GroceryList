//
//  UPCScannerViewController.h
//  GroceryList
//
//  Created by Andre White on 8/9/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface UPCScannerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *viewPreview;
@property (strong, nonatomic) id<AVCaptureMetadataOutputObjectsDelegate> delegate;
@end
