//
//  GroceryList.h
//  GroceryList
//
//  Created by Andre White on 7/8/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GroceryItem;
@interface GroceryList <UITableViewDataSource, UITableViewDelegate>: NSObject
@property (nonatomic, readonly)NSArray* groceryItems;
@property (nonatomic, readonly)NSNumber* totalListPrice;
-(instancetype) init;
-(BOOL) addItem:(GroceryItem*) item withQuantity:(NSNumber*)itemQuantity;
-(BOOL) removeItem:(GroceryItem*) name withQuantity:(NSNumber*)itemQuantity;
-(BOOL) removeItemAtIndex:(NSInteger) index;
-(NSNumber*) itemQuantity:(GroceryItem*) item;
-(NSNumber*) totalItemPrice:(GroceryItem*) item;
@end
