//
//  Quote.m
//  Quotify.it
//
//  Created by Max Rosenblatt and Lior Sabag on 4/26/11.
//  Copyright 2011 Sablattical Labs. All rights reserved.
//

#import "Quote.h"
#import "JSON.h"



@implementation Quote

@synthesize quotifier, speaker, text, witnesses, image, timeString, postID, UrlWhereQuoteIsPosted, location, currentLocation;


-(NSString *)getLocationAsText{
    NSString *locationAsText = [NSString stringWithFormat:@"%@, %@", self.location.thoroughfare, self.location.locality];
    return locationAsText;                        
}

-(NSString *)getLocationAsCoordinate{ //:(CLLocation *)currentLocation
    NSString *lat = nil;
    NSString *lng = nil;
    
    // Latititude
    {
        float deg = self.currentLocation.coordinate.latitude;
        
        NSString *direction = deg >= 0 ? @"N" : @"S";
        
        float d = floorf(abs(deg));
        float m = (deg - d)*60;
        float s = (m - floor(m)) * 60;
        
        lat = [NSString stringWithFormat:@"%i°%i'%i''%@", (int)d, (int)m, (int)s, direction];
    }
    
    // Longitude
    {
        float deg = currentLocation.coordinate.longitude;
        
        NSString *direction = deg >= 0 ? @"E" : @"W";
        
        float d = floorf(abs(deg));
        float m = (deg - d)*60;
        float s = (m - floor(m)) * 60;
        
        lng = [NSString stringWithFormat:@"%i°%i'%i''%@", (int)d, (int)m, (int)s, direction];
    }
    
    return [NSString stringWithFormat:@"%@ %@", lat, lng];
}
    
//    NSString *locationAsCoordinate = [NSString stringWithFormat:@"%g, %g", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude];
//    NSLog(@"Coordinate: %@", locationAsCoordinate);
//    return locationAsCoordinate;
//}

// This crashes if the user doesn't input anything. We should check that field aren't blank before calling this method.
-(NSDictionary *)getQuoteAsDictionary{//Get Location happening
    NSArray *keys = [NSArray arrayWithObjects:@"quotifier", @"quote_text", @"speaker", @"witnesses", @"time", @"location", @"coordinate", nil];
    NSArray *objects = [NSArray arrayWithObjects: self.quotifier, self.text, self.speaker, self.witnesses, self.timeString, self.getLocationAsText, self.getLocationAsCoordinate, nil];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
   
}

-(NSString *)getQuoteAsJSONString{
    
    NSString * jSonSon = [NSString stringWithString:[[NSDictionary dictionaryWithObjects:
                                                      [NSArray arrayWithObject:[self getQuoteAsDictionary]] 
                                                                                 forKeys:[NSArray arrayWithObject:@"quote"]] JSONRepresentation]];
    NSLog(@"%@", jSonSon);
    return jSonSon;
}

// Timestamps quote object with a formatted string 
-(void)timestamp{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	self.timeString = [formatter stringFromDate:[NSDate date]];
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
    
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, property);//ABMultiValueCreateMutable(kABMultiStringPropertyType);
    //multi = ABRecordCopyValue(person, property);
    int index;
    if(identifier == kABPersonLastNamePhoneticProperty){
        index = 0;
    }
    else {
        index = ABMultiValueGetIndexForIdentifier(multi, identifier);
    }
    
    NSString * propertyString = (__bridge_transfer NSString*)(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(multi, index)));
    if (property == kABPersonEmailProperty) {
        propertyString = [propertyString stringByAppendingString:@" email"];
    }
    else if(property == kABPersonPhoneProperty){
        propertyString = [propertyString stringByAppendingString:@" phone"];
    }

    
    [self.speaker removeAllObjects];
    [self.speaker setValue:(__bridge_transfer NSString*)ABRecordCopyCompositeName(person) forKey:@"name"];
    [self.speaker setValue:(__bridge_transfer NSString*)(ABMultiValueCopyValueAtIndex(multi, index)) forKey:propertyString];

    NSLog(@"%@", speaker);
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
        self.witnesses = [[NSMutableArray alloc] init];
    }
    
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    multi = ABRecordCopyValue(person, property);
    int index;
    if(identifier == kABPersonLastNamePhoneticProperty){//why?? there was areason for this...
        index = 0;
    }
    else {
        index = ABMultiValueGetIndexForIdentifier(multi, identifier);
    }
    
    NSString * propertyString = (__bridge_transfer NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(multi, index));
    if (property == kABPersonEmailProperty) {
        propertyString = [propertyString stringByAppendingString:@" email"];
    }
    else if(property == kABPersonPhoneProperty){
        propertyString = [propertyString stringByAppendingString:@" phone"];
    }
    NSLog(@"%@", propertyString);
    
    //create dictionary to represent the person, and add them to the witnesses array
    NSDictionary * newPerson = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:(__bridge_transfer NSString*)ABRecordCopyCompositeName(person),                                                                                                     (__bridge_transfer NSString*)(ABMultiValueCopyValueAtIndex(multi, index)),nil]
                                                           forKeys:[NSArray arrayWithObjects: @"name", propertyString, nil]];
    
    [self.witnesses addObject:newPerson];
    
    NSLog(@"%@", [witnesses objectAtIndex:0]);
    CFRelease(multi);
}

- (NSString*) getWitnessesAsString{
    NSMutableString* witnessesString = [[NSMutableString alloc] init];
    for (NSDictionary* d in self.witnesses){
        if(![witnessesString isEqualToString:@""]){
            [witnessesString appendString:@", "];
        }
            [witnessesString appendString:[d objectForKey:@"name"]];
    }
    return [NSString stringWithString:witnessesString];
}

- (id)init {
    self = [super init];
    if (self) {
        self.quotifier = [[NSMutableDictionary alloc] init];
        [self.quotifier setValue:@"empty" forKey:@"email"];
    }
    return self;
}



@end
