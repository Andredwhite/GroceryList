//
//  GroceryList.m
//  GroceryList
//
//  Created by Andre White on 7/8/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "GroceryList.h"
#import "GroceryItem.h"
@interface GroceryList ()
@property (retain, nonatomic) NSMutableArray* listOfItems;
@property (retain, nonatomic) NSMutableDictionary* itemsAndQuantities;
-(BOOL) itemInList:(GroceryItem*) item;
-(BOOL) listEmpty;
@end


@implementation GroceryList
@synthesize totalListPrice;
-(instancetype) init{
    self=[super init];
    if (self){
        _listOfItems= [[NSMutableArray alloc] init];
        _itemsAndQuantities= [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(BOOL)addItem:(GroceryItem *)item withQuantity:(NSNumber *)amountToAdd{
    if (([self itemInList:item])) {
        int currentQuantity= [[_itemsAndQuantities objectForKey:item.name]intValue];
        currentQuantity=currentQuantity+[amountToAdd intValue];
        [_itemsAndQuantities setObject:[[NSNumber alloc]initWithInt:currentQuantity] forKey:item.name];
        return true;
    }
    else{
        [_itemsAndQuantities setObject:amountToAdd forKey:item.name];
        [_listOfItems addObject:item];
        return true;
    }
    return false;
}

-(BOOL) removeItem:(GroceryItem *)item withQuantity:(NSNumber *)amountToRemove{
    if ([self itemInList:item]) {
        int currentQuantity=[[_itemsAndQuantities objectForKey:item.name] intValue];
        if(currentQuantity>=1&&[amountToRemove intValue]<=currentQuantity){
            currentQuantity=currentQuantity-[amountToRemove intValue];
            if (currentQuantity==0){
                [_listOfItems removeObject:item];
                [_itemsAndQuantities removeObjectForKey:item.name];
                return true;
            }
            else{
                [_itemsAndQuantities setObject:[[NSNumber alloc]initWithInt:(currentQuantity)] forKey:item.name];
                return true;
            }
        }
    }
    return false;
    
    
}
-(BOOL) removeItemAtIndex: (NSInteger) index{
    GroceryItem* deletable=[_listOfItems objectAtIndex:index];
    return [self removeItem:deletable withQuantity:[_itemsAndQuantities objectForKey:deletable.name]];
}
-(BOOL) listEmpty{
    if ([_listOfItems count]==0) {
        return true;
    }
    else
        return false;
}
-(NSNumber*) totalListPrice{
    if ([self listEmpty]) {
        return @0.00;
    }
    else{
        float totalprice=0.00;
        for (GroceryItem* item in _listOfItems) {
            totalprice= totalprice+[[self totalItemPrice:item] floatValue];
        }
        return [[NSNumber alloc]initWithFloat:totalprice];

    }
}
-(NSNumber*) itemQuantity:(GroceryItem*) item{
    if ([self itemInList:item]) {
        return [_itemsAndQuantities objectForKey:item.name];
    }
    else return nil;
    
}
-(NSNumber*) totalItemPrice:(GroceryItem*) item{
    if ([self itemInList:item]) {
        return [[NSNumber alloc]initWithFloat:([item.priceperitem floatValue]*[[_itemsAndQuantities objectForKey:item.name]floatValue]) ];
    }
    else
        return nil;
}
-(NSArray*) groceryItems{
    return _listOfItems;
}
-(BOOL) itemInList:(GroceryItem *)item{
    NSNumber* num=[_itemsAndQuantities objectForKey:item.name];
    if (num!=nil) {
        return true;
    }
    else
        return false;
}

@end
