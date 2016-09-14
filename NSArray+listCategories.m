//
//  NSArray+listCategories.m
//  GroceryList
//
//  Created by Andre White on 8/31/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "NSArray+listCategories.h"
#import "Item+CoreDataProperties.h"
#import "GroceryItem.h"
@implementation NSArray (listCategories)

-(NSDictionary*) categoryDictionary{
    NSMutableDictionary* returnable=[[NSMutableDictionary alloc]init];
    id object=[self firstObject];
    if ([object isKindOfClass:[GroceryItem class]]) {
        for (GroceryItem* item in self) {
            if ([returnable objectForKey:item.itemCat]) {
                int num=[[returnable objectForKey:item.itemCat] intValue];
                num++;
                [returnable setObject:[NSNumber numberWithInt:num] forKey:item.itemCat];
            }
            else{
                [returnable setObject:@1 forKey:item.itemCat];
            }
        }
        return returnable;
    }
    if ([object isKindOfClass:[Item class]]) {
        for (Item* item in self) {
            if ([returnable objectForKey:item.itemCategory]) {
                int num=[[returnable objectForKey:item.itemCategory] intValue];
                num++;
                [returnable setObject:[NSNumber numberWithInt:num] forKey:item.itemCategory];
            }
            else{
                [returnable setObject:@1 forKey:item.itemCategory];
            }
        }
        return returnable;
    }
    return nil;
}
@end
