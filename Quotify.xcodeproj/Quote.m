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

// This crashes if the user doesn't input anything. We should check that field aren't blank before calling this method.
-(NSDictionary *)getQuoteAsDictionary{//Get Location happening
    NSArray *keys = [NSArray arrayWithObjects:@"quotifier", @"quote_text", @"speaker", @"witnesses", @"time", @"location", /*@"coordinate",*/ nil];
    NSArray *objects = [NSArray arrayWithObjects: self.quotifier, self.text, self.speaker, self.witnesses, self.timeString, self.getLocationAsText, /*self.getLocationAsCoordinate,*/ nil];
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
        propertyString = @"email";//[propertyString stringByAppendingString:@" email"];
    }
    else if(property == kABPersonPhoneProperty){
        propertyString = @"phone";//[propertyString stringByAppendingString:@" phone"];
    }

    
    [self.speaker removeAllObjects];
    [self.speaker setValue:(__bridge_transfer NSString*)ABRecordCopyCompositeName(person) forKey:@"name"];
    [self.speaker setValue:(__bridge_transfer NSString*)(ABMultiValueCopyValueAtIndex(multi, index)) forKey:propertyString];

    NSLog(@"%@", speaker);
    CFRelease(multi);
}


-(void)addWitness:(ABRecordRef)person withProperty:(ABPropertyID)property andIdentifier:(ABMultiValueIdentifier)identifier{
    if (!self.witnesses) {
        self.witnesses = [[NSMutableArray alloc] init];
    }
    
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    multi = ABRecordCopyValue(person, property);
    int index;
    if(identifier == kABPersonLastNamePhoneticProperty){//why?? there was a reason for this...
        index = 0;
    }
    else {
        index = ABMultiValueGetIndexForIdentifier(multi, identifier);
    }
    
    NSString * propertyString = (__bridge_transfer NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(multi, index));
    if (property == kABPersonEmailProperty) {
        propertyString = @"email";//[propertyString stringByAppendingString:@" email"];
    }
    else if(property == kABPersonPhoneProperty){
        propertyString = @"phone";//[propertyString stringByAppendingString:@" phone"];
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

- (void)clearWitnesses{
    [witnesses removeAllObjects];
}

- (id)init {
    self = [super init];
    if (self) {
        self.quotifier = [[NSMutableDictionary alloc] init];
        [self.quotifier setValue:@"" forKey:@"email"];
        
        self.witnesses = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.quotifier = [decoder decodeObjectForKey:@"quotifier"];
        self.speaker = [decoder decodeObjectForKey:@"quotifier"];
        self.text = [decoder decodeObjectForKey:@"text"];
        self.timeString = [decoder decodeObjectForKey:@"timeString"];
        self.postID = [decoder decodeObjectForKey:@"postID"];
        self.UrlWhereQuoteIsPosted = [decoder decodeObjectForKey:@"UrlWhereQuoteIsPosted"];
        self.witnesses = [decoder decodeObjectForKey:@"witnesses"];
        self.location = [decoder decodeObjectForKey:@"location"];
        self.currentLocation = [decoder decodeObjectForKey:@"currentLocation"];
        self.image = [UIImage imageWithData:[decoder decodeObjectForKey:@"image"]];
    }
    return self;    
}

- (void)encodeWithCoder:(NSCoder *)encoder {  
    [encoder encodeObject:quotifier forKey:@"quotifier"];
    [encoder encodeObject:speaker forKey:@"speaker"];
    [encoder encodeObject:text forKey:@"text"];
    [encoder encodeObject:timeString forKey:@"timeString"];
    [encoder encodeObject:postID forKey:@"postID"];
    [encoder encodeObject:UrlWhereQuoteIsPosted forKey:@"UrlWhereQuoteIsPosted"];
    [encoder encodeObject:witnesses forKey:@"witnesses"];
    [encoder encodeObject:UIImagePNGRepresentation(image) forKey:@"image"];
    [encoder encodeObject:location forKey:@"location"];
    [encoder encodeObject:currentLocation forKey:@"currentLocation"];
}



@end
