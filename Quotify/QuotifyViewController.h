//
//  QuotifyViewController.h
//  Quotify
//
//  Created by Max Rosenblatt on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Quote.h"
#import "Comm.h"
#import "SuccessViewController.h"
#import "CoreLocationController.h"
#import "FBConnect.h"
#import "FBLoginButton.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>



@interface QuotifyViewController : UIViewController <UIActionSheetDelegate, CommDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate, CoreLocationControllerDelegate,FBSessionDelegate, FBRequestDelegate, ABPeoplePickerNavigationControllerDelegate> {
    
    Quote *currentQuote;
    Comm *myComm;
    CoreLocationController *locationController;
    SuccessViewController *successViewController;
    FBLoginButton *fbButton;
    Facebook *facebook;
    
    UITextField *speaker;
    UITextField *witnesses;
    UITextField *quotifier;
    UITextView *quoteText;
    UIImageView *imageBox;
    
    UIImagePickerController *imgPicker;
    
   
    UIButton *settingsButton;  
    UIButton *quotifyButton; 
    UIButton *hideKeyboardButton;
    UIButton *imageBoxPressed;
    
    UIView *activeField;
    UIView *settingsView;
    UIView *addPersonView;
    UIView *firstView;
    
    UIViewController *settingsViewController;
    UIViewController *addPersonViewController;
    UILabel *timestampLabel;
    UILabel *locLabel;

  
    UIActivityIndicatorView *quotifyingActivityIndicator;
    BOOL quoteTextWasEdited;
   
    

 
//    TTPickerTextField *textField;
}

@property (nonatomic, retain) IBOutlet FBLoginButton *fbButton;
@property (nonatomic, retain) Facebook *facebook;
//@property (nonatomic, retain) IBOutlet TTPickerTextField *TTwitnesses;

@property (nonatomic, retain) IBOutlet UIView *settingsView;
@property (nonatomic, retain) IBOutlet UIView *addPersonView;
@property (nonatomic, retain) IBOutlet UILabel *locLabel;
@property (nonatomic, retain) IBOutlet UITextView *quoteText;
@property (nonatomic, retain) IBOutlet UITextField *speaker;
@property (nonatomic, retain) IBOutlet UITextField *witnesses;
@property (nonatomic, retain) IBOutlet UIImageView *imageBox;
@property (nonatomic, retain) IBOutlet UIButton *quotifyButton;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) IBOutlet UIViewController *settingsViewController;
@property (nonatomic, retain) IBOutlet UIViewController *addPersonViewController;
@property (nonatomic, retain) IBOutlet UIView *firstView;
@property (nonatomic, retain) IBOutlet UIButton *hideKeyboardButton;
@property (nonatomic, retain) IBOutlet UILabel *timestampLabel;
@property (nonatomic, retain) IBOutlet UIButton *settingsButton;
@property (nonatomic, retain) IBOutlet UITextField *quotifier;
@property (nonatomic, retain) IBOutlet SuccessViewController *successViewController;@property (nonatomic, retain) IBOutlet UIButton *addPersonButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *quotifyingActivityIndicator;
@property (nonatomic, retain) CoreLocationController *locationController;

- (IBAction)addPersonPressed:(id)sender;
- (IBAction)backToMainView:(id)sender;
- (IBAction)doneAddingPeople:(id)sender;

- (IBAction)quotifyPressed:(id)sender;
- (IBAction)imageBoxPressed:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)settingsPressed:(id)sender;
- (IBAction)backToQuoteEntry:(id)sender;
- (IBAction)emailEditingEnded:(id)sender;
- (IBAction)fbButtonClicked:(id)sender;

- (void)registerForKeyboardNotifications;
- (void)showSuccessView;
- (void)showPeopleAdderView;
- (void)peopleAdded:(Quote*)quote;
- (void)raiseFailurePopupWithTitle:(NSString *) alertTitle andMessage:(NSString *) alertMessage;
- (void)setupNewQuote;
- (void)showFirstTimeSettings;
- (void)fbLogin;
- (void)fbLogout;
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person;
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier;




@end
