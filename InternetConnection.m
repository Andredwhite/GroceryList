//
//  InternetConnection.m
//  GroceryList
//
//  Created by Andre White on 7/21/16.
//  Copyright © 2016 AndreWhite. All rights reserved.
//

#import "InternetConnection.h"
#import "InternetConnectionProtocol.h"
#import "GroceryItem.h"
#import <UIKit/UIKit.h>
typedef enum{
    NAME,
    DESCRIPTION,
    CATEGORY,
    ID,
    IMAGE,
    PRICING
}parseState;
@interface InternetConnection ()<NSXMLParserDelegate>
@property (retain, nonatomic) id<InternetConnectionProtocol> theDelegate;
@property (retain, nonatomic) GroceryItem* currentItem;
@property (retain, nonatomic) NSMutableArray* items;
@property (retain, nonatomic) NSMutableString* current;
@property (assign)int state;
-(NSURL*) WalmartSearchQueryString:(NSString*) searchItem;
-(NSURL*) WalmartLookupQueryString:(NSString*) itemID;
@end

@implementation InternetConnection
@synthesize delegate;
@synthesize debug;

-(instancetype)initWithDelegate:(id<InternetConnectionProtocol>)aDelegate{
    self=[super init];
    if (self) {
        _theDelegate=aDelegate;
        if (debug) {
            NSLog(@"%@",@"Shared Internet storage created");
        }
    }
    return self;
}

-(id<InternetConnectionProtocol>)delegate{
    return _theDelegate;
}
-(void)SMAPISearchQuery:(NSString*) searchItem andType:(NSInteger)queryType{
    NSURLSession* dataSession=[NSURLSession sharedSession];
    NSURLSessionDataTask* task= [[NSURLSessionDataTask alloc]init];
    NSURL* request=[self SMAPISearchQueryString:searchItem];
    task=[dataSession dataTaskWithURL:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (debug) {
            NSLog(@"Inside the completion handler block for dataTask");
            NSLog(@"%@",data);
            NSLog(@"%@",error.localizedFailureReason);
        }
        if (!error) {
            [self connectionDataHandlerXML:data];
        }
        else{
            [_theDelegate XMLResults:nil andError:error];
        }
    }];
    [task resume];
    
}
-(void) WalmartSearchQuery:(NSString*) searchItem andType:(NSUInteger)queryType{
    
    NSURLSession* dataSession=[NSURLSession sharedSession];
    NSURLSessionDataTask* task= [[NSURLSessionDataTask alloc]init];
    NSURL* request=nil;
    switch (queryType) {
        case SEARCHBYNAME:
            request= [self WalmartSearchQueryString:searchItem];
            break;
        case SEARCHBYID:
            request= [self WalmartLookupQueryString:searchItem];
            break;
        default:
            break;
    }
    task=[dataSession dataTaskWithURL:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (debug) {
            NSLog(@"Inside the completion handler block for dataTask");
            NSLog(@"%@",data);
            NSLog(@"%@",error.localizedFailureReason);
        }
        [_theDelegate QueryResultsWith:data response:response andError:error];
    }];
    [task resume];
}

-(NSArray*) WalmartResultsWith:(NSData*) data response:(NSURLResponse*) response andError:(NSError*) error{
    NSHTTPURLResponse* httpResponse=(NSHTTPURLResponse*) response;
    if(httpResponse.statusCode!=200){
        NSString* errorString=[NSString stringWithFormat:@"Connection Failed with respond code %ld",(long)httpResponse.statusCode];
        NSLog(@"%@", errorString);
        return nil;
    }
    else{
        return [self connectionDataHandler:data];
    }
}
/*
-(void) WalmartThumbImageForItem:(NSURL*) itemImageURL forCell:(UITableViewCell*) cell{
    NSURLSession* downloadSession=[NSURLSession sharedSession];
    NSURLSessionDownloadTask* task=[[NSURLSessionDownloadTask alloc]init];
    task=[downloadSession downloadTaskWithURL:itemImageURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(debug){
            NSLog(@"Inside the completion handler block for downloadTask");
            NSLog(@"%@",location);
            NSLog(@"%@",error.localizedFailureReason);
        }
        [_theDelegate theImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:location]] forCell:cell];
        //[_theDelegate ImageResultsWith:location response:response andError:error];
    }];
    [task resume];
}
 */
-(void) WalmartThumbImageForItem:(NSURL*) itemImageURL{
    NSURLSession* downloadSession=[NSURLSession sharedSession];
    NSURLSessionDownloadTask* task=[[NSURLSessionDownloadTask alloc]init];
    task=[downloadSession downloadTaskWithURL:itemImageURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(debug){
            NSLog(@"Inside the completion handler block for downloadTask");
            NSLog(@"%@",location);
            NSLog(@"%@",error.localizedFailureReason);
        }
        [_theDelegate ThumbImageResultsWith:location response:response andError:error];
    }];
    [task resume];
}
-(void) WalmartImageForItem:(NSURL*) itemImageURL{
    NSURLSession* downloadSession=[NSURLSession sharedSession];
    NSURLSessionDownloadTask* task=[[NSURLSessionDownloadTask alloc]init];
    task=[downloadSession downloadTaskWithURL:itemImageURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(debug){
        NSLog(@"Inside the completion handler block for downloadTask");
        NSLog(@"%@",location);
        NSLog(@"%@",error.localizedFailureReason);
        }
        [_theDelegate ImageResultsWith:location response:response andError:error];
    }];
    [task resume];
}
/*
-(void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    if(debug){
        NSLog(@"Inside the completion handler block for downloadTask");
        NSLog(@"%@",location);
        NSLog(@"%@",error.localizedFailureReason);
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setHidden:YES];
        [self.imageView setImage:[UIImage imageWithData:data]];
    });
}
  
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    [_theDelegate DownloadProgress:[NSNumber numberWithFloat:progress]];
}*/

-(NSURL*) WalmartSearchQueryString:(NSString*) searchItem{
    searchItem=[searchItem stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* requestString=[NSString stringWithFormat:@"http://api.walmartlabs.com/v1/search?query=%@&format=json&apiKey=qbx2jk66swzvcgj2t8x6wuzx",searchItem];
    NSURL* walmartSearchURL=[NSURL URLWithString:requestString];
    return walmartSearchURL;
    
}

-(NSURL*) WalmartLookupQueryString:(NSString*) itemID{
    NSString* requestString=[NSString stringWithFormat:@"http://api.walmartlabs.com/v1/items/%@?format=json&apiKey=qbx2jk66swzvcgj2t8x6wuzx",itemID];
    return [[NSURL alloc]initWithString:requestString];
}

-(NSArray*) connectionDataHandler:(NSData*) data{
    NSArray* results=[[NSArray alloc]init];
#pragma fix NSERROR ALLOC INIT CHECK BEHAVIOR OF ERROR
    NSError* myErrorCatch=[[NSError alloc]init];
    id unknownObject=[NSJSONSerialization JSONObjectWithData:data
                                                     options:0
                                                       error:&myErrorCatch];
    if (myErrorCatch!=nil) {
        if ([unknownObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* resultsDictionary=unknownObject;
            results=[resultsDictionary valueForKey:@"items"];
        }
    }
    return results;
}
-(NSURL*)SMAPISearchQueryString:(NSString*) searchItem{
    searchItem=[searchItem stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString* requestString=[NSString stringWithFormat:@"http://www.SupermarketAPI.com/api.asmx/COMMERCIAL_SearchByProductName?APIKEY=bd08908132&ItemName=%@",searchItem];
    return [[NSURL alloc]initWithString:requestString];
}
-(void) connectionDataHandlerXML:(NSData*)data{
    NSXMLParser* parser=[[NSXMLParser alloc]initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    
}
-(void) parserDidStartDocument:(NSXMLParser *)parser{
    _state=-1;
    _items=[[NSMutableArray alloc]init];
}
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    if ([elementName isEqualToString:@"Product"]||[elementName isEqualToString:@"Product_Commercial"]) {
        _currentItem=[[GroceryItem alloc]init];
    }
    if ([elementName isEqualToString:@"Itemname"])
        _current=[[NSMutableString alloc] init];{
        _state=NAME;
    }
    if ([elementName isEqualToString:@"ItemDescription"]) {
        _current=[[NSMutableString alloc] init];
        _state=DESCRIPTION;
    }
    if ([elementName isEqualToString:@"ItemCategory"]) {
        _current=[[NSMutableString alloc] init];
        _state=CATEGORY;
    }
    if ([elementName isEqualToString:@"ItemID"]) {
        _current=[[NSMutableString alloc] init];
        _state=ID;
    }
    if ([elementName isEqualToString:@"ItemImage"]) {
        _current=[[NSMutableString alloc] init];
        _state=IMAGE;
    }
    if ([elementName isEqualToString:@"Pricing"]) {
        _current=[[NSMutableString alloc]init];
        _state=PRICING;
    }
}
-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"Product"]||[elementName isEqualToString:@"Product_Commercial"]) {
        [_items addObject:_currentItem];
    }
    if ([elementName isEqualToString:@"Itemname"]){
        _currentItem.name=_current;
        [_currentItem separateTheName: OTHER];
        }
    if ([elementName isEqualToString:@"ItemDescription"]) {
        _currentItem.itemDesc=_current;
    }
    if ([elementName isEqualToString:@"ItemCategory"]) {
        _currentItem.itemCat=_current;
    }
    if ([elementName isEqualToString:@"ItemImage"]) {
        _currentItem.itemThumb=_current;
        [_currentItem getTheImage];
    }
    if ([elementName isEqualToString:@"ItemID"]) {
        _currentItem.itemIDWM=[NSNumber numberWithInteger:[_current integerValue]];
    }
    if ([elementName isEqualToString:@"Pricing"]) {
        _currentItem.priceperitem=[NSNumber numberWithDouble:[_current doubleValue]];
    }
    _state++;
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
        [_current appendString:string];
}
-(void) parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString{
    if (_state==DESCRIPTION) {
        _currentItem.itemDesc=[[_currentItem itemDesc] stringByAppendingString:whitespaceString];
    }
}
-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    [_theDelegate XMLResults:nil andError:parseError];
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [_theDelegate XMLResults:_items andError:nil];
}
@end
