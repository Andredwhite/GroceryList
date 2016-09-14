//
//  GrocerySearchController.h
//  GroceryList
//
//  Created by Andre White on 9/5/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
}storeType;
@class GroceryItem;
@interface GrocerySearchController : NSObject
@property (retain, nonatomic)NSDictionary* resultsByCategory;
@property (readonly)NSArray* allCategories;
-(void) searchForItemByName:(NSString*)itemName;
-(NSArray*)getListByCategory:(NSInteger)catIndex;
@end
