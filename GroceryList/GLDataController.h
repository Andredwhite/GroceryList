//
//  GLDataController.h
//  GroceryList
//
//  Created by Andre White on 8/4/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
typedef enum {
    FAVORITES,
    MAIN,
    USER,
    
}ListType;
@class GroceryItem;
@class Item;
@class List;
@class User;
@class UITableVIew;
@interface GLDataController : NSObject
@property (strong) NSManagedObjectContext* managedObjectContext;
@property (readonly) NSFetchedResultsController* theResultsController;
@property (readonly) NSNumberFormatter* priceFormat;
@property (retain, nonatomic) NSNumber* budget;
-(BOOL) mainListOverBudget;
-(Item*) itemInList:(NSInteger) listType atIndexPath:(NSIndexPath*) indexPath;
-(NSInteger) quantityForItem:(Item*) item inList:(NSInteger) listType;
-(NSNumber*) getPriceForList:(NSInteger)listType;
-(BOOL) yaFav:(Item*) item;
-(void) addItem:(Item*)item toList:(NSInteger) listType;
-(void) removeItem:(Item*) item fromList:(NSInteger) listType;
-(NSArray*) getListWithType:(NSInteger) type;
-(void) save;
-(NSInteger) numberOfSectionsForList:(NSInteger)listType;
-(NSInteger) numberOfRowsForSection:(NSInteger)section InList:(NSInteger)listType;
-(NSArray*) categoriesForList:(NSInteger)listType;
-(User*) user;
@end
