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
#import "HistoryViewController2.h"
#import "QuoteWebViewController.h"
#import "PagingScrollViewController.h"

#import "FBConnect.h"
#import "FBLoginButton.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>



@interface QuotifyViewController : UIViewController <UIActionSheetDelegate, CommDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate, CoreLocationControllerDelegate,FBSessionDelegate, FBRequestDelegate, ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate, ABPersonViewControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MFMailComposeViewControllerDelegate> {
    
    Quote *currentQuote;
    Comm *myComm;
    CoreLocationController *locationController;
    SuccessViewController *successViewController;
    PagingScrollViewController *pagingScrollViewController;
    FBLoginButton *fbButton;
    Facebook *facebook;
    MPMoviePlayerViewController *player;
    
    UITextField *speaker;
    UITextField *witnesses;
    UITextField *quotifierEmail;
    UITextField *quotifierName;
    UITextView *quoteText;
    UIImageView *imageBox;
//    UISegmentedControl *modeSwitch;
    
    UIImagePickerController *imgPicker;
    
    ABPeoplePickerNavigationController *_picker;

    UIButton *settingsButton;  
    UIButton *quotifyButton; 
    UIButton *hideKeyboardButton;
    UIButton *imageBoxPressed;
    
    UIView *activeField;
    UIView *settingsView;
    UIView *addPersonView;
    UIView *pagingScrollViewView;
    UIView *firstView;
    
    UIViewController *settingsViewController;
    UIViewController *addPersonViewController;
    UILabel *timestampLabel;
    UILabel *locLabel;

    __weak IBOutlet UISwitch *addPersonToABSwitch;
  
    UIActivityIndicatorView *quotifyingActivityIndicator;
    BOOL quoteTextWasEdited;
    BOOL lastButtonClickedWasWitnesses;
   
    id originalSearchDelegate;

 
}

@property (nonatomic, strong) IBOutlet FBLoginButton *fbButton;
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) IBOutlet UIView *settingsView;
@property (nonatomic, strong) IBOutlet UIView *addPersonView;
@property (nonatomic, strong) IBOutlet UILabel *locLabel;
@property (nonatomic, strong) IBOutlet UITextView *quoteText;
@property (nonatomic, strong) IBOutlet UITextField *speaker;
@property (nonatomic, strong) IBOutlet UITextField *witnesses;
@property (nonatomic, strong) IBOutlet UIImageView *imageBox;
@property (nonatomic, strong) IBOutlet UIButton *quotifyButton;
@property (nonatomic, strong) UIImagePickerController *imgPicker;
@property (nonatomic, strong) IBOutlet UISegmentedControl *modeSwitch;

@property (nonatomic, strong) IBOutlet UIViewController *settingsViewController;
@property (nonatomic, strong) IBOutlet UIViewController *addPersonViewController;
@property (nonatomic, strong) IBOutlet UIViewController *pagingScrollViewController;
@property (nonatomic, strong) IBOutlet UIView *firstView;
@property (nonatomic, strong) IBOutlet UIButton *hideKeyboardButton;
@property (nonatomic, strong) IBOutlet UILabel *timestampLabel;
@property (nonatomic, strong) IBOutlet UIButton *settingsButton;
@property (nonatomic, strong) IBOutlet UITextField *quotifierEmail;
@property (nonatomic, strong) IBOutlet UITextField *quotifierName;

@property (nonatomic, strong) IBOutlet SuccessViewController *successViewController;
@property (nonatomic, strong) IBOutlet UIButton *addSpeakerButton;
@property (nonatomic, strong) IBOutlet UIButton *addWitnessButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteWitnessButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *quotifyingActivityIndicator;
@property (nonatomic, strong) CoreLocationController *locationController;

@property(nonatomic, strong) ABPeoplePickerNavigationController *picker;
@property (weak, nonatomic) IBOutlet UITextField *addedPersonName;
@property (weak, nonatomic) IBOutlet UITextField *addedPersonEmail;
@property (strong, nonatomic) IBOutlet UIButton *showHistory;

//email success message
@property (nonatomic, strong) IBOutlet UILabel *message;


@property (nonatomic, retain) MPMoviePlayerViewController *player;

- (IBAction)showEmailPicker:(id)sender;
- (IBAction)backToMainView:(id)sender;
- (IBAction)doneAddingPeople:(id)sender;
- (IBAction)quotifyPressed:(id)sender;
- (IBAction)imageBoxPressed:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)settingsPressed:(id)sender;
- (IBAction)backToQuoteEntry:(id)sender;
- (IBAction)witnessesSwiped:(id)sender;
- (IBAction)fbButtonClicked:(id)sender;
- (IBAction)showContacts:(id)sender;
- (IBAction)witnessesTouchedUp:(id)sender;
- (IBAction)showHistory:(id)sender;
- (IBAction)playVideoPressed:(id)sender;
- (IBAction)changeMode:(id)sender;



- (void)registerForKeyboardNotifications;
- (void)showSuccessView:(BOOL)showWebView;
- (void)peopleAdded:(Quote*)quote;
- (void)raiseFailurePopupWithTitle:(NSString *) alertTitle andMessage:(NSString *) alertMessage;
- (void)setupNewQuote;
- (void)showIntroMovie;
- (void)showPagingView;
- (void)showFirstTimeSettings;
- (void)fbLogin;
- (void)fbLogout;
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person;
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier;
- (void)addWitnessToBox:(NSString*)name;

-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;


@end
