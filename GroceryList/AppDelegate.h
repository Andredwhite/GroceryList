//
//  AppDelegate.h
//  GroceryList
//
//  Created by Andre White on 7/7/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class GLDataController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GLDataController* dataController;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
- (void)saveContext;


@end

