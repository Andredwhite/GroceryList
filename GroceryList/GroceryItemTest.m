//
//  GroceryItemTest.m
//  GroceryList
//
//  Created by Andre White on 7/8/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GroceryItem.h"

@interface GroceryItemTest : XCTestCase
@property(nonatomic, retain) GroceryItem* testItem;
@property(nonatomic, retain) NSNumber* testNumber;
@end

@implementation GroceryItemTest

- (void)setUp {
    [super setUp];
    _testItem=[[GroceryItem alloc]initGroceryItemWithName:@"testItem" andPricePerItem:@5.97];
    _testNumber=[[NSNumber alloc]initWithFloat:5.97];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssertNotNil(_testItem);
    XCTAssertNotNil(_testItem.priceperitem);
    XCTAssertNotNil(_testItem.name);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
