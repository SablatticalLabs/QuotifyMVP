//
//  SuccessViewController.m
//  Quotify
//
//  Created by Lior Sabag on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SuccessViewController.h"
#import "QuotifyViewController.h"


@implementation SuccessViewController

@synthesize quoteView;
@synthesize imageBox;
@synthesize speaker;
@synthesize witnesses;
@synthesize time;
@synthesize locationLabel;
@synthesize quote;
@synthesize theNewQuoteButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithQuote:(Quote *)theQuote
{
    if ((self = [super init])) 
    {
        self.quote = theQuote;
    }
    
    return self;
}

- (IBAction)newQuotePressed:(id)sender 
{
    [(QuotifyViewController *)self.parentViewController setupNewQuote];
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(void)displayQuote:(Quote *)theQuote
{
    self.quoteView.text = theQuote.text;
    self.speaker.text = [NSString stringWithFormat:@"- %@",theQuote.speaker];
    self.witnesses.text = @"work, in, progress"; //theQuote.witnesses;
    self.imageBox.image = theQuote.image;
    self.time.text = theQuote.time;
    self.locationLabel.text = [NSString stringWithFormat:@"%@, %@",theQuote.location.thoroughfare, theQuote.location.locality];
    //self.location = theQuote.location;
    
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
    [self.quoteView setBackgroundColor:[UIColor clearColor]];
    [self displayQuote:self.quote];
}

- (void)viewDidUnload
{
    [self setQuoteView:nil];
    [self setImageBox:nil];
    [self setSpeaker:nil];
    [self setWitnesses:nil];
    [self setTime:nil];
    [self setLocationLabel:nil];
    [self setTheNewQuoteButton:nil];
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
