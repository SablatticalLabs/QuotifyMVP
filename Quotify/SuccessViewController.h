//
//  SuccessViewController.h
//  Quotify
//
//  Created by Lior Sabag on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quote.h"
#import "FBConnect.h"



@interface SuccessViewController : UIViewController {
    
    UITextView *quoteView;
    UIImageView *imageBox;
    UILabel *speaker;
    UILabel *witnesses;
    UILabel *time;
    UILabel *locationLabel;
    UIButton *newQuoteButton;
    Quote *quote;
}
@property (nonatomic, retain) IBOutlet UITextView *quoteView;
@property (nonatomic, retain) IBOutlet UIImageView *imageBox;
@property (nonatomic, retain) IBOutlet UILabel *speaker;
@property (nonatomic, retain) IBOutlet UILabel *witnesses;
@property (nonatomic, retain) IBOutlet UILabel *time;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UIButton *newQuoteButton;
@property (nonatomic, retain) Quote *quote;

- (id)initWithQuote:(Quote *)theQuote;
- (void)displayQuote:(Quote *)theQuote;
- (IBAction)newQuotePressed:(id)sender;

@end
