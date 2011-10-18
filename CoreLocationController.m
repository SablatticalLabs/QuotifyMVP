//
//  CoreLocationController.m
//  Quotify
//
//  Created by Max Rosenblatt on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreLocationController.h"

@implementation CoreLocationController

@synthesize locMgr, delegate, revGeoc;

// Create a new instance of CLLocationManager and set delegate as self
- (id)init {
	self = [super init];
    
	if(self != nil) {
		self.locMgr = [[[CLLocationManager alloc] init] autorelease]; // Create new instance of locMgr
		self.locMgr.delegate = self; // Set the delegate as self.
        self.locMgr.purpose = @"We wanna geotag your quotes!";
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
	}
    
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
        if (revGeoc != nil) {
            [revGeoc release];
        }
        revGeoc = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
        revGeoc.delegate = self;
        [revGeoc start];
        //[self.delegate locationUpdate:revGeoc];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
		[self.delegate locationError:error];
	}
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
    [self.delegate locationUpdate:placemark];
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
    [self.delegate locationError:error];
}

// Clean up locMgr
- (void)dealloc {
	[self.locMgr release];
    //[self.revGeoc release];
	[super dealloc];
}

@end
