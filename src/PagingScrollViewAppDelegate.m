//
//  PagingScrollViewAppDelegate.m
//  PagingScrollView
//
//  Created by Matt Gallagher on 24/01/09.
//  Copyright Matt Gallagher 2009. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "PagingScrollViewAppDelegate.h"
#import "PagingScrollViewController.h"

@implementation PagingScrollViewAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[window addSubview:pagingScrollViewController.view];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

//- (void)dealloc
//{
//    [window release];
//    [super dealloc];
//}

@end
