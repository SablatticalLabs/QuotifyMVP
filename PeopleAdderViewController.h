//
//  PeopleAdderViewController.h
//  Quotify
//
//  Created by Max Rosenblatt on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "three20/Three20.h"
//#import "QuotifyViewController.h"
#import "Quote.h"

@protocol PeopleAdderDelegate <NSObject>

- (void)peopleAdded:(Quote*)quote;

@end

@interface PeopleAdderViewController : UIViewController {
    
   
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *doneButton;
    Quote *quote;
    id <PeopleAdderDelegate> delegate;
    TTPickerTextField *textField;

}


@property (nonatomic, retain) IBOutlet TTPickerTextField *TTwitnesses;
@property (nonatomic, retain) Quote *quote;
@property (retain) id <PeopleAdderDelegate> delegate;
@property (nonatomic, retain) TTPickerTextField *textField;



- (IBAction)backToMainView:(id)sender;
- (IBAction)doneAddingPeople:(id)sender;
- (id)initWithQuote:(Quote*)currQuote;



@end
