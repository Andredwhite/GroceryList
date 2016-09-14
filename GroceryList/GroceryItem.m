//
//  GroceryItem.m
//  GroceryList
//
//  Created by Andre White on 7/7/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "GroceryItem.h"
#import "InternetConnectionProtocol.h"
#import "InternetConnection.h"
#import <UIKit/UIKit.h>
@interface GroceryItem()<InternetConnectionProtocol>
@end
@implementation GroceryItem
@synthesize name;
@synthesize priceperitem;
@synthesize itemUPC;
@synthesize itemIDWM;
@synthesize itemImageUrl;
@synthesize itemImage;
@synthesize itemThumb;
@synthesize itemThumbImage;
@synthesize itemCat;
@synthesize itemDesc;
@synthesize itemSpecs;

-(instancetype) initGroceryItemWithName:(NSString*) itemName andPricePerItem: (NSNumber*) itemPrice{
    self= [super init];
    if(self){
        name=itemName;
        priceperitem=itemPrice;
    }
    return self;
}
-(instancetype)initGroceryItemFromWalmartResult:(NSDictionary*) result{
    self=[super init];
    if (self) {
        InternetConnection* con=[[InternetConnection alloc]initWithDelegate:self];
        itemThumb=[result objectForKey:@"thumbnailImage"];
        [con WalmartImageForItem:[NSURL URLWithString:itemThumb]];
        name=[result objectForKey:@"name"];
        priceperitem=[result objectForKey:@"salePrice"];
        itemIDWM=[result objectForKey:@"itemId"];
        itemUPC=[result objectForKey:@"upc"];
        itemImageUrl=[result objectForKey:@"largeImage"];
        itemThumb=[result objectForKey:@"thumbnailImage"];
        itemCat=[result objectForKey:@"categoryPath"];
        itemDesc=[result objectForKey:@"description"];
    }
    return self;
}
-(void)ImageResultsWith:(NSURL *)location response:(NSURLResponse *)response andError:(NSError *)error{
    [self setItemThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:location]] ];
}
-(void) getTheImage{
    InternetConnection* con=[[InternetConnection alloc]initWithDelegate:self];
    [con WalmartImageForItem:[NSURL URLWithString:itemThumb]];
}
-(void) separateTheName:(NSInteger) type{
    NSArray* nameAndWght=nil;
    switch (type) {
        case WALMART:
            nameAndWght=[self.name componentsSeparatedByString:@","];
            break;
        case OTHER:
            nameAndWght=[self.name componentsSeparatedByString:@"-"];
        default:
            break;
    }
    if (nameAndWght.count>2) {
        self.name=[nameAndWght objectAtIndex:0];
        self.itemSpecs=[nameAndWght objectAtIndex:2];
    }
    else if(nameAndWght.count==2){
        self.name=[nameAndWght objectAtIndex:0];
        self.itemSpecs=[nameAndWght objectAtIndex:1];
    }
}
@end
