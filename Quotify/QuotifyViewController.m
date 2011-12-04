//
//  QuotifyViewController.m
//  Quotify
//
//  Created by Max Rosenblatt & Lior Sabag on 4/22/11.
//  Copyright 2011 Sablattical Labs. All rights reserved.
//

#import "QuotifyViewController.h"

@implementation QuotifyViewController


//////////////////////////////
//////////
#pragma mark Synthesizing elements of QuotifyViewController
//////////
//////////////////////////////


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
@synthesize quotifierTF;
@synthesize successViewController;
@synthesize quotifyingActivityIndicator;
@synthesize locationController;
@synthesize addSpeakerButton;
@synthesize addWitnessButton;
@synthesize facebook;

@synthesize picker = _picker;


//////////////////////////////
//////////
# pragma mark View Did Load
//////////
//////////////////////////////


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];
    
    /////// UI Tweaks //////
    ((UIScrollView *)self.view).contentSize=CGSizeMake(320, self.view.frame.size.height);
    
    quoteText.clipsToBounds = YES;
    quoteText.layer.cornerRadius = 10.0f;
    
    
    /////// Set up a new quote and comm class ///////
    currentQuote = [[Quote alloc] init];
    myComm = [[Comm alloc] init];
    myComm.delegate = self;
    
    
    /////// Request location info from location controller ///////
    locationController = [[CoreLocationController alloc] init];
	locationController.delegate = self;
	//[locationController.locationManager startUpdatingLocation];
    
    
    /////// Set up a new imagePicker ///////
    self.imgPicker = [[UIImagePickerController alloc] init];
	self.imgPicker.allowsEditing = YES;
	self.imgPicker.delegate = self;
    if ( ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]))
	{	
        self.imgPicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        self.imgPicker.showsCameraControls = YES;
    }
    else{
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    [self registerForKeyboardNotifications];
    quoteTextWasEdited = NO;
    
    
    /////// Set up Facebook Connect ///////
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
    NSLog(@"Finished Loading QVC");
}

- (void)viewDidAppear:(BOOL)animated{
    //get the email from the user defaults dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"quotifier"] objectForKey:@"email"]){
        currentQuote.quotifier = [defaults objectForKey:@"quotifier"];
        self.quotifierTF.text = [currentQuote.quotifier objectForKey:@"email"];
    }
    NSLog(@"vDA: %@", [currentQuote.quotifier objectForKey:@"email"]);
    if ([self.quotifierTF.text rangeOfString:@"@"].location == NSNotFound) {
        [self showFirstTimeSettings];
    }

//    [currentQuote.quotifier setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"quotifier"] forKey:@"email"];
//    NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"quotifier"] );
//    self.quotifierTF.text = [currentQuote.quotifier objectForKey:@"email"];
//    NSLog(@"currentQuote.quotifier: %@", self.quotifierTF.text);
//
//    if (self.quotifierTF.text == nil || [self.quotifierTF.text rangeOfString:@"@"].location == NSNotFound) {
//        [self showFirstTimeSettings];
//    }
}


- (void)showFirstTimeSettings{
    [self presentModalViewController:self.settingsViewController animated:YES];
    [self raiseFailurePopupWithTitle:@"Welcome to Quotify!" andMessage:@"Enter your email address to get started."];
}

- (void)viewDidUnload{
    [locationController.locationManager stopUpdatingLocation];
    NSLog(@"Stopped updating location");
    quoteText = nil;
    [self setSpeaker:nil];
    [self setQuoteText:nil];
    [self setWitnesses:nil];
    [self setImageBox:nil];
    [self setQuotifyButton:nil];
    [self setFirstView:nil];
    hideKeyboardButton = nil;
    [self setHideKeyboardButton:nil];
    timestampLabel = nil;
    [self setTimestampLabel:nil];
    [self setSettingsButton:nil];
    [self setSettingsView:nil];
    [self setSettingsViewController:nil];
    [self setQuotifierTF:nil];
    [self setSuccessViewController:nil];
    [self setAddPersonView:nil];
    [self setAddPersonViewController:nil];
    [self setQuotifyingActivityIndicator:nil];
    [self setLocLabel:nil];
    [self setFbButton:nil];
    [self setAddSpeakerButton:nil];
    [self setAddWitnessButton:nil];
    [super viewDidUnload];
    // Release any retained subview of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


//////////////////////////////
//////////
#pragma mark Location
//////////
//////////////////////////////

/////// Begin updating location info ///////
- (void)locationUpdate:(CLPlacemark *)location
       withCoordinates:(CLLocation *)currentLocation {
    currentQuote.location = location;
    currentQuote.currentLocation = currentLocation;    
    locLabel.text = [NSString stringWithFormat:@"%@, %@", location.thoroughfare, location.locality];
    NSLog(@"Location Updated To: %@ \n Coordinates also updated.", locLabel.text);

}


/////// Display error if location cannot be retrieved ///////
- (void)locationError:(NSError *)error {
	locLabel.text = @"Could Not Determine Location";//[error description];
}

//////////////////////////////
//////////
# pragma mark Picture
//////////
//////////////////////////////

/////// Called when the image box is pressed ///////
- (IBAction)imageBoxPressed:(id)sender {
    if ( ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]))
	{	
        UIActionSheet *pictureSourceActionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Picture", @"Choose from Library", nil];
        pictureSourceActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [pictureSourceActionSheet showFromRect:imageBox.frame inView:self.view animated:YES];
    }
    else
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentModalViewController:self.imgPicker animated:YES];
    }
}

/////// Allows the user to select a new picture from the camera or an existing one from their library ///////
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Picture"]) {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:self.imgPicker animated:YES];
    }
    else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose from Library"]){
        imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentModalViewController:self.imgPicker animated:YES];
    }
}

/////// Triggered once the user has chosen a picture ///////
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    //[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [picker dismissModalViewControllerAnimated:YES];
    
    
    /////// Add the selected image to current quote ///////
    if([info objectForKey:UIImagePickerControllerEditedImage] != nil)
        currentQuote.image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    /////// Insert the selected image into box in main view ///////
    imageBox.image = currentQuote.image;
    
    // Hide the keyboard after the user has chosen a picture
    [self hideKeyboard:nil];
    
}


//////////////////////////////
//////////
#pragma mark Add Person View
//////////
//////////////////////////////


/////// Called when the add speaker/witness button is pressed ///////    
-(IBAction)showContacts:(id)sender{
    
    // Check to see if which button was clicked. Add witnesses has tag 1
    lastButtonClickedWasWitnesses = (((UIButton *)sender).tag == 1);
    
    self.picker = [[ABPeoplePickerNavigationController alloc] init];
    
    // Set the delegates
    self.picker.delegate = self;
    self.picker.peoplePickerDelegate = self;
    
    // Display only a person's phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
                               [NSNumber numberWithInt:kABPersonEmailProperty], nil];
    
    self.picker.displayedProperties = displayedItems;
    
    // Show the people picker 
    [self presentModalViewController:self.picker animated:YES];
    //[self.picker release];	
    
}  

///////// Dismisses the people picker when cancel is pressed ///////

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    //    [peoplePicker dismissModalViewControllerAnimated:YES];
}


/////////  Called after a person's name is selected in the people picker ///////

// Called after a person has been selected by the user.
// Return YES if you want the person to be displayed.
// Return NO  to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    //If the record has only one email or no emails and one phone number no need to show details
    int numOfEmails = ABMultiValueGetCount(ABRecordCopyValue(person, kABPersonEmailProperty));
    ABPropertyID phoneOrEmail = kABPersonPhoneProperty;
    
    if ( numOfEmails == 1 || (numOfEmails == 0 && ABMultiValueGetCount(ABRecordCopyValue(person, kABPersonPhoneProperty)) == 1)){
        if (numOfEmails == 1) {
            phoneOrEmail = kABPersonEmailProperty;
        }//otherwise no email addresses so it must be a phone number
        
        if (!lastButtonClickedWasWitnesses){
            [currentQuote addSpeaker:person withProperty:phoneOrEmail andIdentifier:kABPersonLastNamePhoneticProperty];
            speaker.text = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);

            // Disable the addSpeaker button
        }
        else {
            [currentQuote addWitness:person withProperty:phoneOrEmail andIdentifier:kABPersonLastNamePhoneticProperty];
            // Adds selected person to the speaker object of the quote class ///////
        
            // Checks if a comma needs to be added
            if (![witnesses.text isEqualToString:@""]) {
                witnesses.text = [witnesses.text stringByAppendingFormat:@", %@", ABRecordCopyCompositeName(person)];
            }
            else {
                witnesses.text = [witnesses.text stringByAppendingFormat:@"%@", ABRecordCopyCompositeName(person)];
            }
        }
        [peoplePicker dismissModalViewControllerAnimated:YES];
        
        return NO;
    }
    else{
        //present details
        return YES;
    }
}

///////// Called after a property of a selected person is selected ///////

// Called after a value has been selected by the user.
// Return YES if you want default action to be performed.
// Return NO to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    if (!lastButtonClickedWasWitnesses){
        [currentQuote addSpeaker:person withProperty:property andIdentifier:identifier];
        speaker.text = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
        
        // Disable the addSpeaker button
    }
    else {
        [currentQuote addWitness:person withProperty:property andIdentifier:identifier];
        // Adds selected person to the speaker object of the quote class ///////
        
        // Checks if a comma needs to be added
        if (![witnesses.text isEqualToString:@""]) {
            witnesses.text = [witnesses.text stringByAppendingFormat:@", %@", ABRecordCopyCompositeName(person)];
        }
        else {
            witnesses.text = [witnesses.text stringByAppendingFormat:@"%@", ABRecordCopyCompositeName(person)];
        }
    }

    
    [peoplePicker dismissModalViewControllerAnimated:YES];
    return NO;
}

//called when then "+" button is pressed to create new contact
-(IBAction)addPerson:(id)sender{

        ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init];
        view.newPersonViewDelegate = self;
        
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:view];
        [self.picker presentModalViewController:nc animated:YES];
    }
    
-(IBAction)done:(id)sender{
        [self.picker.topViewController setEditing:NO animated:YES];
        self.picker.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPerson:)];
    }
    
-(IBAction)editPerson:(id)sender{
        [self.picker.topViewController setEditing:YES animated:YES];
        
        self.picker.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    }
    
-(IBAction)cancel:(id)sender{
        [self dismissModalViewControllerAnimated:YES];
    }
    
#pragma mark - UINavigationControllerDelegate
    
// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
        
        //set up the ABPeoplePicker controls here to get rid of he forced cacnel button on the right hand side but you also then have to 
        // the other views it pushes on to ensure they have to correct buttons shown at the correct time.
        
        if([navigationController isKindOfClass:[ABPeoplePickerNavigationController class]] 
           && [viewController isKindOfClass:[ABPersonViewController class]]){
            navigationController.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPerson:)];
            
            navigationController.topViewController.navigationItem.leftBarButtonItem = nil; 
        }
        else if([navigationController isKindOfClass:[ABPeoplePickerNavigationController class]]){
            navigationController.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPerson:)];
            
            navigationController.topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];  
        }
    }
    
#pragma mark - ABPersonViewControllerDelegate
    
// Called when the user selects an individual value in the Person view, identifier will be kABMultiValueInvalidIdentifier if a single value property was selected.
// Return NO if you do not want anything to be done or if you are handling the actions yourself.
// Return YES if you want the ABPersonViewController to perform its default action.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
        return YES;
    }
    
#pragma mark - ABNewPersonViewControllerDelegate
    
// Called when the user selects Save or Cancel. If the new person was saved, person will be
// a valid person that was saved into the Address Book. Otherwise, person will be NULL.
// It is up to the delegate to dismiss the view controller.
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    //called when a person is added to the address book
    if(person){
        //[self.picker ];
        //[self peoplePickerNavigationController:self.picker shouldContinueAfterSelectingPerson:person];
        if (![witnesses.text isEqualToString:@""]) {
            witnesses.text = [witnesses.text stringByAppendingFormat:@", %@", ABRecordCopyCompositeName(person)];
        }
        else {
            witnesses.text = [witnesses.text stringByAppendingFormat:@"%@", ABRecordCopyCompositeName(person)];        
        }
    }
    [newPersonView dismissModalViewControllerAnimated:YES]; 
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



//////////////////////////////
//////////
#pragma mark After Quotify is Pressed
//////////
//////////////////////////////

/////// Called when Quotify button is pressed ///////
- (IBAction)quotifyPressed:(id)sender {
    [locationController.locationManager stopUpdatingLocation];
    NSLog(@"Stopped updating location");
    
  /////// Check if quoteText was edited ///////
    if(([quoteText.text rangeOfString:@"What was said?"].location == NSNotFound)
       /////// Check that quoteText and speaker are not blank ///////
       && !([quoteText.text isEqualToString:@""]) && !([speaker.text isEqualToString:@""]))
        
        /////// Assign information to the current quote ///////
    {
        currentQuote.text = quoteText.text;
        //currentQuote.speaker = (NSString *)speaker.text;
        //currentQuote.witnesses = [NSDictionary dictionaryWithObjects:[witnesses.text componentsSeparatedByString:@","] 
        //                                                     forKeys:[witnesses.text componentsSeparatedByString:@","]];
                              
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

- (IBAction)settingsPressed:(id)sender {
    [self presentModalViewController:self.settingsViewController animated:YES];
}

- (IBAction)emailEditingEnded:(id)sender {
    //save this forever (settings file)
    [currentQuote.quotifier setValue:quotifierTF.text forKey:@"email"];
    NSLog(@"emEE: %@", currentQuote.quotifier);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:currentQuote.quotifier forKey:@"quotifier"];
    [prefs synchronize];
}

- (IBAction)backToQuoteEntry:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setupNewQuote{
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
}


//////////////////////////////
//////////
#pragma mark Facebook Connect
//////////
//////////////////////////////


/////// These are all of the default, required Facebook Connect methods ///////
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
    self.quotifierTF.text = [fbUserInfoDict objectForKey:@"email"];
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

//////////////////////////////
//////////
#pragma mark Keyboard and Textbox Methods
//////////
//////////////////////////////

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
    [locationController.locationManager startUpdatingLocation];
    NSLog(@"Started updating location");
    
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
        self.timestampLabel.text = currentQuote.timeString;
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    ((UIScrollView *)self.view).contentInset = contentInsets;
    ((UIScrollView *)self.view).scrollIndicatorInsets = contentInsets;
}

@end
