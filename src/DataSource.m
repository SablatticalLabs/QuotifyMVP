//
//  DataSource.m
//  PagingScrollView
//
//  Created by Matt Gallagher on 24/01/09.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "DataSource.h"
#import "SynthesizeSingleton.h"

@implementation DataSource

SYNTHESIZE_SINGLETON_FOR_CLASS(DataSource);

//
// init
//
// Init method for the object.
//
- (id)init
{
	self = [super init];
	if (self != nil)
	{
		dataPages = [[NSArray alloc] initWithObjects:
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"Welcome to Quotify It", @"pageName",
				@"How to Quotify in 4 Easy Steps", @"pageText",
                @"successnophoto.png", @"pageImage",
				nil],
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"Step 1", @"pageName",
				@"Hear something teriffic", @"pageText",
				nil],
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"Step 2", @"pageName",
				@"Jot it into the app", @"pageText",
				nil],
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"Step 3", @"pageName",
				@"Quotify It and zip it away", @"pageText",
				nil],
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"Step 4", @"pageName",
				@"Forget about it", @"pageText",
				nil],
			nil];
	}
	return self;
}

- (NSInteger)numDataPages
{
	return [dataPages count];
}

- (NSDictionary *)dataForPage:(NSInteger)pageIndex
{
	return [dataPages objectAtIndex:pageIndex];
}

@end
