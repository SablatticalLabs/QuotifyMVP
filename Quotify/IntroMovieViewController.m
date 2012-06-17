//
//  IntroMovieViewController.m
//  Quotify
//
//  Created by Max Rosenblatt on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IntroMovieViewController.h"

@implementation IntroMovieViewController
@synthesize introMoviePlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)playIntroMovie
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    
    NSString *myFilePath = [mainBundle pathForResource: @"Q4" ofType: @"mov"];
    
    if (myFilePath == nil) {
        // Do whatever you do if the file can't be found
    }
    
    NSURL *movieURL = [NSURL URLWithString:myFilePath];
    introMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    [introMoviePlayer play];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
