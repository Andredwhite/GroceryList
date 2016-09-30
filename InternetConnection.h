//
//  InternetConnection.h
//  GroceryList
//
//  Created by Andre White on 7/21/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InternetConnectionProtocol.h"
typedef enum {
    SEARCHBYID,
    SEARCHBYNAME,
    SEARCHBYUPC
    
}QueryType;
@class UITableViewCell;
@interface InternetConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLSessionDownloadDelegate>
@property (readonly, nonatomic) id<InternetConnectionProtocol> delegate;
@property (assign, nonatomic)BOOL debug;
-(instancetype)initWithDelegate:(id<InternetConnectionProtocol>)aDelegate;
-(NSArray*) connectionDataHandler:(NSData*) data;
-(NSArray*) WalmartResultsWith:(NSData*) data response:(NSURLResponse*) response andError:(NSError*) error;
-(void)SMAPISearchQuery:(NSString*) searchItem andType:(NSInteger)queryType;
-(void) WalmartSearchQuery:(NSString*) searchItem andType:(NSUInteger) queryType;
-(void) WalmartImageForItem:(NSURL*) itemImageURL;
-(void) WalmartThumbImageForItem:(NSURL*) itemImageURL forCell:(UITableViewCell*) cell;
-(void) WalmartThumbImageForItem:(NSURL*) itemImageURL;
-(void) Semantics3Query:(NSString*) searchItem andType:(NSInteger) queryType;
@end
