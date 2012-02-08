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

@synthesize quoteLabel;
@synthesize imageBox;
@synthesize speaker;
@synthesize locationLabel;
@synthesize quote;
@synthesize imageBoxFrame;
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
    //[(QuotifyViewController *)self.parentViewController setupNewQuote];
    //[self.parentViewController dismissModalViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}



-(void)displayQuote:(Quote *)theQuote
{
    
    //Make the witnesses string pretty
    NSArray *witnessPieces = [theQuote.getWitnessesAsString componentsSeparatedByString: @","];
    
    NSString *lastWitness = [witnessPieces objectAtIndex:[witnessPieces count]-1];
    
    NSLog(@"Last witness: %@", lastWitness);
    
    lastWitness = [lastWitness stringByAppendingFormat:@" and %@", lastWitness];
    
    NSLog(@"Last witness with 'and': %@", lastWitness);
    
    NSString *prettyWitnesses = [witnessPieces componentsJoinedByString:@", "];
    
    NSLog(@"%@", prettyWitnesses);
    
    
    self.quoteLabel.text = theQuote.text;
    [Utility resizeFontForLabel:quoteLabel maxSize:40 minSize:8];  
    self.speaker.text = [NSString stringWithFormat:@"%@",[theQuote.speaker objectForKey:@"name"]];
    //self.witnesses.text = [theQuote getWitnessesAsString];
    self.imageBox.image = theQuote.image;
    if(theQuote.image){
        [self.imageBoxFrame setHidden:NO];
        [self.imageBox setHidden:NO];
    }
    else{
        [self.imageBoxFrame setHidden:YES];
        [self.imageBox setHidden:YES];
    }
    //self.time.text = theQuote.timeString;
        
    if([theQuote.getWitnessesAsString isEqualToString:@""]){
         self.locationLabel.text = [NSString stringWithFormat:@"at %@, %@", theQuote.location.thoroughfare, theQuote.location.locality];
        [Utility resizeFontForLabel:locationLabel maxSize:45 minSize:8];
    }
    
    else{
       self.locationLabel.text = [NSString stringWithFormat:@"at %@, %@ with %@", theQuote.location.thoroughfare, theQuote.location.locality, [theQuote getWitnessesAsString]];
        [Utility resizeFontForLabel:locationLabel maxSize:18 minSize:8];
    }
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
    CALayer *l = [imageBox layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    [self displayQuote:self.quote];
}

- (void)viewDidUnload
{
    [self setImageBox:nil];
    [self setSpeaker:nil];
    [self setLocationLabel:nil];
    [self setTheNewQuoteButton:nil];
    [self setQuoteLabel:nil];
    [self setImageBoxFrame:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
