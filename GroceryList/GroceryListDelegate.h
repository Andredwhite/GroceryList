//
//  GroceryListDelegate.h
//  GroceryList
//
//  Created by Andre White on 7/19/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GroceryItem;
@protocol GroceryListDelegate <NSObject>
-(void)addItem:(GroceryItem*) item withQuantity:(NSNumber*) quantity;
-(void) GroceryListUpdated;
@end
