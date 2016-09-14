//
//  GroceryItem.h
//  GroceryList
//
//  Created by Andre White on 7/7/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    WALMART,
    OTHER
}ItemType;
@class UIImage;
@interface GroceryItem : NSObject
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSNumber* itemIDWM; //Walmart api IDnumber
@property (nonatomic, retain) UIImage* itemImage;
@property (nonatomic, retain) NSString* itemUPC;
@property (nonatomic, retain) NSString* itemImageUrl;
@property (nonatomic, retain) NSNumber* priceperitem;
@property (nonatomic, retain) NSString* itemThumb;
@property (nonatomic, retain) NSString* itemCat;
@property (nonatomic, retain) NSString* itemDesc;
@property (nonatomic, retain) NSString* itemSpecs;
@property (nonatomic, retain) UIImage* itemThumbImage;
-(void)getTheImage;
-(instancetype) initGroceryItemWithName:(NSString*) itemName andPricePerItem: (NSNumber*) itemPrice;
-(instancetype)initGroceryItemFromWalmartResult:(NSDictionary*) result;
-(void) separateTheName:(NSInteger)type;
@end
