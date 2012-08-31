//
//  Comm.h
//  Quotify
//
//  Created by Max Rosenblatt on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quote.h"
#import "JSON.h"
//#import "HistoryViewController.h"

@protocol CommDelegate

- (void)quoteTextSent:(BOOL)success;
- (void)quoteImageSent:(BOOL)success;

@end

@interface Comm : NSObject <NSURLConnectionDelegate>{
    
    BOOL quoteTextSentSuccessfully;
    id <CommDelegate> delegate;
    
}

extern NSString * const sendQuoteToURL;
extern NSString * const sendImageToURL;

@property BOOL quoteTextSentSuccessfully;
@property (strong) Quote* quoteToSend;
@property (strong) id <CommDelegate> delegate;
@property (strong) NSMutableURLRequest* request;
@property (strong) NSMutableData* responseData;
@property (strong) UIViewController* historyViewController;

-(void)sendQuote:(Quote*)theQuote;
-(void)addImage:(UIImage*)theImage toQuoteWithID:(NSString*)postID;
-(void)sendHTTPrequest:(NSString*)myData;
-(void)requestQuoteListforQuotifier:(NSString*)quotifierID AndSendResultTo:(UIViewController*)hvc;
-(void)deleteQuoteWithID:(NSString *)quoteID;

@end
