//
//  GroceryItemCDMO.h
//  GroceryList
//
//  Created by Andre White on 8/8/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface GroceryItemCDMO : NSManagedObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* itemID; //Walmart api IDnumber
@property (nonatomic, strong) NSString* itemUPC;
@property (nonatomic, strong) NSString* thumbnailImage;
@property (nonatomic, strong) NSString* largeImage;
@property (nonatomic, strong) NSNumber* price;
@end
