
//
//  GLDataController.m
//  GroceryList
//
//  Created by Andre White on 8/4/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLDataController.h"
#import "GroceryItem.h"
#import "Item+CoreDataProperties.h"
#import "User+CoreDataProperties.h"
#import "NSArray+listCategories.h"
@interface GLDataController ()
@property (strong) NSFetchedResultsController* resultsController;
@property (strong) NSFetchedResultsController* favsListController;
@property (strong) NSFetchedResultsController* mainListController;
@property (strong) NSFetchedResultsController* searchResultsController;
@property (strong) NSFetchedResultsController* userResultsController;
@property (strong) NSMutableArray* favsList;
@property (strong) NSMutableArray* mainList;
@property (strong) NSMutableDictionary* itemLists;
@property (strong) NSDictionary* mainCatDict;
@property (strong) NSDictionary* favsCatDict;
@property (strong) User* user;

@end
@implementation GLDataController
@synthesize managedObjectContext;
@synthesize theResultsController;
@synthesize priceFormat;

-(instancetype) init{
    self=[super init];
    if (self) {
        [self initializeCoreData];
        [self setUp];
        priceFormat=[[NSNumberFormatter alloc]init];
        [priceFormat setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return self;
}

-(void) setUp{
    _userResultsController=nil;
    NSFetchRequest* request=[NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSSortDescriptor* nameSort=[NSSortDescriptor sortDescriptorWithKey:@"itemName" ascending:YES];
    NSArray* sorts=@[nameSort];
    [request setSortDescriptors:sorts];
    NSError* error=nil;
    _userResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    if(![_userResultsController performFetch:&error]){
        NSLog(@"failed to initialize resultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    _favsList=[[NSMutableArray alloc]init];
    _mainList=[[NSMutableArray alloc]init];
    NSArray* list=[_userResultsController fetchedObjects];
    for (Item* item in list) {
        if (item.isFavorite==YES) {
            [_favsList addObject: item];
        }
        else {
            [_mainList addObject:item];
        }
    
    }
    [_mainList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"itemCategory" ascending:YES]]];
    [_favsList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"itemCategory" ascending:YES]]];
    _mainCatDict=[[NSArray arrayWithArray:_mainList ]  categoryDictionary];
    _favsCatDict=[[NSArray arrayWithArray:_favsList]categoryDictionary];
}

-(NSArray*) getListWithType:(NSInteger) type{
    switch(type){
        case FAVORITES:
            return _favsList;
            break;
        case MAIN:
            return _mainList;
            break;
        default:
            return nil;
            break;
    }
}
-(void) initializeCoreData{
    NSURL* modelURL=[[NSBundle mainBundle] URLForResource:@"GLDataModel" withExtension:@"momd"];
    NSManagedObjectModel* objectModel=[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(objectModel!=nil, @"Error initializing Managed Object Model");
    NSPersistentStoreCoordinator* storeCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:objectModel];
    NSManagedObjectContext* objectContext=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    [objectContext setPersistentStoreCoordinator:storeCoordinator];
    [self setManagedObjectContext:objectContext];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSURL* documentURL=[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
    NSURL* storeURL=[documentURL URLByAppendingPathComponent:@"DataModel.sqlite"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSError* error=nil;
        NSPersistentStoreCoordinator *storeCoordinator=[[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore* store=[storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert(store!=nil, @"Error initializing Persistant Store Coordinator: %@\n%@",[error localizedDescription],[error userInfo]);
    });
    
    
}
-(void) resultsControllerWithDelegate:(id<NSFetchedResultsControllerDelegate>) delegate{
    _resultsController=nil;
    NSFetchRequest* request=[NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSSortDescriptor* nameSort=[NSSortDescriptor sortDescriptorWithKey:@"itemName" ascending:YES];
    NSSortDescriptor* categorySort=[NSSortDescriptor sortDescriptorWithKey:@"itemCategory" ascending:YES];
    NSArray* sorts=@[categorySort, nameSort];
    [request setSortDescriptors:sorts];
    _resultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:@"itemCategory" cacheName:@"Master"];
    [_resultsController setDelegate:delegate];
    NSError* error=nil;
    if(![_resultsController performFetch:&error]){
        NSLog(@"failed to initialize resultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

-(NSNumber*) getPriceForList:(NSInteger) listType{
    NSArray* list=[self getListWithType:listType];
    double totalPrice=0;
    for (Item* item in list) {
        totalPrice+=[item.itemPrice doubleValue];
    }
    return [NSNumber numberWithDouble:totalPrice];
}

-(void) clearListWithName:(NSString*) listName{
    /*
    List* list=[_itemLists objectForKey:listName];
    for (Item* item in list.hasItems) {
        [managedObjectContext deleteObject:item];
    }
     */
}
-(void) sortListWithType:(NSInteger)listType{
    switch (listType) {
        case FAVORITES:
            [_favsList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"itemCategory" ascending:YES]]];
            _favsCatDict=[[NSArray arrayWithArray:_favsList]categoryDictionary];
            break;
        case MAIN:
            [_mainList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"itemCategory" ascending:YES]]];
            _mainCatDict=[[NSArray arrayWithArray:_mainList] categoryDictionary];
            break;
        default:
            break;
    }
}
-(NSInteger) numberOfSectionsForList:(NSInteger)listType{
    switch (listType) {
        case FAVORITES:
            return [[_favsCatDict allKeys]count];
            break;
        case MAIN:
            return [[_mainCatDict allKeys]count ];
            break;
        default:
            return 0;
            break;

    }
    return 0;
}
-(NSArray*) categoriesForList:(NSInteger)listType{
    switch (listType) {
        case FAVORITES:
            return [_favsCatDict allKeys];
            break;
        case MAIN:
            return [_mainCatDict allKeys];
            break;
        default:
            return nil;
            break;
            
    }
}
-(NSInteger) numberOfRowsForSection:(NSInteger)section InList:(NSInteger)listType{
    switch (listType) {
        case FAVORITES:
            return [[_favsCatDict objectForKey:[[_favsCatDict allKeys]objectAtIndex:section]]integerValue];
            break;
        case MAIN:
            return [[_mainCatDict objectForKey:[[_mainCatDict allKeys]objectAtIndex:section]] integerValue];
            break;
        default:
            return 0;
            break;
            
    }
    return 0;
}
-(void) removeItem:(Item*) item fromList:(NSInteger) listType{
    switch (listType) {
        case FAVORITES:
            [_favsList removeObject:item];
            [managedObjectContext deleteObject:item];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"FavoritesChanged" object:nil];
            break;
        case MAIN:
            [_mainList removeObject:item];
            [managedObjectContext deleteObject:item];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MainListChanged" object:nil];
            break;
        default:
            break;
    }
    [self sortListWithType:listType];
    [self save];
}
-(Item*) itemInList:(NSInteger) listType atIndexPath:(NSIndexPath*) indexPath{
    if (listType==MAIN) {
        NSString* cat=[[_mainCatDict allKeys] objectAtIndex:indexPath.section];
        NSArray* itemsWithCat=[_mainList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"itemCategory==%@",cat]];
        return [itemsWithCat objectAtIndex: indexPath.row];
    }
    else if (listType==FAVORITES){
        NSString* cat=[[_favsCatDict allKeys] objectAtIndex:indexPath.section];
        NSArray* itemsWithCat=[_favsList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"itemCategory==%@",cat]];
        return [itemsWithCat objectAtIndex: indexPath.row];
    }
    return nil;
}
-(BOOL) yaFav:(Item*) item{
    NSString* name=item.itemName;
    NSString* specs=item.itemSpecs;
    BOOL isN=NO;
    for (Item* grcyItem in _favsList) {
        if ([name isEqualToString:grcyItem.itemName]&&[specs isEqualToString:grcyItem.itemSpecs]) {
            isN=YES;
            break;
        }
    }
    return isN;
}
-(void) addItem:(Item*)item toList:(NSInteger) listType{
    switch (listType) {
        case FAVORITES:
            if (![self yaFav:item]) {
                [_favsList addObject:item];
                item.isFavorite=YES;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"FavoritesChanged" object:nil];
            }
            break;
        case MAIN:
            [_mainList addObject:item];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MainListChanged" object:nil];
            break;
        default:
            break;
    }
    [self sortListWithType:listType];
    [self save];

}

-(void) save{
    NSError* error= nil;
    if ([[self managedObjectContext] hasChanges]) {
        if([[self managedObjectContext] save:&error]==NO){
                NSAssert(NO, @"Error Saving Context: %@\n%@", [error localizedDescription],[error userInfo]);
        }
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
    }

}

@end
