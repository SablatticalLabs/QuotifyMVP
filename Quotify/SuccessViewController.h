//
//  SuccessViewController.h
//  Quotify
//
//  Created by Lior Sabag on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Quote.h"
#import "FBConnect.h"
#import "Utility.h"
#import "QuoteWebViewController.h"



@interface SuccessViewController : UIViewController {
    
    UIButton *theNewQuoteButton;
    Quote *quote;
}


@property (nonatomic, strong) IBOutlet UIButton *theNewQuoteButton;
@property (nonatomic, strong) Quote *quote;

- (id)initWithQuote:(Quote *)theQuote;
- (void)displayQuote:(Quote *)theQuote;
- (IBAction)newQuotePressed:(id)sender;

@end
