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
    //UILabel *witnesses;
    //UILabel *time;
    UILabel *locationLabel;
    UIButton *theNewQuoteButton;
    Quote *quote;
}
@property (nonatomic, strong) IBOutlet UITextView *quoteView;
@property (nonatomic, strong) IBOutlet UIImageView *imageBox;
@property (nonatomic, strong) IBOutlet UILabel *speaker;
//@property (nonatomic, strong) IBOutlet UILabel *witnesses;
//@property (nonatomic, strong) IBOutlet UILabel *time;
@property (nonatomic, strong) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) IBOutlet UIButton *theNewQuoteButton;
@property (nonatomic, strong) Quote *quote;

- (id)initWithQuote:(Quote *)theQuote;
- (void)displayQuote:(Quote *)theQuote;
- (IBAction)newQuotePressed:(id)sender;

@end
