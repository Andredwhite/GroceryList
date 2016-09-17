//
//  Item+CoreDataProperties.m
//  GroceryList
//
//  Created by Andre White on 8/11/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "Item+CoreDataProperties.h"
#import "InternetConnectionProtocol.h"
#import "InternetConnection.h"
#import "GroceryItem.h"
#import <UIKit/UIKit.h>
@interface Item () <InternetConnectionProtocol>

@end
@implementation Item (CoreDataProperties) 
+ (NSFetchRequest<Item *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Item"];
}

@dynamic itemID;
@dynamic itemLrgImgUrl;
@dynamic itemName;
@dynamic itemPrice;
@dynamic itemThumbImgUrl;
@dynamic itemUPC;
@dynamic itemImgLrg;
@dynamic itemImgThumb;
@dynamic itemCategory;
@dynamic itemLocation;
@dynamic isFavorite;
@dynamic itemDesc;
@dynamic itemSpecs;

-(void)initImages{
    InternetConnection* con= [[InternetConnection alloc]initWithDelegate:self];
    [con WalmartImageForItem:[NSURL URLWithString:[self itemLrgImgUrl]]];
    [con WalmartThumbImageForItem:[NSURL URLWithString:[self itemThumbImgUrl]]];
}

-(void)ImageResultsWith:(NSURL *)location response:(NSURLResponse *)response andError:(NSError *)error{
    if (error==nil) {
        [self setItemImgLrg:[NSData dataWithContentsOfURL:location]];
    }
}
-(void) ThumbImageResultsWith:(NSURL *)location response:(NSURLResponse *)response andError:(NSError *)error{
    if (error==nil) {
        [self setItemImgThumb:[NSData dataWithContentsOfURL:location]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ThumbUpdated" object:self];
    }
}
/* Purpose: Check if an Item is the same as another, but different instance 
   Params: Item to check against. 
   Ret: Yes if same item, NO if different.
 */

-(BOOL) isSameItem:(Item*) item{
    if ([item.itemID isEqualToNumber:self.itemID]) {
        return YES;
    }
    if ([item.itemName isEqualToString:self.itemName]&&[item.itemSpecs isEqualToString:self.itemSpecs]) {
        return YES;
    }
    else{
        return NO;
    }
}
+(Item*)itemFromItem:(Item*)item inContext:(NSManagedObjectContext*)managedObjectContext
{
    Item* returnable=[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
    returnable.itemCategory=item.itemCategory;
    returnable.itemName=item.itemName;
    returnable.itemID=item.itemID;
    returnable.itemUPC=item.itemUPC;
    returnable.itemPrice=item.itemPrice;
    returnable.itemLrgImgUrl=item.itemLrgImgUrl;
    returnable.itemThumbImgUrl=item.itemThumbImgUrl;
    returnable.itemImgLrg=item.itemImgLrg;
    returnable.itemImgThumb=item.itemImgThumb;
    returnable.itemLocation=item.itemLocation;
    returnable.itemDesc=item.itemDesc;
    returnable.itemSpecs=item.itemSpecs;
    return returnable;
}

+(Item*)itemFromWalmartQueryResults:(NSDictionary*) result inContext:(NSManagedObjectContext*) managedObjectContext{
    
    Item* returnable=[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
    returnable.itemThumbImgUrl=[result objectForKey:@"thumbnailImage"];
    returnable.itemLrgImgUrl=[result objectForKey:@"largeImage"];
    [returnable initImages];
    returnable.itemName=[result objectForKey:@"name"];
    returnable.itemPrice=[result objectForKey:@"salePrice"];
    returnable.itemID=[result objectForKey:@"itemId"];
    returnable.itemUPC=[result objectForKey:@"upc"];
    returnable.itemCategory=[result objectForKey:@"categoryPath"];
    returnable.itemLocation=@"Walmart";
    return returnable;
}
+(Item*) itemFromGroceryItem:(GroceryItem *)item inContext:(NSManagedObjectContext*) managedObjectContext{
    Item* returnable=[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
    returnable.itemLrgImgUrl=item.itemImageUrl;
    returnable.itemThumbImgUrl=item.itemThumb;
    returnable.itemImgThumb=UIImagePNGRepresentation(item.itemThumbImage);
    returnable.itemImgLrg=UIImagePNGRepresentation(item.itemImage);
    returnable.itemCategory=item.itemCat;
    returnable.itemName=item.name;
    returnable.itemID=item.itemIDWM;
    returnable.itemUPC=item.itemUPC;
    returnable.itemPrice=item.priceperitem;
    returnable.itemDesc=item.itemDesc;
    returnable.itemSpecs=item.itemSpecs;
    return returnable;
}

@end
