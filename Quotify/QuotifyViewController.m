//
//  QuotifyViewController.m
//  Quotify
//
//  Created by Max Rosenblatt & Lior Sabag on 4/22/11.
//  Copyright 2011 Sablattical Labs. All rights reserved.
//

#import "QuotifyViewController.h"

@implementation QuotifyViewController

//@synthesize TTwitnesses;
@synthesize fbButton;
@synthesize settingsView;
@synthesize addPersonView;
@synthesize locLabel;
@synthesize quoteText;
@synthesize speaker;
@synthesize witnesses;
@synthesize imageBox;
@synthesize quotifyButton;
@synthesize imgPicker;
@synthesize settingsViewController;
@synthesize addPersonViewController;
@synthesize firstView;
@synthesize hideKeyboardButton;
@synthesize timestampLabel;
@synthesize settingsButton;
@synthesize quotifier;
@synthesize successViewController;
@synthesize quotifyingActivityIndicator;
@synthesize locationController;
@synthesize addPersonButton;
@synthesize facebook;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];
    
    /////// UI Tweaks //////
    ((UIScrollView *)self.view).contentSize=CGSizeMake(320, self.view.frame.size.height);
    
    quoteText.clipsToBounds = YES;
    quoteText.layer.cornerRadius = 10.0f;
    
    
//    TTwitnesses = [[TTPickerTextField alloc] initWithFrame:CGRectMake(15, 200, 290, 30)];
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
    
    /////////////
    
    currentQuote = [[Quote alloc] init];
    myComm = [[Comm alloc] init];
    myComm.delegate = self;
    
    //get location and tag
    locationController = [[CoreLocationController alloc] init];
	locationController.delegate = self;
	[locationController.locMgr startUpdatingLocation];
    
    
    self.imgPicker = [[UIImagePickerController alloc] init];
	self.imgPicker.allowsEditing = YES;
	self.imgPicker.delegate = self;
    if ( ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]))
	{	
        self.imgPicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        self.imgPicker.showsCameraControls = YES;
    }
    else{
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self registerForKeyboardNotifications];
    quoteTextWasEdited = NO;
    
    ////// Facebook Setup //////
    
    facebook = [[Facebook alloc] initWithAppId:@"232642113419626"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if ([facebook isSessionValid]) {
        [facebook requestWithGraphPath:@"me" andDelegate:self];
        fbButton.isLoggedIn = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    currentQuote.quotifier = [[NSUserDefaults standardUserDefaults]objectForKey:@"quotifier"];
    self.quotifier.text = currentQuote.quotifier;
    if (currentQuote.quotifier == nil || [currentQuote.quotifier rangeOfString:@"@"].location == NSNotFound) {
        [self showFirstTimeSettings];
    }
}

- (void)showFirstTimeSettings{
    [self presentModalViewController:self.settingsViewController animated:YES];
    [self raiseFailurePopupWithTitle:@"Welcome to Quotify!" andMessage:@"Enter your email address to get started."];
}

- (void)viewDidUnload{
    [currentQuote release];
    [myComm release];
    [quoteText release];
    [imgPicker release];
    [facebook release];
    quoteText = nil;
    [self setSpeaker:nil];
    [self setQuoteText:nil];
    [self setWitnesses:nil];
    [self setImageBox:nil];
    [self setQuotifyButton:nil];
    [self setFirstView:nil];
    [hideKeyboardButton release];
    hideKeyboardButton = nil;
    [self setHideKeyboardButton:nil];
    [timestampLabel release];
    timestampLabel = nil;
    [self setTimestampLabel:nil];
    [self setSettingsButton:nil];
    [self setSettingsView:nil];
    [self setSettingsViewController:nil];
    [self setQuotifier:nil];
    [self setSuccessViewController:nil];
    [self setAddPersonView:nil];
    [self setAddPersonViewController:nil];
    [self setQuotifyingActivityIndicator:nil];
    [self setLocLabel:nil];
    [self setFbButton:nil];
    [self setAddPersonButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
    [quoteText release];
    [speaker release];
    [witnesses release];
    [imageBox release];
    [quotifyButton release];
    [locationController release];
    //save (if necessary) and release currentQuote
    [myComm release];
    [imageBoxPressed release];
    [firstView release];
    [hideKeyboardButton release];
    [timestampLabel release];
    [settingsButton release];
    [settingsView release];
    [settingsViewController release];
    [quotifier release];
    [successViewController release];
    [addPersonView release];
    [addPersonViewController release];
    [quotifyingActivityIndicator release];
    [locLabel release];
    [fbButton release];
    [addPersonButton release];
    [addPersonViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/******************************************** Location ********************************************************/


- (void)locationUpdate:(MKPlacemark *)location {
	//NSLog(@"coordinate: %@", location.coordinate);
    currentQuote.location = location;
    locLabel.text = [NSString stringWithFormat:@"%@, %@",location.thoroughfare, location.locality];
}

- (void)locationError:(NSError *)error {
	locLabel.text = @"Could Not Determine Location";//[error description];
}

/******************************************** No Name Yet ********************************************************/


- (IBAction)imageBoxPressed:(id)sender {
    if ( ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]))
	{	
        UIActionSheet *pictureSourceActionSheet = [[[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Picture", @"Choose from Library", nil] autorelease];
        pictureSourceActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [pictureSourceActionSheet showFromRect:imageBox.frame inView:self.view animated:YES];
    }
    else
    {
        [self presentModalViewController:self.imgPicker animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Picture"]) {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:self.imgPicker animated:YES];
    }
    else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose from Library"]){
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:self.imgPicker animated:YES];
    }
}

// Triggered once the user has chosen a picture
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)pickedImage editingInfo:(NSDictionary *)editInfo {
    if(pickedImage != nil)
        currentQuote.image = pickedImage;	
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    //release imgPicker if necessary
    
    imageBox.image = currentQuote.image;
    
    // Hide the keyboard after the user has chosen a picture
    [self hideKeyboard:nil];
    
}


#pragma mark Add Person View
/***************************************** Add Person View *******************************************************/


- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [peoplePicker dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    speaker.text = [speaker.text stringByAppendingString:(NSString*)ABRecordCopyCompositeName(person)];
    [peoplePicker dismissModalViewControllerAnimated:YES];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (IBAction)addPersonPressed:(id)sender {

    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    // Display only a person's phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
    
    
    picker.displayedProperties = displayedItems;
    // Show the picker 
    [self presentModalViewController:picker animated:YES];
    [picker release];	
    
    
   // [self showPeopleAdderView];
    
//    if (!self.peopleAdderViewController) {
//        self.peopleAdderViewController = [[PeopleAdderViewController alloc] initWithQuote:currentQuote];
//    }
//    
//    peopleAdderViewController.delegate = self;
//    
//    [self presentModalViewController:self.peopleAdderViewController animated:YES];
//    
}

- (void) peopleAdded:(Quote*)quote {
    currentQuote = quote;
    NSLog(@"quote.speaker:%@", currentQuote.speaker);
}

- (IBAction)backToMainView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];

}

- (IBAction)doneAddingPeople:(id)sender {
    [self dismissModalViewControllerAnimated:YES];

}

/************************************** After Quotify is Pressed *************************************************/

- (IBAction)quotifyPressed:(id)sender {
    //[locationController.locMgr stopUpdatingLocation];
    
    if(([quoteText.text rangeOfString:@"What was said?"].location == NSNotFound)//quoteText was edited 
       && !([quoteText.text isEqualToString:@""]) && !([speaker.text isEqualToString:@""]))//quoteText and speaker are not blank
    {
        currentQuote.text = quoteText.text;
        currentQuote.speaker = (NSString *)speaker.text;
        currentQuote.witnesses = [NSDictionary dictionaryWithObjects:[witnesses.text componentsSeparatedByString:@","] 
                                                             forKeys:[witnesses.text componentsSeparatedByString:@","]];
                              
        [quotifyingActivityIndicator startAnimating];
        [myComm sendQuote:currentQuote];//result will be delegated to quoteTextSent method
    }
    
    else {
        //Popup saying to fill in the fields
        [self raiseFailurePopupWithTitle:@"Oops!" andMessage:@"We need at least a quote and a speaker for it to be awesome..."];
    }
}

- (void) quoteTextSent:(BOOL)success {
    if (success){
        if(currentQuote.image != nil){
            [myComm addImage:imageBox.image toQuoteWithID:currentQuote.postID];
        }
        else{
            [quotifyingActivityIndicator stopAnimating];
            [self showSuccessView];
        }
        
    }
    else{
        [self raiseFailurePopupWithTitle:@"Quotification Failed!" andMessage:@"Neither your quote nor photo were sent! Check your connection and try again later..."];
    }
}

- (void) quoteImageSent:(BOOL)success {
    [quotifyingActivityIndicator stopAnimating];
    if (success) {
        [self showSuccessView];
    }
    else{
        [self raiseFailurePopupWithTitle:@"Quotification Failed!" andMessage:@"Your quote was sent successfully but the picture was not included."];
    }
}

- (void)showSuccessView{
    if (!self.successViewController) {
        self.successViewController = [[SuccessViewController alloc] initWithQuote:currentQuote];
    }
    else{
        [self.successViewController displayQuote:currentQuote];
    }
    
    [self presentModalViewController:self.successViewController animated:YES];
}





- (void)showPeopleAdderView {
    //call this when little plus button in text field is pressed
     
    
    
    // Copied Stuff
//    self.addPersonView.backgroundColor = TTSTYLEVAR(backgroundColor);
//    
//    
//    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 270)] autorelease];
//    scrollView.backgroundColor = TTSTYLEVAR(backgroundColor);
//    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    scrollView.canCancelContentTouches = NO;
//    scrollView.showsVerticalScrollIndicator = NO;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.contentSize = CGSizeMake(240, 270);
//    [self.addPersonView addSubview:scrollView];
//    
//    TTPickerTextField *textField = [[[TTPickerTextField alloc] init] autorelease];
//    textField.dataSource = [[[PickerDataSource alloc] init] autorelease];;
//    textField.autocorrectionType = UITextAutocorrectionTypeNo;
//    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    textField.rightViewMode = UITextFieldViewModeAlways;
//    textField.delegate = self;
//    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [textField sizeToFit];
//
//    
//    UILabel *label = [[[UILabel alloc] init] autorelease];
//    label.text = @"Speaker:";
//    label.font = TTSTYLEVAR(messageFont);
//    label.textColor = TTSTYLEVAR(messageFieldTextColor);
//    [label sizeToFit];
//    label.frame = CGRectInset(label.frame, -2, 0);
//    textField.leftView = label;
//    textField.leftViewMode = UITextFieldViewModeAlways;
//    [textField becomeFirstResponder];
//    
//    [scrollView addSubview:textField];
//    
//    if (UITextFieldTextDidChangeNotification) {
//        speaker.text = textField.text;
//        NSLog(@"TextField.text is: %@", textField.text);
//        NSLog(@"speaker.text is: %@", speaker.text);
//    }
//     
//    for (UIView *view in scrollView.subviews) {
//        view.frame = CGRectMake(0, 0, 320, 480);
//        //speaker.text = @"poop";
//    }
//    
//    [self presentModalViewController:self.addPersonViewController animated:YES];
//    
//    
//    
//    //speaker.text = textField.text;
//
//

}

- (IBAction)settingsPressed:(id)sender {
    [self presentModalViewController:self.settingsViewController animated:YES];
}

- (IBAction)emailEditingEnded:(id)sender {
    //save this forever (settings file)
    currentQuote.quotifier = quotifier.text;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:currentQuote.quotifier forKey:@"quotifier"];
    [prefs synchronize];
}

- (IBAction)backToQuoteEntry:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setupNewQuote{
    [currentQuote release];
    currentQuote = [[Quote alloc] init];
    quoteText.text = @"What was said?";
    quoteText.textColor = [UIColor lightGrayColor];
    quoteTextWasEdited = NO;
    speaker.text = @"";
    imageBox.image = nil;
    [self hideKeyboard:nil];

}

- (void)raiseFailurePopupWithTitle:(NSString *) alertTitle andMessage:(NSString *) alertMessage{
    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [failureAlert show];
    [failureAlert release];
}

/******************************************** Facebook ********************************************************/


- (IBAction)fbButtonClicked:(id)sender {
    if (fbButton.isLoggedIn) {
        [self fbLogout];
    } else {
        [self fbLogin];
    }
}

- (void)fbLogin {
    NSArray * permissions =  [NSArray arrayWithObjects:
                                @"user_checkins", @"email", @"offline_access",nil];
    [facebook authorize:permissions delegate:self];
}

- (void)fbLogout {
    [facebook logout:self];
}

- (void)request:(FBRequest *)request didLoad:(id)result{
    //Currently this method is custom tailored to handle the "me" request and get the email
    //This should be changed to handle all fb requests i.e. get friends list etc...
    NSLog(@"fb_email: %@", [result description]);
    NSDictionary * fbUserInfoDict = result;
    self.quotifier.text = [fbUserInfoDict objectForKey:@"email"];
    [self emailEditingEnded:nil];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"fb_error: %@", [error description]);
}

- (void)fbDidLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    fbButton.isLoggedIn = YES;
    
    //get information about the currently logged in user
    [facebook requestWithGraphPath:@"me" andDelegate:self];
    
    //get the logged-in user's friends
    //[facebook requestWithGraphPath:@"me/friends" andDelegate:self];  
}

- (void)fbDidLogout{
    fbButton.isLoggedIn = NO;
}

/******************************************** Keyboard/Textbox Navigation ********************************************************/

- (IBAction)hideKeyboard:(id)sender {
    [quoteText resignFirstResponder];
	[speaker resignFirstResponder];
	[witnesses resignFirstResponder];
}

// Allow user to move between text fields via "Next" button
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSInteger nextTag = textField.tag + 1;
	// Try to find next responder
	UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
	if (nextResponder) {
		// Found next responder, so set it.
		[nextResponder becomeFirstResponder];
	} else {
		// Not found, so remove keyboard.
		[textField resignFirstResponder];
	}
	return NO; // We do not want UITextField to insert line-breaks.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    activeField = nil;
}

- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification{
    if(((UIView*)self.quoteText).isFirstResponder){
        if (!quoteTextWasEdited) {
            quoteText.text = @"";
            quoteTextWasEdited = YES;
            quoteText.textColor = [UIColor blackColor];
        }
        
        activeField = quoteText;
    }
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    ((UIScrollView *)self.view).contentInset = contentInsets;
    ((UIScrollView *)self.view).scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [((UIScrollView *)self.view) setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    if (quoteTextWasEdited) {
        [currentQuote timestamp];
        self.timestampLabel.text = currentQuote.time;
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    ((UIScrollView *)self.view).contentInset = contentInsets;
    ((UIScrollView *)self.view).scrollIndicatorInsets = contentInsets;
}

@end
