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

@protocol CommDelegate
- (void)quoteTextSent:(BOOL)success;
- (void)quoteImageSent:(BOOL)success;
@end

@interface Comm : NSObject{
    
    BOOL quoteTextSentSuccessfully;
    id <CommDelegate> delegate;
    
}
extern NSString * const sendQuoteToURL;
extern NSString * const sendImageToURLwithPrefix;

@property BOOL quoteTextSentSuccessfully;
@property (retain) Quote* quoteToSend;
@property (retain) id <CommDelegate> delegate;

-(void)sendQuote:(Quote*)theQuote;
-(void)addImage:(UIImage*)theImage toQuoteWithID:(NSString*)postID;
-(void)sendHTTPrequest:(NSString*)myData;


@end
