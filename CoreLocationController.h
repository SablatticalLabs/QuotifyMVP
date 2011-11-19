//
//  CoreLocationController.h
//  Quotify
//
//  Created by Max Rosenblatt on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "FBConnect.h"



@protocol CoreLocationControllerDelegate 
@required
- (void)locationUpdate:(MKPlacemark *)location; // Our location updates are sent here
- (void)locationError:(NSError *)error; // Any errors are sent here
@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate> {
    CLLocationManager *locMgr;
    id __unsafe_unretained delegate;
    MKReverseGeocoder *revGeoc;
    
}

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, strong) MKReverseGeocoder *revGeoc;

@end
