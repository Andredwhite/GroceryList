//
//  BaseViewController.h
//  GroceryList
//
//  Created by Andre White on 7/19/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroceryListDelegate.h"
@class GroceryList;
@interface BaseViewController : UINavigationController <GroceryListDelegate>
@property(retain, nonatomic) GroceryList* theList;
@end
