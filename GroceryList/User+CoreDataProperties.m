//
//  User+CoreDataProperties.m
//  GroceryList
//
//  Created by Andre White on 8/13/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic cameraAuthorized;
@dynamic userName;
@dynamic hasLists;

@end
