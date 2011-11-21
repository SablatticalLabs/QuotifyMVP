//
//  CoreLocationController.h
//  Quotify
//
//  Created by Max Rosenblatt on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>




@protocol CoreLocationControllerDelegate 
@required
- (void)locationUpdate:(CLPlacemark *)location; // Our location updates are sent here
- (void)locationError:(NSError *)error; // Any errors are sent here
@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locMgr;
    id __unsafe_unretained delegate;

    
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, unsafe_unretained) id delegate;


@end
