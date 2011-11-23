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
    NSString *quotifier;
    NSString *text;
    NSString *time;
    NSString *postID;
    NSString *UrlWhereQuoteIsPosted;
    NSMutableDictionary *witnesses;
    NSMutableDictionary *speaker;
    UIImage *image; 
    CLPlacemark *location;
    CLLocation *currentLocation;
}

@property (strong) NSString *quotifier, *text, *time, *postID, *UrlWhereQuoteIsPosted;
@property (strong) NSMutableDictionary *witnesses, *speaker;
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


@end
