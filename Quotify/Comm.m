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

NSString * const sendQuoteToURL = @"http://www.quotify.it/quotes.json";
NSString * const sendImageToURLwithPrefix = @"http://quotify.it/quotes/";


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
    
    //NSNumber *n_Success = [result objectForKey:@"id"];
    if ([result objectForKey:@"created_at"])//quoteText Sent... 
    {
        self.quoteToSend.UrlWhereQuoteIsPosted = nil;//not using this for now
        self.quoteToSend.postID = [result objectForKey:@"id"];
        self.quoteTextSentSuccessfully = YES;
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


-(void)addImage:(UIImage*)theImage toQuoteWithID:(NSDecimalNumber*)postID{
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
    NSString *urlString = [[sendImageToURLwithPrefix stringByAppendingString:[postID stringValue]] stringByAppendingString:@"/quote_images.json"]; 
	NSLog(@"%@", urlString);
	// setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
	
	/*
	 now lets create the body of the post
	 */
	//NSMutableData *body = [NSMutableData data];
	//[body appendData:[NSData dataWithData:imageData]];
    
	// setting the body of the post to the reqeust
	//[request setHTTPBody:body];
	//NSLog(@"%@", request);
    
    
    
   
    //NSString *filename = @"filename";

    NSString *boundary = @"---------------------------265001916915724";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //[postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    //[postbody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imageData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    //NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //NSLog(returnString);
    
    
    
	// now lets make the connection to the web
	/*NSURLConnection *urlConnection = */[NSURLConnection connectionWithRequest:request delegate:self];
}

@end
