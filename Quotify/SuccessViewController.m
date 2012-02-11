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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    CALayer *l = [imageBox layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    [self displayQuote:self.quote];
}

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

- (NSString *)formattedWitnessString:(Quote *)theQuote{
    //Make the witnesses string pretty
    NSString *prettyWitnesses= @"";
    
    NSLog(@"%@", theQuote.getWitnessesAsString);
    
    NSArray *witnessPieces = [theQuote.getWitnessesAsString componentsSeparatedByString: @","];
    
    NSString *lastWitness = [witnessPieces objectAtIndex:[witnessPieces count]-1];
    
    NSLog(@"Last witness: %@", lastWitness);
    
    lastWitness = [NSString stringWithFormat:@" and%@", lastWitness];
    
    // Here we need to convert witnessPieces to an NSMutableArray
    NSMutableArray *tempWitnessPieces = [(NSArray*)witnessPieces mutableCopy];
    
    
    // Check if there is one witness
    if([witnessPieces count]==1){
        // After that, you can combine the NSMutableArray elements into a pretty string!    
        prettyWitnesses = [witnessPieces componentsJoinedByString:@""];
    }
    
    else {
		if([witnessPieces count]==2){            
    		// Then use replaceObjectAtIndex count-1 to overwrite the last element with lastWitness
    		[tempWitnessPieces replaceObjectAtIndex:[tempWitnessPieces count]-1 withObject:lastWitness];
            
            // After that, you can combine the NSMutableArray elements into a pretty string!    
            prettyWitnesses = [tempWitnessPieces componentsJoinedByString:@""];
		}
        
		else{
            // Then use replaceObjectAtIndex count-1 to overwrite the last element with lastWitness
    		[tempWitnessPieces replaceObjectAtIndex:[tempWitnessPieces count]-1 withObject:lastWitness];
            
            // After that, you can combine the NSMutableArray elements into a pretty string!    
            prettyWitnesses = [tempWitnessPieces componentsJoinedByString:@","];
		}
    }
    
    
    NSLog(@"The final witnesses string is:%@", prettyWitnesses);
    
    return prettyWitnesses;
}

- (void)displayQuote:(Quote *)theQuote
{
    // Display the quote
    self.quoteLabel.text = theQuote.text;
    [Utility resizeFontForLabel:quoteLabel maxSize:40 minSize:8];  
    
    // Display the name of the speaker
    self.speaker.text = [NSString stringWithFormat:@"%@",[theQuote.speaker objectForKey:@"name"]];
    
    // Show the image if there is one
    self.imageBox.image = theQuote.image;
    if(theQuote.image){
        [self.imageBoxFrame setHidden:NO];
        [self.imageBox setHidden:NO];
    }
    else{
        [self.imageBoxFrame setHidden:YES];
        [self.imageBox setHidden:YES];
        self.locationLabel.frame = CGRectMake(20, 185, 280, 74);
    }
    
    // Format the grammar of the bottom text depending on if there were witnesses or not
    if([theQuote.getWitnessesAsString isEqualToString:@""]){
        self.locationLabel.text = [NSString stringWithFormat:@"at %@, %@", theQuote.location.thoroughfare, theQuote.location.locality];
        [Utility resizeFontForLabel:locationLabel maxSize:16 minSize:8];
    }
    
    else{
        self.locationLabel.text = [NSString stringWithFormat:@"at %@, %@ with %@", theQuote.location.thoroughfare, theQuote.location.locality, [self formattedWitnessString:theQuote]];
        [Utility resizeFontForLabel:locationLabel maxSize:18 minSize:8];
    }
    
    // Unused timestamp element
    //self.time.text = theQuote.timeString;
}

- (IBAction)newQuotePressed:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
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
