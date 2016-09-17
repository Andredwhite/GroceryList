//
//  Item+CoreDataProperties.h
//  GroceryList
//
//  Created by Andre White on 8/11/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "Item+CoreDataClass.h"

@class GroceryItem;
NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties) 
+ (NSFetchRequest<Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *itemID;
@property (nullable, nonatomic, copy) NSString *itemLrgImgUrl;
@property (nullable, nonatomic, copy) NSString *itemName;
@property (nullable, nonatomic, copy) NSNumber *itemPrice;
@property (nullable, nonatomic, copy) NSString *itemThumbImgUrl;
@property (nullable, nonatomic, copy) NSString *itemUPC;
@property (nullable, nonatomic, retain) NSData *itemImgLrg;
@property (nullable, nonatomic, retain) NSData *itemImgThumb;
@property (nullable, nonatomic, copy) NSString *itemCategory;
@property (nullable, nonatomic, copy) NSString *itemLocation;
@property (nullable, nonatomic, copy) NSString *itemDesc;
@property (nullable, nonatomic, copy) NSString *itemSpecs;
@property (nonatomic, assign) BOOL isFavorite;
-(void) initImages;
-(BOOL) isSameItem:(Item*) item;
+(Item*)itemFromItem:(Item*)item inContext:(NSManagedObjectContext*)managedObjectContext;
+(Item*) itemFromGroceryItem:(GroceryItem *)item inContext:(NSManagedObjectContext*) managedObjectContext;
+(Item*)itemFromWalmartQueryResults:(NSDictionary*) result inContext:(NSManagedObjectContext*) managedObjectContext;
@end


NS_ASSUME_NONNULL_END
