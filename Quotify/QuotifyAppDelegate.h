//
//  QuotifyAppDelegate.h
//  Quotify
//
//  Created by Max Rosenblatt on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "MixpanelAPI.h"

@class QuotifyViewController;
@class MixpanelAPI;

@interface QuotifyAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> {
    MixpanelAPI *mixpanel;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet QuotifyViewController *viewController;

@end
