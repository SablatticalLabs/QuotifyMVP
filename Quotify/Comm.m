//
//  Comm.m
//  Quotify
//
//  Created by Max Rosenblatt on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Comm.h"


@implementation Comm

@synthesize quoteToSend, quoteTextSentSuccessfully, delegate, request;

NSString * const sendQuoteToURL = @"http://www.quotify.it/quotes.json";
NSString * const sendImageToURL = @"http://quotify.it/quotes/<ID>/quote_images.json";


-(void)sendQuote:(Quote*)theQuote{
    //Send JSON data
    
    // Send HTTP POST request and get response
	//NSString* response = 
    [self sendHTTPrequest:theQuote.getQuoteAsJSONString];
    self.quoteToSend = theQuote;
}

- (void)sendHTTPrequest:(NSString*)myData{
	request = 
	[NSMutableURLRequest requestWithURL:[NSURL URLWithString:sendQuoteToURL] 
                            cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                        timeoutInterval:15];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[myData dataUsingEncoding:NSUTF8StringEncoding]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

	
	// Make asynchronous request
	/*NSURLConnection *urlConnection =*/ [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //save the quote for later sending?
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"urlResponse: %@",response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString* dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"urlData: %@",dataAsString);
    NSDictionary* result = [dataAsString JSONValue];
    
    //NSNumber *n_Success = [result objectForKey:@"id"];
    if ([result objectForKey:@"created_at"] && [result objectForKey:@"quote_text"])//quoteText Sent... 
    {
        self.quoteToSend.UrlWhereQuoteIsPosted = nil;//not using this for now
        self.quoteToSend.postID = [result objectForKey:@"id"];
        self.quoteTextSentSuccessfully = YES;
        [[self delegate] quoteTextSent:self.quoteTextSentSuccessfully];
    }
    else if([result objectForKey:@"created_at"] && [result objectForKey:@"file_name"])//quoteImage Sent...
    {
        [[self delegate] quoteImageSent:1];
    }
    else //Neither was sent
    {
        [[self delegate] quoteTextSent:0];
    }
}


-(void)addImage:(UIImage*)theImage toQuoteWithID:(NSDecimalNumber*)postID{
    
    NSString *s_postID = [[postID stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSData *imageData = UIImageJPEGRepresentation(theImage, 0.9);
	// setting up the URL to post to
    NSString *urlString = [sendImageToURL stringByReplacingOccurrencesOfString:@"<ID>" withString:s_postID];
	NSLog(@"%@", urlString);
    //creating the url request:
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url];
	
	//adding header information:
	[postRequest setHTTPMethod:@"POST"];
	
	NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	//setting up the body:
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	//Image name (not really releveant)
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"quote_image[name]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:s_postID] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //image data and dummy filename (only extension is important)
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"quote_image[image_data]\"; filename=\"dummy.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:imageData];	
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Quote (post) ID
//    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"quote_image[quote_id]\" "] dataUsingEncoding:NSUTF8StringEncoding]];//\r\n\r\n
//	[postBody appendData:[[NSString stringWithString:s_postID] dataUsingEncoding:NSUTF8StringEncoding]];
//	[postBody appendData:[[NSString stringWithFormat:@" --%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];//\r\n
    //method call??
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"commit\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Create Quote image"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
	[postRequest setHTTPBody:postBody];
    
    //NSLog(@"%@", postBody);
    
    //send the request
	[NSURLConnection connectionWithRequest:postRequest delegate:self];
}

@end
