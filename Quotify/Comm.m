//
//  Comm.m
//  Quotify
//
//  Created by Max Rosenblatt on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Comm.h"


@implementation Comm

@synthesize quoteToSend, quoteTextSentSuccessfully, delegate;

NSString * const sendQuoteToURL = @"http://www.quotify.it/api/addquote";
NSString * const sendImageToURLwithPrefix = @"http://quotify.it/api/postphoto/";


-(void)sendQuote:(Quote*)theQuote{
    //Send JSON data
    
    // Send HTTP POST request and get response
	//NSString* response = 
    [self sendHTTPrequest:theQuote.getQuoteAsJSONString];
    self.quoteToSend = theQuote;
}

- (void)sendHTTPrequest:(NSString*)myData{
	NSMutableURLRequest *request = 
	[NSMutableURLRequest requestWithURL:[NSURL URLWithString:sendQuoteToURL] 
                            cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                        timeoutInterval:30];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[myData dataUsingEncoding:NSUTF8StringEncoding]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

	
	// Make asynchronous request
	/*NSURLConnection *urlConnection =*/ [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"urlResponse: %@",response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString* dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"urlData: %@",dataAsString);
    NSDictionary* result = [dataAsString JSONValue];
    [dataAsString release];
    
    NSNumber *n_Success = [result objectForKey:@"success"];
    if (n_Success != nil)//quoteText Sent... 
    {
        self.quoteToSend.UrlWhereQuoteIsPosted = [result valueForKey:@"url"];
        self.quoteToSend.postID = [result valueForKey:@"guid"];
        self.quoteTextSentSuccessfully = ([n_Success intValue]== 1);
        [[self delegate] quoteTextSent:self.quoteTextSentSuccessfully];
    }
    else if([result objectForKey:@"Success"])//quoteImage Sent...
    {
        [[self delegate] quoteImageSent:1];
    }
    else //Neither was sent
    {
        [[self delegate] quoteTextSent:0];
    }
    //[connection release]; probably caused a crash because not ours to release
}


-(void)addImage:(UIImage*)theImage toQuoteWithID:(NSString*)postID{
    //Send data
    //Return bool valued success
    //Handle failure in controller
    /*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 0.9
	 */
	NSData *imageData = UIImageJPEGRepresentation(theImage, 0.9);
	// setting up the URL to post to
    NSString *urlString = [sendImageToURLwithPrefix stringByAppendingString:postID]; 
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[NSData dataWithData:imageData]];
    
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	/*NSURLConnection *urlConnection = */[NSURLConnection connectionWithRequest:request delegate:self];
}

@end
