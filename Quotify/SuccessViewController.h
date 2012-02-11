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
#import "Utility.h"



@interface SuccessViewController : UIViewController {
    
    UIImageView *imageBox;
    UILabel *speaker;
    UILabel *locationLabel;
    UIButton *theNewQuoteButton;
    Quote *quote;
}

@property (strong, nonatomic) IBOutlet UILabel *quoteLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageBox;
@property (nonatomic, strong) IBOutlet UILabel *speaker;
@property (nonatomic, strong) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) IBOutlet UIButton *theNewQuoteButton;
@property (nonatomic, strong) Quote *quote;
@property (weak, nonatomic) IBOutlet UIImageView *imageBoxFrame;

- (id)initWithQuote:(Quote *)theQuote;
- (NSString *)formattedLocationString:(Quote *)theQuote;
- (NSString *)formattedWitnessString:(Quote *)theQuote;
- (void)displayQuote:(Quote *)theQuote;
- (IBAction)newQuotePressed:(id)sender;

@end
