//
//  Quote.h
//  Quotify
//
//  Created by Max Rosenblatt on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
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
    MKPlacemark *location;
}

@property (retain) NSString *quotifier, *text, *time, *postID, *UrlWhereQuoteIsPosted;
@property (retain) NSMutableDictionary *witnesses, *speaker;
@property (retain) UIImage *image;
@property (retain) MKPlacemark *location;

-(NSDictionary*)getQuoteAsDictionary;
-(NSString *)getQuoteAsJSONString;
-(void)timestamp;
-(void)addSpeaker:(ABRecordRef)person;
-(void)addWitness:(ABRecordRef)person;


@end
