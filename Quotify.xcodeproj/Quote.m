//
//  Quote.m
//  Quotify
//
//  Created by Max Rosenblatt on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Quote.h"
#import "JSON.h"



@implementation Quote

@synthesize quotifier, speaker, text, witnesses, image, time, postID, UrlWhereQuoteIsPosted, location;

// This crashes if the user doesn't input anything. We should check that field aren't blank before calling this method.
-(NSDictionary *)getQuoteAsDictionary{
    NSArray *keys = [NSArray arrayWithObjects:@"quotifier", @"speaker", @"text", @"witnesses", @"time", nil];
    NSArray *objects = [NSArray arrayWithObjects: @"quotifier", self.speaker, self.text, @"witness1, witness2", self.time, nil];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

-(NSString *)getQuoteAsJSONString{
    return [[self getQuoteAsDictionary] JSONRepresentation];
}

// Timestamps quote object with a formatted string 
-(void)timestamp{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	self.time = [formatter stringFromDate:[NSDate date]];
	[formatter release];
}

-(void)addWitness:(ABRecordRef)person{
    NSLog(@"Email property: %@, Composite Name: %@", ABRecordCopyValue(person, kABPersonEmailProperty), ABRecordCopyCompositeName(person));
    if (!self.witnesses) {
        self.witnesses = [[NSMutableDictionary alloc] init];
    }
    [witnesses setValue:(NSString *)ABRecordCopyValue(person, kABPersonEmailProperty) forKey:(NSString*)ABRecordCopyCompositeName(person)];
}


@end
