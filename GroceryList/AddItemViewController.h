//
//  AddItemViewController.h
//  GroceryList
//
//  Created by Andre White on 7/19/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroceryListDelegate.h"
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
@class GroceryList;
@class GLDataController;
@interface AddItemViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *itemSearch;
@property (strong, nonatomic) IBOutlet UITableView *resultsTable;
@property (strong,nonatomic) GLDataController* dataController;
@property (retain, nonatomic) GroceryItem* selectedItem;
@end
