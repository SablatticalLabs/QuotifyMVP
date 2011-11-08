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

//-(void)addSpeaker:(ABRecordRef)person{
//    NSLog(@"Email property: %@, Composite Name: %@", ABRecordCopyValue(person, kABPersonEmailProperty), ABRecordCopyCompositeName(person));
//    if (!self.speaker) {
//        self.speaker = [[NSMutableDictionary alloc] init];
//    }
//    
//    [self.speaker removeAllObjects];
//    [self.speaker setValue:(NSString *)ABRecordCopyValue(person, kABPersonEmailProperty) forKey:(NSString*)ABRecordCopyCompositeName(person)];
//    
// 
//    // This is if we decide to send all the info...(not complete)     
//    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
//    //ABRecordRef aRecord = ABPersonCreate();
//    CFStringRef phoneNumber, phoneNumberLabel;
//    multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
//    for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) {
//        phoneNumberLabel = ABMultiValueCopyLabelAtIndex(multi, i);
//        phoneNumber      = ABMultiValueCopyValueAtIndex(multi, i);
//        
//        [speaker setValue:(NSString*)phoneNumber forKey:(NSString*)phoneNumberLabel];
//        
//        CFRelease(phoneNumberLabel);
//        CFRelease(phoneNumber);
//    }
//    //CFRelease(person);
//    CFRelease(multi);
//
//}

-(void)addSpeaker:(ABRecordRef)person withProperty:(ABPropertyID)property andIdentifier:(ABMultiValueIdentifier)identifier{
    if (!self.speaker) {
        self.speaker = [[NSMutableDictionary alloc] init];
    }
    
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    multi = ABRecordCopyValue(person, property);
    int index;
    if(identifier == kABPersonLastNamePhoneticProperty){
        index = 0;
    }
    else {
        index = ABMultiValueGetIndexForIdentifier(multi, identifier);
    }
    
    [self.speaker removeAllObjects];
    [self.speaker setValue:ABMultiValueCopyValueAtIndex(multi, index) 
                    forKey:(NSString*)ABRecordCopyCompositeName(person)];
    CFRelease(multi);
}

//-(void)addWitness:(ABRecordRef)person{
//    //NSLog(@"Email property: %@, Composite Name: %@", ABRecordCopyValue(person, kABPersonEmailProperty), ABRecordCopyCompositeName(person));
//    if (!self.witnesses) {
//        self.witnesses = [[NSMutableDictionary alloc] init];
//    }
//    [witnesses setValue:(NSString *)ABRecordCopyValue(person, kABPersonEmailProperty) forKey:(NSString*)ABRecordCopyCompositeName(person)];
//}

-(void)addWitness:(ABRecordRef)person withProperty:(ABPropertyID)property andIdentifier:(ABMultiValueIdentifier)identifier{
    if (!self.witnesses) {
        self.witnesses = [[NSMutableDictionary alloc] init];
    }
    
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    multi = ABRecordCopyValue(person, property);
    int index;
    if(identifier == kABPersonLastNamePhoneticProperty){
        index = 0;
    }
    else {
        index = ABMultiValueGetIndexForIdentifier(multi, identifier);
    }
    
    [self.witnesses setValue:ABMultiValueCopyValueAtIndex(multi, index) 
                    forKey:(NSString*)ABRecordCopyCompositeName(person)];
    CFRelease(multi);
}



@end
