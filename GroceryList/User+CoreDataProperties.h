//
//  User+CoreDataProperties.h
//  GroceryList
//
//  Created by Andre White on 8/13/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *cameraAuthorized;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *hasLists;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addHasListsObject:(NSManagedObject *)value;
- (void)removeHasListsObject:(NSManagedObject *)value;
- (void)addHasLists:(NSSet<NSManagedObject *> *)values;
- (void)removeHasLists:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
