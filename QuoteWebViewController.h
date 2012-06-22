//
//  QuoteWebViewController.h
//  Quotify
//
//  Created by Lior Sabag on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuoteWebViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString* quoteURL;

- (IBAction)backButton:(id)sender;

@end
