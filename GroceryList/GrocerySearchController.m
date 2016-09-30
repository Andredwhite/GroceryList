//
//  GrocerySearchController.m
//  GroceryList
//
//  Created by Andre White on 9/5/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "GrocerySearchController.h"
#import "InternetConnectionProtocol.h"
#import "InternetConnection.h"
#import "GroceryItem.h"
#import "NSArray+listCategories.h"
@interface GrocerySearchController()<InternetConnectionProtocol>
@property(retain, nonatomic) InternetConnection* connection;
@property(retain, nonatomic)NSMutableArray* resultsList;
@property(retain, nonatomic)NSMutableDictionary* byTheCategory;
@end
@implementation GrocerySearchController
-(instancetype)init{
    self=[super init];
    if(self){
        _connection=[[InternetConnection alloc]initWithDelegate:self];
        _byTheCategory=[[NSMutableDictionary alloc]init];
        _resultsList=[[NSMutableArray alloc]init];
    }
    return self;
}
-(void) searchForItemByName:(NSString *)itemName{
    //[_connection SMAPISearchQuery:itemName andType:SEARCHBYNAME];
    [_connection Semantics3Query:itemName andType:SEARCHBYUPC];

   // [_connection WalmartSearchQuery:itemName andType:SEARCHBYNAME];
}
-(NSArray*) allCategories{
    return [_byTheCategory allKeys];
}
-(NSDictionary*) resultsByCategory{
    return (NSDictionary*) _byTheCategory;
}
-(NSArray*) getListByCategory:(NSInteger)catIndex{
    return [_byTheCategory objectForKey:[[self allCategories]objectAtIndex:catIndex]];
}
-(void) QueryResultsWith:(NSData *)data response:(NSURLResponse *)response andError:(NSError *)error{
    
    NSArray* results=[_connection WalmartResultsWith:data response:response andError:error];
    for (NSDictionary* item in results) {
        GroceryItem* theItem=[[GroceryItem alloc]initGroceryItemFromWalmartResult:item];
        [theItem separateTheName:WALMART];
        [_resultsList addObject:theItem];
    }
}

-(void) XMLResults:(NSArray *)results andError:(NSError *)error{
    if (!error) {
        [_resultsList addObjectsFromArray:[results mutableCopy]];
    }
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }
    [self addToDictionaryByCategory];
}

-(void)addToDictionaryByCategory{
    _byTheCategory=[[_resultsList categoryDictionary]mutableCopy];
    for (NSString* key in [_byTheCategory allKeys]) {
        [_byTheCategory setObject:[_resultsList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"itemCat==%@",key]] forKey:key];
    }
    [_byTheCategory setObject:_resultsList forKey:@"All"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Results" object:[_byTheCategory objectForKey:@"All"]];
}
@end
