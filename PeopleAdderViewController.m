//
//  PeopleAdderViewController.m
//  Quotify
//
//  Created by Max Rosenblatt on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleAdderViewController.h"
//#import "QuotifyViewController.h"
#import "three20/Three20.h"
#import "PickerDataSource.h"


@implementation PeopleAdderViewController

@synthesize TTwitnesses;
@synthesize quote;
@synthesize delegate;
@synthesize textField;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithQuote:(Quote*)currQuote{
    self = [super initWithNibName:Nil bundle:Nil];
    if (self) {
        self.quote = currQuote;
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

    // Original Stuff
//    TTwitnesses = [[TTPickerTextField alloc] initWithFrame:CGRectMake(15, 50, 290, 30)];
//    TTwitnesses.borderStyle = UITextBorderStyleRoundedRect;
//    TTwitnesses.font = [UIFont systemFontOfSize:15];
//    TTwitnesses.placeholder = @"enter text";
//    TTwitnesses.autocorrectionType = UITextAutocorrectionTypeNo;
//    TTwitnesses.keyboardType = UIKeyboardTypeDefault;
//    TTwitnesses.returnKeyType = UIReturnKeyDone;
//    TTwitnesses.clearButtonMode = UITextFieldViewModeWhileEditing;
//    TTwitnesses.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;    
//    TTwitnesses.delegate = self;
//    [self.view addSubview:TTwitnesses];
//    [TTwitnesses release];


    // Copied Stuff
    self.view.backgroundColor = TTSTYLEVAR(backgroundColor);
    
    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 270)] autorelease];
    //[[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 240, 270)];
    scrollView.backgroundColor = TTSTYLEVAR(backgroundColor);
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    scrollView.canCancelContentTouches = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(240, 270);
    [self.view addSubview:scrollView];
    
    //probably not the right way to do this (should be initialized only once...)
    textField = [[[TTPickerTextField alloc] init] autorelease];
    textField.dataSource = [[[PickerDataSource alloc] init] autorelease];;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.rightViewMode = UITextFieldViewModeAlways;
    //textField.delegate = self;
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [textField sizeToFit];
    
    //Pretty sure this isn't doing anything
    if (UITextFieldTextDidChangeNotification) {
        quote.speaker = textField.text;
    }
    
    NSLog(@"quote.speaker is: %@", quote.speaker);
    
    
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.text = @"Speaker:";
    label.font = TTSTYLEVAR(messageFont);
    label.textColor = TTSTYLEVAR(messageFieldTextColor);
    [label sizeToFit];
    label.frame = CGRectInset(label.frame, -2, 0);
    textField.leftView = label;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [textField becomeFirstResponder];
    
    [scrollView addSubview:textField];
    
    
      for (UIView *view in scrollView.subviews) {
            view.frame = CGRectMake(0, 0, 320, 480);
        }
    

}

- (void)viewDidUnload
{
    [backButton release];
    backButton = nil;
    [doneButton release];
    doneButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [backButton release];
    [doneButton release];
    [super dealloc];
}
- (IBAction)backToMainView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doneAddingPeople:(id)sender {
    //quote.speaker = [((TTPickerViewCell*)[textField.cellViews objectAtIndex:1]) label];
    quote.speaker = textField.text;
    for (TTPickerViewCell* cell in textField.cellViews) {
        [quote.witnesses setValue:[cell label] forKey:[cell label]];
    }
    NSLog(@"TextField.text is: %@", [((TTPickerViewCell*)[textField.cellViews objectAtIndex:1]) label]);
    [[self delegate] peopleAdded:[self quote]];
}

@end
