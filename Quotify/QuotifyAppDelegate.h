//
//  QuotifyAppDelegate.h
//  Quotify
//
//  Created by Max Rosenblatt on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class QuotifyViewController;

@interface QuotifyAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> {
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet QuotifyViewController *viewController;

@end
