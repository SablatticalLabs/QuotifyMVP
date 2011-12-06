//
//  Quote.h
//  Quotify
//
//  Created by Max Rosenblatt on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JSON.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Quote : NSObject {
    @private
    NSMutableDictionary *quotifier;//doesnt really need to be mutable...
    NSString *text;
    NSString *timeString;
    NSString *postID;
    NSString *UrlWhereQuoteIsPosted;
    NSMutableArray *witnesses;//an array of dictionaries.
    NSMutableDictionary *speaker;
    UIImage *image; 
    CLPlacemark *location;
    CLLocation *currentLocation;
}

@property (strong) NSString *text, *timeString, *postID, *UrlWhereQuoteIsPosted;
@property (strong) NSMutableDictionary *speaker, *quotifier;
@property (strong) NSMutableArray *witnesses;
@property (strong) UIImage *image;
@property (strong) CLPlacemark *location;
@property (strong) CLLocation *currentLocation;

-(NSDictionary*)getQuoteAsDictionary;
-(NSString *)getQuoteAsJSONString;
-(NSString *)getLocationAsText;
-(NSString *)getLocationAsCoordinate; //:(CLLocation *)currentLocation;
-(void)timestamp;
-(void)addSpeaker:(ABRecordRef)person withProperty:(ABPropertyID)property andIdentifier:(ABMultiValueIdentifier)identifier;
-(void)addWitness:(ABRecordRef)person withProperty:(ABPropertyID)property andIdentifier:(ABMultiValueIdentifier)identifier;
- (NSString*) getWitnessesAsString;
- (void)clearWitnesses;


@end
