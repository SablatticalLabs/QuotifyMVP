//
//  QuoteWebViewController.m
//  Quotify
//
//  Created by Lior Sabag on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuoteWebViewController.h"

@implementation QuoteWebViewController
@synthesize webView;
@synthesize quoteURL = _quoteURL;

-(void)setQuoteURL:(NSString *)quoteURL{
    _quoteURL = quoteURL;
}

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
    
    self.webView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"URL:%@", self.quoteURL);
    
    //NSString* searchQuery = [NSString stringWithFormat:@"http://www.google.com/"];
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:searchQuery]]];

    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.quoteURL]]];
    
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
