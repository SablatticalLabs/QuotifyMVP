//
//  CoreLocationController.m
//  Quotify
//
//  Created by Max Rosenblatt on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreLocationController.h"

@implementation CoreLocationController

@synthesize locationManager = _locationManager;
@synthesize delegate; 

// Create a new instance of CLLocationManager and set delegate as self
- (id)init {
	self = [super init];
    
	if(self != nil) {
		self.locationManager = [[CLLocationManager alloc] init]; // Create new instance of locMgr
		self.locationManager.delegate = self; // Set the delegate as self.
        self.locationManager.purpose = @"We wanna geotag your quotes!";
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	}
    
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	//if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
	//}
    CLLocation *currentLocation = [self.locationManager location];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            // Pick the best out of the possible placemarks
            
            //CLPlacemark *placemark is replacing MKPlacemark *location
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            [self.delegate locationUpdate:placemark withCoordinates:currentLocation];

        }

}];
}


@end
