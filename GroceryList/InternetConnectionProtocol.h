//
//  InternetConnectionProtocol.h
//  GroceryList
//
//  Created by Andre White on 7/22/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UITableViewCell;
@class UIImage;
@protocol InternetConnectionProtocol <NSObject>
@optional
-(void) QueryResultsWith:(NSData*) data response:(NSURLResponse*) response andError:(NSError*) error;
-(void) ImageResultsWith:(NSURL*) location response:(NSURLResponse*) response andError:(NSError*) error;
-(void) ThumbImageResultsWith:(NSURL*) location response:(NSURLResponse*) response andError:(NSError*) error;
-(void) XMLResults:(NSArray*) results andError:(NSError*)error;
-(void) DownloadProgress:(NSNumber*) progress;
-(void) theImage: (UIImage*)image forCell:(UITableViewCell*) cell;
@end
